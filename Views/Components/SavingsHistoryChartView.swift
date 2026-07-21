import SwiftUI
import Charts

struct SavingsHistoryChartView: View {
    @Environment(\.themePalette) private var palette
    let points: [SavingsHistoryPoint]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Evolución del ahorro")
                .font(.subheadline.weight(.semibold))
                .foregroundColor(palette.textPrimary)

            if points.isEmpty {
                Text("Todavía no registraste aportes. Tu progreso va a aparecer acá.")
                    .font(.caption)
                    .foregroundColor(palette.textSecondary)
                    .frame(height: 140)
            } else {
                Chart(points) { point in
                    LineMark(x: .value("Fecha", point.date), y: .value("Total", point.totalSaved))
                        .foregroundStyle(palette.primary)
                        .interpolationMethod(.catmullRom)

                    AreaMark(x: .value("Fecha", point.date), y: .value("Total", point.totalSaved))
                        .foregroundStyle(palette.primary.opacity(0.12))
                        .interpolationMethod(.catmullRom)
                }
                .frame(height: 160)
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
            }
        }
        .cardStyle(palette)
    }
}
