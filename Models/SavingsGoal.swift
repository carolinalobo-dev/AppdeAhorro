import Foundation

struct SavingsContribution: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var date: Date = Date()
    var amount: Double
    var contributorName: String
}

struct SavingsGoal: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var targetAmount: Double
    var deadline: Date?
    var iconName: String
    var isShared: Bool
    var contributions: [SavingsContribution] = []

    var currentAmount: Double {
        contributions.reduce(0) { $0 + $1.amount }
    }

    var progress: Double {
        guard targetAmount > 0 else { return 0 }
        return max(0, min(1, currentAmount / targetAmount))
    }

    var remainingAmount: Double {
        max(0, targetAmount - currentAmount)
    }

    var daysRemaining: Int? {
        guard let deadline else { return nil }
        let days = Calendar.current.dateComponents([.day], from: Date(), to: deadline).day ?? 0
        return max(0, days)
    }
}

/// One point in the historical savings evolution chart (total saved across all goals at a given date).
struct SavingsHistoryPoint: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var date: Date
    var totalSaved: Double
}
