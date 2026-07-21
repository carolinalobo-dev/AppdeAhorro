import Foundation

enum IncomeFrequency: String, CaseIterable, Identifiable, Codable {
    case monthly
    case weekly
    case variable

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .monthly: return "Mensual"
        case .weekly: return "Semanal"
        case .variable: return "Ingresos Variables / Freelance"
        }
    }

    var iconName: String {
        switch self {
        case .monthly: return "calendar"
        case .weekly: return "calendar.badge.clock"
        case .variable: return "shuffle"
        }
    }
}
