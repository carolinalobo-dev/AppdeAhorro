import SwiftUI

struct RootTabView: View {
    @EnvironmentObject private var themeVM: ThemeViewModel

    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Inicio", systemImage: "house.fill") }

            SavingsView()
                .tabItem { Label("Ahorros", systemImage: "banknote.fill") }

            MapView()
                .tabItem { Label("Mapa", systemImage: "map.fill") }

            SettingsView()
                .tabItem { Label("Ajustes", systemImage: "gearshape.fill") }
        }
        .tint(themeVM.palette.primary)
        .environment(\.themePalette, themeVM.palette)
        .preferredColorScheme(themeVM.palette.colorScheme)
    }
}
