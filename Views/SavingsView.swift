import SwiftUI

struct SavingsView: View {
    @Environment(\.themePalette) private var palette
    @EnvironmentObject private var savingsVM: SavingsViewModel
    @EnvironmentObject private var pairingVM: PairingViewModel

    @State private var showAddGoal = false
    @State private var selectedGoal: SavingsGoal?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    SavingsHistoryChartView(points: savingsVM.historyPoints)

                    if let shared = savingsVM.sharedGoal {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Meta compartida")
                                .font(.subheadline.weight(.semibold))
                                .foregroundColor(palette.textSecondary)
                            SavingsGoalRow(goal: shared)
                                .onTapGesture { selectedGoal = shared }
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Mis metas")
                                .font(.subheadline.weight(.semibold))
                                .foregroundColor(palette.textSecondary)
                            Spacer()
                            Button {
                                showAddGoal = true
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(palette.primary)
                            }
                        }

                        if savingsVM.personalGoals.isEmpty {
                            Text("Todavía no creaste ninguna meta de ahorro.")
                                .font(.caption)
                                .foregroundColor(palette.textSecondary)
                                .cardStyle(palette)
                        } else {
                            ForEach(savingsVM.personalGoals) { goal in
                                SavingsGoalRow(goal: goal)
                                    .onTapGesture { selectedGoal = goal }
                            }
                        }
                    }
                }
                .padding()
                .padding(.bottom, 40)
            }
            .background(palette.background)
            .navigationTitle("Ahorros")
            .sheet(isPresented: $showAddGoal) {
                AddSavingsGoalView(canShare: pairingVM.link.isLinked)
            }
            .sheet(item: $selectedGoal) { goal in
                SavingsGoalDetailView(goalId: goal.id)
            }
        }
    }
}

private struct SavingsGoalRow: View {
    @Environment(\.themePalette) private var palette
    let goal: SavingsGoal

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: goal.iconName)
                    .foregroundColor(palette.primary)
                Text(goal.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(palette.textPrimary)
                if goal.isShared {
                    Image(systemName: "person.2.fill")
                        .font(.caption)
                        .foregroundColor(palette.textSecondary)
                }
                Spacer()
                Text("\(Int(goal.progress * 100))%")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(palette.textSecondary)
            }

            ProgressBarView(progress: goal.progress, color: palette.primary)

            HStack {
                Text("\(CurrencyFormatter.format(goal.currentAmount)) de \(CurrencyFormatter.format(goal.targetAmount))")
                    .font(.caption)
                    .foregroundColor(palette.textSecondary)
                Spacer()
                if let days = goal.daysRemaining {
                    Text("\(days) días restantes")
                        .font(.caption)
                        .foregroundColor(palette.textSecondary)
                }
            }
        }
        .cardStyle(palette)
    }
}
