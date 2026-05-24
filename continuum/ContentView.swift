//
//  ContentView.swift
//  continuum
//
//  Created by Luis Dourado on 24/05/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Activity.name) private var activities: [Activity]
    @Query(sort: \ActivityLog.startedAt, order: .reverse) private var logs: [ActivityLog]
    @State private var isPresentingNewActivity = false

    var body: some View {
        TabView {
            NavigationStack {
                TodayView(activities: activeActivities, logs: logs, logActivity: logActivity)
                    .navigationTitle("Today")
            }
            .tabItem { Label("Today", systemImage: "sun.max") }

            NavigationStack {
                ActivitiesView(activities: activeActivities, logs: logs, logActivity: logActivity)
                    .navigationTitle("Activities")
                    .toolbar {
                        ToolbarItem {
                            Button {
                                isPresentingNewActivity = true
                            } label: {
                                Label("New Activity", systemImage: "plus")
                            }
                        }
                    }
            }
            .tabItem { Label("Activities", systemImage: "list.bullet") }

            NavigationStack {
                SettingsView(activityCount: activeActivities.count, logCount: logs.count)
                    .navigationTitle("Settings")
            }
            .tabItem { Label("Settings", systemImage: "gearshape") }
        }
        .task { seedDefaultActivitiesIfNeeded() }
        .sheet(isPresented: $isPresentingNewActivity) {
            NewActivityView()
        }
    }

    private var activeActivities: [Activity] {
        activities.filter { $0.archivedAt == nil }
    }

    private func logActivity(_ activity: Activity) {
        withAnimation {
            activity.logs.append(ActivityLog(activityId: activity.id))
            activity.updatedAt = Date()
        }
    }

    private func seedDefaultActivitiesIfNeeded() {
        guard activities.isEmpty else { return }

        for seed in DefaultActivitySeed.all {
            let activity = Activity(name: seed.name, category: seed.category, icon: seed.icon, colorName: seed.colorName)
            activity.streakRule = StreakRule(activityId: activity.id, type: .dailyCompletion, period: .day)
            modelContext.insert(activity)
        }
    }
}

private struct TodayView: View {
    let activities: [Activity]
    let logs: [ActivityLog]
    let logActivity: (Activity) -> Void

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text(Date.now, format: .dateTime.weekday(.wide).month(.wide).day())
                        .font(.headline)
                    Text("\(completedTodayCount) of \(activities.count) activities logged today")
                        .font(.title3.weight(.semibold))
                }
                .padding(.vertical, 6)
            }

            Section("Due Today") {
                if activities.isEmpty {
                    ContentUnavailableView("No activities yet", systemImage: "square.grid.2x2", description: Text("Create an activity to start building your continuum."))
                } else {
                    ForEach(activities) { activity in
                        ActivityRow(activity: activity, isLoggedToday: isLoggedToday(activity), logActivity: logActivity)
                    }
                }
            }
        }
    }

    private var completedTodayCount: Int {
        activities.filter(isLoggedToday).count
    }

    private func isLoggedToday(_ activity: Activity) -> Bool {
        logs.contains { log in
            log.activityId == activity.id && Calendar.current.isDateInToday(log.startedAt)
        }
    }
}

private struct ActivitiesView: View {
    let activities: [Activity]
    let logs: [ActivityLog]
    let logActivity: (Activity) -> Void

    var body: some View {
        List {
            ForEach(ActivityCategory.allCases) { category in
                let categoryActivities = activities.filter { $0.category == category }
                if !categoryActivities.isEmpty {
                    Section(category.displayName) {
                        ForEach(categoryActivities) { activity in
                            ActivityRow(activity: activity, isLoggedToday: isLoggedToday(activity), logActivity: logActivity)
                        }
                    }
                }
            }
        }
    }

    private func isLoggedToday(_ activity: Activity) -> Bool {
        logs.contains { log in
            log.activityId == activity.id && Calendar.current.isDateInToday(log.startedAt)
        }
    }
}

private struct ActivityRow: View {
    let activity: Activity
    let isLoggedToday: Bool
    let logActivity: (Activity) -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: activity.icon)
                .font(.title3)
                .frame(width: 32, height: 32)
                .foregroundStyle(.tint)

            VStack(alignment: .leading) {
                Text(activity.name)
                    .font(.headline)
                Text(isLoggedToday ? "Logged today" : "Not logged today")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button(isLoggedToday ? "Logged" : "Log") {
                logActivity(activity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(isLoggedToday)
        }
        .padding(.vertical, 4)
    }
}

private struct NewActivityView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var name = ""
    @State private var category: ActivityCategory = .other
    @State private var icon = "circle"

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                Picker("Category", selection: $category) {
                    ForEach(ActivityCategory.allCases) { category in
                        Text(category.displayName).tag(category)
                    }
                }
                TextField("SF Symbol", text: $icon)
            }
            .navigationTitle("New Activity")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create", action: createActivity)
                        .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }

    private func createActivity() {
        let activity = Activity(name: name.trimmingCharacters(in: .whitespacesAndNewlines), category: category, icon: icon, colorName: "accentColor")
        activity.streakRule = StreakRule(activityId: activity.id, type: .dailyCompletion, period: .day)
        modelContext.insert(activity)
        dismiss()
    }
}

private struct SettingsView: View {
    let activityCount: Int
    let logCount: Int

    var body: some View {
        List {
            Section("Data") {
                LabeledContent("Activities", value: activityCount.formatted())
                LabeledContent("Logs", value: logCount.formatted())
                LabeledContent("iCloud Sync", value: "Not configured")
                LabeledContent("HealthKit", value: "Not configured")
            }
        }
    }
}

private struct DefaultActivitySeed {
    let name: String
    let category: ActivityCategory
    let icon: String
    let colorName: String

    static let all: [DefaultActivitySeed] = [
        .init(name: "Running", category: .body, icon: "figure.run", colorName: "orange"),
        .init(name: "Swimming", category: .body, icon: "figure.pool.swim", colorName: "blue"),
        .init(name: "Cycling", category: .body, icon: "figure.outdoor.cycle", colorName: "green"),
        .init(name: "Walking", category: .body, icon: "figure.walk", colorName: "mint"),
        .init(name: "Gym", category: .body, icon: "dumbbell", colorName: "red"),
        .init(name: "Tennis", category: .body, icon: "tennis.racket", colorName: "yellow"),
        .init(name: "Yoga", category: .recovery, icon: "figure.yoga", colorName: "purple"),
        .init(name: "Piano", category: .craft, icon: "pianokeys", colorName: "indigo"),
        .init(name: "Reading", category: .mind, icon: "book", colorName: "brown"),
        .init(name: "Studying", category: .mind, icon: "graduationcap", colorName: "teal"),
        .init(name: "Cooking", category: .craft, icon: "fork.knife", colorName: "pink"),
        .init(name: "Woodworking", category: .craft, icon: "hammer", colorName: "brown"),
        .init(name: "Sleep", category: .recovery, icon: "bed.double", colorName: "blue")
    ]
}

#Preview {
    ContentView()
        .modelContainer(for: [Activity.self, ActivityLog.self, StreakRule.self], inMemory: true)
}
