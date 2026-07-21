import Foundation

struct Envelope: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var percentage: Double
    var balance: Double
    var allocatedThisCycle: Double
    var iconName: String
    var colorHex: String
    var lowBalanceThreshold: Double

    /// Fraction of the current cycle's allocation still available (0...1). Used for the progress bar.
    var remainingFraction: Double {
        guard allocatedThisCycle > 0 else { return 0 }
        return max(0, min(1, balance / allocatedThisCycle))
    }

    var isNearLimit: Bool {
        remainingFraction <= lowBalanceThreshold
    }

    static func defaultSet() -> [Envelope] {
        [
            Envelope(name: "Gastos Fijos / Alquiler", percentage: 40, balance: 0, allocatedThisCycle: 0, iconName: "house.fill", colorHex: "#4A90D9", lowBalanceThreshold: 0.15),
            Envelope(name: "Herramientas / Inversión", percentage: 15, balance: 0, allocatedThisCycle: 0, iconName: "wrench.and.screwdriver.fill", colorHex: "#9B59B6", lowBalanceThreshold: 0.15),
            Envelope(name: "Salidas / Pareja", percentage: 15, balance: 0, allocatedThisCycle: 0, iconName: "heart.fill", colorHex: "#E91E63", lowBalanceThreshold: 0.15),
            Envelope(name: "Ahorro Intocable", percentage: 20, balance: 0, allocatedThisCycle: 0, iconName: "lock.fill", colorHex: "#27AE60", lowBalanceThreshold: 0.0),
            Envelope(name: "Gastos Libres", percentage: 10, balance: 0, allocatedThisCycle: 0, iconName: "cart.fill", colorHex: "#F39C12", lowBalanceThreshold: 0.15)
        ]
    }
}

struct IncomeTransaction: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var date: Date = Date()
    var amount: Double
    var note: String
}

struct EnvelopeExpense: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var envelopeId: UUID
    var date: Date = Date()
    var amount: Double
    var note: String
}
