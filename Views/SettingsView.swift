import SwiftUI

struct SettingsView: View {
    @Environment(\.themePalette) private var palette
    @EnvironmentObject private var themeVM: ThemeViewModel
    @EnvironmentObject private var budgetVM: BudgetViewModel
    @EnvironmentObject private var pairingVM: PairingViewModel

    var body: some View {
        NavigationStack {
            Form {
                Section("Tema visual") {
                    HStack(spacing: 16) {
                        ForEach(AppThemeMode.allCases) { mode in
                            VStack(spacing: 6) {
                                Circle()
                                    .fill(mode.swatch)
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Circle().strokeBorder(palette.primary, lineWidth: themeVM.mode == mode ? 3 : 0)
                                    )
                                Text(mode.displayName)
                                    .font(.caption2)
                                    .foregroundColor(palette.textSecondary)
                            }
                            .onTapGesture { themeVM.mode = mode }
                        }
                    }
                    .padding(.vertical, 6)
                }

                Section("Frecuencia de cobro") {
                    Picker("Frecuencia", selection: Binding(
                        get: { budgetVM.frequency },
                        set: { budgetVM.updateFrequency($0) }
                    )) {
                        ForEach(IncomeFrequency.allCases) { frequency in
                            Text(frequency.displayName).tag(frequency)
                        }
                    }
                    .pickerStyle(.inline)
                }

                Section("Vinculación") {
                    if pairingVM.link.isLinked {
                        HStack {
                            Text("Vinculado con")
                            Spacer()
                            Text(pairingVM.link.partnerName ?? "Pareja")
                                .foregroundColor(palette.textSecondary)
                        }
                        Button("Desvincular", role: .destructive) {
                            pairingVM.unlink()
                        }
                    } else {
                        Text("Tu código: \(pairingVM.link.myCode)")
                            .foregroundColor(palette.textSecondary)
                    }
                }

                Section {
                    ForEach(budgetVM.envelopes) { envelope in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(envelope.name)
                                Spacer()
                                Text("\(Int(envelope.percentage))%")
                                    .foregroundColor(palette.textSecondary)
                            }
                            Slider(
                                value: Binding(
                                    get: { envelope.percentage },
                                    set: { budgetVM.updatePercentage(id: envelope.id, newValue: $0) }
                                ),
                                in: 0...100,
                                step: 1
                            )
                        }
                    }

                    HStack {
                        Text("Total asignado")
                        Spacer()
                        Text("\(Int(budgetVM.totalPercentage))%")
                            .foregroundColor(budgetVM.totalPercentage == 100 ? palette.success : palette.warning)
                    }

                    Button("Restaurar valores por defecto") {
                        budgetVM.resetToDefaults()
                    }
                } header: {
                    Text("Distribución por sobres")
                } footer: {
                    Text("El total debería sumar 100% para distribuir todo tu ingreso.")
                }
            }
            .navigationTitle("Ajustes")
        }
    }
}
