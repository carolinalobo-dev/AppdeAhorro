import SwiftUI

struct SavingsGoalDetailView: View {
    @Environment(\.themePalette) private var palette
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var savingsVM: SavingsViewModel
    @EnvironmentObject private var pairingVM: PairingViewModel

    let goalId: UUID
    @State private var contributionText = ""

    private var goal: SavingsGoal? {
        savingsVM.goals.first { $0.id == goalId }
    }

    private var contributionAmount: Double {
        Double(contributionText.replacingOccurrences(of: ",", with: ".")) ?? 0
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                if let goal {
                    VStack(spacing: 20) {
                        VStack(spacing: 10) {
                            Image(systemName: goal.iconName)
                                .font(.largeTitle)
                                .foregroundColor(palette.primary)
                            Text(goal.title)
                                .font(.title3.weight(.bold))
                                .foregroundColor(palette.textPrimary)
                            Text("\(CurrencyFormatter.format(goal.currentAmount)) de \(CurrencyFormatter.format(goal.targetAmount))")
                                .font(.subheadline)
                                .foregroundColor(palette.textSecondary)
                            ProgressBarView(progress: goal.progress, color: palette.primary)
                                .frame(height: 12)
                            if let days = goal.daysRemaining {
                                Text("\(days) días para cumplir la meta")
                                    .font(.caption)
                                    .foregroundColor(palette.textSecondary)
                            }
                        }
                        .cardStyle(palette)

                        VStack(spacing: 10) {
                            Text("Aportar a esta meta")
                                .font(.subheadline.weight(.semibold))
                                .foregroundColor(palette.textPrimary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            TextField("Monto", text: $contributionText)
                                .keyboardType(.decimalPad)
                                .padding()
                                .background(palette.background)
                                .cornerRadius(10)
                            Button {
                                savingsVM.contribute(
                                    to: goal.id,
                                    amount: contributionAmount,
                                    contributorName: pairingVM.link.myName,
                                    linkedCode: pairingVM.link.linkedCode
                                )
                                contributionText = ""
                            } label: {
                                Text("Aportar")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(10)
                                    .background(palette.primary)
                                    .cornerRadius(10)
                            }
                            .disabled(contributionAmount <= 0)
                        }
                        .cardStyle(palette)

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Aportes")
                                .font(.subheadline.weight(.semibold))
                                .foregroundColor(palette.textPrimary)

                            if goal.contributions.isEmpty {
                                Text("Todavía no hay aportes.")
                                    .font(.caption)
                                    .foregroundColor(palette.textSecondary)
                            } else {
                                ForEach(goal.contributions.reversed()) { contribution in
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(contribution.contributorName)
                                                .font(.footnote)
                                                .foregroundColor(palette.textPrimary)
                                            Text(contribution.date.formatted(date: .abbreviated, time: .shortened))
                                                .font(.caption2)
                                                .foregroundColor(palette.textSecondary)
                                        }
                                        Spacer()
                                        Text("+\(CurrencyFormatter.format(contribution.amount))")
                                            .font(.footnote.weight(.semibold))
                                            .foregroundColor(palette.success)
                                    }
                                }
                            }
                        }
                        .cardStyle(palette)
                    }
                    .padding()
                }
            }
            .background(palette.background)
            .navigationTitle("Meta")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cerrar") { dismiss() }
                }
            }
        }
    }
}
