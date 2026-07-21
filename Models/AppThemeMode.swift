import SwiftUI

enum AppThemeMode: String, CaseIterable, Identifiable, Codable {
    case green
    case pink
    case dark

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .green: return "Ahorro (Verde)"
        case .pink: return "Pastel (Rosa)"
        case .dark: return "Dark Profundo"
        }
    }

    var swatch: Color {
        switch self {
        case .green: return Color(red: 0.16, green: 0.62, blue: 0.42)
        case .pink: return Color(red: 0.95, green: 0.62, blue: 0.72)
        case .dark: return Color(red: 0.08, green: 0.08, blue: 0.1)
        }
    }
}

struct ThemePalette {
    let background: Color
    let cardBackground: Color
    let primary: Color
    let secondary: Color
    let accent: Color
    let textPrimary: Color
    let textSecondary: Color
    let success: Color
    let warning: Color
    let colorScheme: ColorScheme

    static func palette(for mode: AppThemeMode) -> ThemePalette {
        switch mode {
        case .green:
            return ThemePalette(
                background: Color(red: 0.95, green: 0.98, blue: 0.96),
                cardBackground: .white,
                primary: Color(red: 0.16, green: 0.62, blue: 0.42),
                secondary: Color(red: 0.55, green: 0.82, blue: 0.68),
                accent: Color(red: 0.10, green: 0.45, blue: 0.32),
                textPrimary: Color(red: 0.08, green: 0.15, blue: 0.12),
                textSecondary: Color(red: 0.40, green: 0.48, blue: 0.45),
                success: Color(red: 0.20, green: 0.70, blue: 0.45),
                warning: Color(red: 0.90, green: 0.55, blue: 0.15),
                colorScheme: .light
            )
        case .pink:
            return ThemePalette(
                background: Color(red: 0.99, green: 0.95, blue: 0.97),
                cardBackground: .white,
                primary: Color(red: 0.93, green: 0.55, blue: 0.68),
                secondary: Color(red: 0.98, green: 0.80, blue: 0.86),
                accent: Color(red: 0.78, green: 0.35, blue: 0.52),
                textPrimary: Color(red: 0.25, green: 0.15, blue: 0.20),
                textSecondary: Color(red: 0.55, green: 0.45, blue: 0.50),
                success: Color(red: 0.45, green: 0.70, blue: 0.55),
                warning: Color(red: 0.90, green: 0.55, blue: 0.15),
                colorScheme: .light
            )
        case .dark:
            return ThemePalette(
                background: Color(red: 0.05, green: 0.05, blue: 0.07),
                cardBackground: Color(red: 0.12, green: 0.12, blue: 0.15),
                primary: Color(red: 0.35, green: 0.75, blue: 0.95),
                secondary: Color(red: 0.20, green: 0.22, blue: 0.28),
                accent: Color(red: 0.55, green: 0.85, blue: 1.0),
                textPrimary: .white,
                textSecondary: Color(white: 0.65),
                success: Color(red: 0.30, green: 0.80, blue: 0.55),
                warning: Color(red: 0.95, green: 0.65, blue: 0.25),
                colorScheme: .dark
            )
        }
    }
}

private struct ThemePaletteKey: EnvironmentKey {
    static let defaultValue: ThemePalette = .palette(for: .green)
}

extension EnvironmentValues {
    var themePalette: ThemePalette {
        get { self[ThemePaletteKey.self] }
        set { self[ThemePaletteKey.self] = newValue }
    }
}
