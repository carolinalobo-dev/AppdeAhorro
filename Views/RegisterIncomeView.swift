import SwiftUI

struct RegisterIncomeView: View {
    @Environment(\.themePalette) private var palette
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var budgetVM: BudgetViewModel

    @State private var amountText = ""
    @State private var note = ""

    private var amount: Double {
        Double(amountText.replacingOccurrences(of: ",", with: ".")) ?? 0
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 6) {
                        Text("¿Cuánto cobraste?")
                            .font(.subheadline)
                            .foregroundColor(palette.textSecondary)
                        TextField("$0", text: $amountText)
                            .keyboardType(.decimalPad)
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .multilineTextAlignment(.center)
                    }
                    .cardStyle(palette)

                    TextField("Nota (opcional, ej: proyecto diseño)", text: $note)
                        .padding()
                        .background(palette.cardBackground)
                        .cornerRadius(14)

                    if amount > 0 {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Se va a distribuir así:")
                                .font(.subheadline.weight(.semibold))
                                .foregroundColor(palette.textPrimary)

                            ForEach(budgetVM.envelopes) { envelope in
                                HStack {
                                    Text(envelope.name)
                                        .font(.footnote)
                                        .foregroundColor(palette.textSecondary)
                                    Spacer()
                                    Text(CurrencyFormatter.format(amount * envelope.percentage / 100))
                                        .font(.footnote.weight(.semibold))
                                        .foregroundColor(palette.textPrimary)
                                }
                            }
                        }
                        .cardStyle(palette)
                    }

                    Button {
                        budgetVM.registerIncome(amount: amount, note: note)
                        dismiss()
                    } label: {
                        Text("Registrar Cobro")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(palette.primary)
                            .cornerRadius(14)
                    }
                    .disabled(amount <= 0)
                    .opacity(amount <= 0 ? 0.5 : 1)
                }
                .padding()
            }
            .background(palette.background)
            .navigationTitle("Registrar Cobro")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
            }
        }
    }
}
