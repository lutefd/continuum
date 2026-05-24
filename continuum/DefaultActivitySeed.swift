import Foundation

struct DefaultActivitySeed {
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
