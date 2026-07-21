import Foundation
import Combine

final class SavingsViewModel: ObservableObject {
    @Published var goals: [SavingsGoal]
    @Published var historyPoints: [SavingsHistoryPoint]

    private let goalsStore = PersistenceStore<[SavingsGoal]>(fileName: "savings_goals.json")
    private let historyStore = PersistenceStore<[SavingsHistoryPoint]>(fileName: "savings_history.json")

    private let backend: SharedBackendService
    private var cancellables = Set<AnyCancellable>()

    var totalSaved: Double {
        goals.reduce(0) { $0 + $1.currentAmount }
    }

    var sharedGoal: SavingsGoal? {
        goals.first(where: { $0.isShared })
    }

    var personalGoals: [SavingsGoal] {
        goals.filter { !$0.isShared }
    }

    init(backend: SharedBackendService = MockSharedBackendService.shared) {
        self.backend = backend
        self.goals = goalsStore.load() ?? []
        self.historyPoints = historyStore.load() ?? []
    }

    func addGoal(title: String, targetAmount: Double, deadline: Date?, iconName: String, isShared: Bool) {
        let goal = SavingsGoal(title: title, targetAmount: targetAmount, deadline: deadline, iconName: iconName, isShared: isShared)
        goals.append(goal)
        persistGoals()
    }

    func contribute(to goalId: UUID, amount: Double, contributorName: String, linkedCode: String? = nil) {
        guard amount > 0, let index = goals.firstIndex(where: { $0.id == goalId }) else { return }

        let contribution = SavingsContribution(amount: amount, contributorName: contributorName)
        let wasComplete = goals[index].progress >= 1
        goals[index].contributions.append(contribution)

        if !wasComplete && goals[index].progress >= 1 {
            NotificationManager.shared.notifyGoalReached(goal: goals[index])
        }

        if goals[index].isShared, let linkedCode {
            backend.publishSharedContribution(contribution, linkedCode: linkedCode)
        }

        recordHistorySnapshot()
        persistGoals()
    }

    func deleteGoal(id: UUID) {
        goals.removeAll { $0.id == id }
        persistGoals()
    }

    /// Listens for contributions the linked partner makes to the shared goal from their device.
    func startObservingSharedContributions(linkedCode: String) {
        backend.observeSharedContributions(linkedCode: linkedCode)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] contribution in
                guard let self, let index = self.goals.firstIndex(where: { $0.isShared }) else { return }
                self.goals[index].contributions.append(contribution)
                self.recordHistorySnapshot()
                self.persistGoals()
            }
            .store(in: &cancellables)
    }

    private func recordHistorySnapshot() {
        historyPoints.append(SavingsHistoryPoint(date: Date(), totalSaved: totalSaved))
        historyStore.save(historyPoints)
    }

    private func persistGoals() {
        goalsStore.save(goals)
    }
}
