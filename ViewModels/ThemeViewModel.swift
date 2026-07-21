import Foundation
import Combine

final class ThemeViewModel: ObservableObject {
    @Published var mode: AppThemeMode {
        didSet { store.save(mode) }
    }

    var palette: ThemePalette { .palette(for: mode) }

    private let store = PersistenceStore<AppThemeMode>(fileName: "theme.json")

    init() {
        self.mode = store.load() ?? .green
    }
}
