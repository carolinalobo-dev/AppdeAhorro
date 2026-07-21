import SwiftUI

struct HomeView: View {
    @Environment(\.themePalette) private var palette
    @EnvironmentObject private var budgetVM: BudgetViewModel

    @State private var showRegisterIncome = false
    @State private var selectedEnvelope: Envelope?

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header

                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(budgetVM.envelopes) { envelope in
                            EnvelopeCardView(envelope: envelope)
                                .onTapGesture { selectedEnvelope = envelope }
                        }
                    }
                }
                .padding()
                .padding(.bottom, 90)
            }
            .background(palette.background)
            .overlay(alignment: .bottomTrailing) { registerButton }
            .navigationTitle("Mi Presupuesto")
            .sheet(isPresented: $showRegisterIncome) {
                RegisterIncomeView()
            }
            .sheet(item: $selectedEnvelope) { envelope in
                EnvelopeDetailView(envelopeId: envelope.id)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(budgetVM.frequency.displayName)
                .font(.caption.weight(.medium))
                .foregroundColor(palette.textSecondary)
            Text(CurrencyFormatter.format(budgetVM.totalBalance))
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundColor(palette.textPrimary)
            Text("Saldo total disponible")
                .font(.caption)
                .foregroundColor(palette.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var registerButton: some View {
        Button {
            showRegisterIncome = true
        } label: {
            Image(systemName: "plus")
                .font(.title2.weight(.bold))
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(palette.primary)
                .clipShape(Circle())
                .shadow(color: palette.primary.opacity(0.4), radius: 10, x: 0, y: 6)
        }
        .padding(24)
        .accessibilityLabel("Registrar Cobro")
    }
}
