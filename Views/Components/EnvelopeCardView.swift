import SwiftUI

struct EnvelopeCardView: View {
    @Environment(\.themePalette) private var palette
    let envelope: Envelope

    private var tint: Color {
        Color(hex: envelope.colorHex) ?? palette.primary
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                ZStack {
                    Circle().fill(tint.opacity(0.15)).frame(width: 40, height: 40)
                    Image(systemName: envelope.iconName)
                        .foregroundColor(tint)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(envelope.name)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(palette.textPrimary)
                    Text("\(Int(envelope.percentage))% del ingreso")
                        .font(.caption)
                        .foregroundColor(palette.textSecondary)
                }
                Spacer()
            }

            Text(CurrencyFormatter.format(envelope.balance))
                .font(.title2.weight(.bold))
                .foregroundColor(palette.textPrimary)

            ProgressBarView(progress: envelope.remainingFraction, color: envelope.isNearLimit ? palette.warning : tint)

            Text(envelope.isNearLimit ? "Saldo bajo" : "Disponible en este ciclo")
                .font(.caption2)
                .foregroundColor(envelope.isNearLimit ? palette.warning : palette.textSecondary)
        }
        .cardStyle(palette)
    }
}

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        let r = Double((rgb & 0xFF0000) >> 16) / 255
        let g = Double((rgb & 0x00FF00) >> 8) / 255
        let b = Double(rgb & 0x0000FF) / 255
        self = Color(red: r, green: g, blue: b)
    }
}
