import SwiftUI

struct EnvelopeDetailView: View {
    @Environment(\.themePalette) private var palette
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var budgetVM: BudgetViewModel

    let envelopeId: UUID
    @State private var expenseAmountText = ""
    @State private var expenseNote = ""

    private var envelope: Envelope? {
        budgetVM.envelopes.first { $0.id == envelopeId }
    }

    private var expenseAmount: Double {
        Double(expenseAmountText.replacingOccurrences(of: ",", with: ".")) ?? 0
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                if let envelope {
                    VStack(spacing: 20) {
                        VStack(spacing: 8) {
                            Image(systemName: envelope.iconName)
                                .font(.largeTitle)
                                .foregroundColor(Color(hex: envelope.colorHex) ?? palette.primary)
                            Text(CurrencyFormatter.format(envelope.balance))
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundColor(palette.textPrimary)
                            ProgressBarView(progress: envelope.remainingFraction, color: Color(hex: envelope.colorHex) ?? palette.primary)
                                .frame(height: 12)
                        }
                        .cardStyle(palette)

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Registrar gasto")
                                .font(.subheadline.weight(.semibold))
                                .foregroundColor(palette.textPrimary)
                            TextField("Monto", text: $expenseAmountText)
                                .keyboardType(.decimalPad)
                                .padding()
                                .background(palette.background)
                                .cornerRadius(10)
                            TextField("Nota", text: $expenseNote)
                                .padding()
                                .background(palette.background)
                                .cornerRadius(10)
                            Button {
                                budgetVM.registerExpense(envelopeId: envelope.id, amount: expenseAmount, note: expenseNote)
                                expenseAmountText = ""
                                expenseNote = ""
                            } label: {
                                Text("Descontar del sobre")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(10)
                                    .background(palette.accent)
                                    .cornerRadius(10)
                            }
                            .disabled(expenseAmount <= 0)
                        }
                        .cardStyle(palette)

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Movimientos")
                                .font(.subheadline.weight(.semibold))
                                .foregroundColor(palette.textPrimary)

                            let items = budgetVM.expenses(for: envelope.id)
                            if items.isEmpty {
                                Text("Sin gastos registrados todavía.")
                                    .font(.caption)
                                    .foregroundColor(palette.textSecondary)
                            } else {
                                ForEach(items) { expense in
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(expense.note.isEmpty ? "Gasto" : expense.note)
                                                .font(.footnote)
                                                .foregroundColor(palette.textPrimary)
                                            Text(expense.date.formatted(date: .abbreviated, time: .shortened))
                                                .font(.caption2)
                                                .foregroundColor(palette.textSecondary)
                                        }
                                        Spacer()
                                        Text("-\(CurrencyFormatter.format(expense.amount))")
                                            .font(.footnote.weight(.semibold))
                                            .foregroundColor(palette.warning)
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
            .navigationTitle(envelope?.name ?? "Sobre")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cerrar") { dismiss() }
                }
            }
        }
    }
}
