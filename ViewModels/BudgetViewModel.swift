import Foundation
import Combine

final class BudgetViewModel: ObservableObject {
    @Published var envelopes: [Envelope]
    @Published var frequency: IncomeFrequency
    @Published var incomeHistory: [IncomeTransaction]
    @Published var expenseHistory: [EnvelopeExpense]

    private let envelopesStore = PersistenceStore<[Envelope]>(fileName: "envelopes.json")
    private let frequencyStore = PersistenceStore<IncomeFrequency>(fileName: "frequency.json")
    private let incomeStore = PersistenceStore<[IncomeTransaction]>(fileName: "income.json")
    private let expenseStore = PersistenceStore<[EnvelopeExpense]>(fileName: "expenses.json")

    var totalBalance: Double {
        envelopes.reduce(0) { $0 + $1.balance }
    }

    var totalPercentage: Double {
        envelopes.reduce(0) { $0 + $1.percentage }
    }

    init() {
        self.envelopes = envelopesStore.load() ?? Envelope.defaultSet()
        self.frequency = frequencyStore.load() ?? .variable
        self.incomeHistory = incomeStore.load() ?? []
        self.expenseHistory = expenseStore.load() ?? []
    }

    func registerIncome(amount: Double, note: String) {
        guard amount > 0 else { return }

        for index in envelopes.indices {
            let share = amount * (envelopes[index].percentage / 100)
            envelopes[index].balance += share
            envelopes[index].allocatedThisCycle += share
        }

        incomeHistory.insert(IncomeTransaction(amount: amount, note: note), at: 0)
        persistAll()
    }

    func registerExpense(envelopeId: UUID, amount: Double, note: String) {
        guard amount > 0, let index = envelopes.firstIndex(where: { $0.id == envelopeId }) else { return }

        envelopes[index].balance = max(0, envelopes[index].balance - amount)
        expenseHistory.insert(EnvelopeExpense(envelopeId: envelopeId, amount: amount, note: note), at: 0)

        if envelopes[index].isNearLimit {
            NotificationManager.shared.notifyLowBalance(envelope: envelopes[index])
        }

        persistAll()
    }

    func updatePercentage(id: UUID, newValue: Double) {
        guard let index = envelopes.firstIndex(where: { $0.id == id }) else { return }
        envelopes[index].percentage = newValue
        persistAll()
    }

    func updateFrequency(_ newFrequency: IncomeFrequency) {
        frequency = newFrequency
        frequencyStore.save(newFrequency)
    }

    func expenses(for envelopeId: UUID) -> [EnvelopeExpense] {
        expenseHistory.filter { $0.envelopeId == envelopeId }
    }

    func resetToDefaults() {
        envelopes = Envelope.defaultSet()
        persistAll()
    }

    private func persistAll() {
        envelopesStore.save(envelopes)
        incomeStore.save(incomeHistory)
        expenseStore.save(expenseHistory)
    }
}
