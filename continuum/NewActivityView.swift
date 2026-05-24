import SwiftData
import SwiftUI

struct NewActivityView: View {
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
