import SwiftUI

struct AddSavingsGoalView: View {
    @Environment(\.themePalette) private var palette
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var savingsVM: SavingsViewModel

    let canShare: Bool

    @State private var title = ""
    @State private var targetText = ""
    @State private var hasDeadline = false
    @State private var deadline = Date().addingTimeInterval(60 * 60 * 24 * 30)
    @State private var isShared = false
    @State private var iconName = "star.fill"

    private let iconOptions = ["star.fill", "airplane", "house.fill", "car.fill", "gift.fill", "graduationcap.fill", "heart.fill"]

    private var targetAmount: Double {
        Double(targetText.replacingOccurrences(of: ",", with: ".")) ?? 0
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Meta") {
                    TextField("Título (ej: Vacaciones)", text: $title)
                    TextField("Monto objetivo", text: $targetText)
                        .keyboardType(.decimalPad)
                }

                Section("Ícono") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(iconOptions, id: \.self) { icon in
                                Image(systemName: icon)
                                    .font(.title3)
                                    .foregroundColor(iconName == icon ? .white : palette.primary)
                                    .frame(width: 44, height: 44)
                                    .background(iconName == icon ? palette.primary : palette.primary.opacity(0.12))
                                    .clipShape(Circle())
                                    .onTapGesture { iconName = icon }
                            }
                        }
                    }
                }

                Section("Fecha límite") {
                    Toggle("Con fecha objetivo", isOn: $hasDeadline)
                    if hasDeadline {
                        DatePicker("Fecha", selection: $deadline, displayedComponents: .date)
                    }
                }

                if canShare {
                    Section("Compartir") {
                        Toggle("Meta compartida con mi pareja", isOn: $isShared)
                    }
                }
            }
            .navigationTitle("Nueva Meta")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        savingsVM.addGoal(
                            title: title,
                            targetAmount: targetAmount,
                            deadline: hasDeadline ? deadline : nil,
                            iconName: iconName,
                            isShared: isShared
                        )
                        dismiss()
                    }
                    .disabled(title.isEmpty || targetAmount <= 0)
                }
            }
        }
    }
}
