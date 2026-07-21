import SwiftUI

struct ProgressBarView: View {
    let progress: Double
    let color: Color
    var height: CGFloat = 10

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(color.opacity(0.18))

                RoundedRectangle(cornerRadius: height / 2)
                    .fill(color)
                    .frame(width: geo.size.width * CGFloat(max(0, min(1, progress))))
                    .animation(.easeInOut(duration: 0.35), value: progress)
            }
        }
        .frame(height: height)
    }
}
