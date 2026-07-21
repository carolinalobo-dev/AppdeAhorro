import SwiftUI

struct CardBackground: ViewModifier {
    let palette: ThemePalette

    func body(content: Content) -> some View {
        content
            .padding(16)
            .background(palette.cardBackground)
            .cornerRadius(18)
            .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
    }
}

extension View {
    func cardStyle(_ palette: ThemePalette) -> some View {
        modifier(CardBackground(palette: palette))
    }
}
