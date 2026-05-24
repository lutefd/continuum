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

#Preview {
    ContentView()
        .modelContainer(for: [Activity.self, ActivityLog.self, StreakRule.self], inMemory: true)
}
