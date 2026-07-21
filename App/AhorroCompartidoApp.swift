import SwiftUI

@main
struct AhorroCompartidoApp: App {
    @StateObject private var themeVM = ThemeViewModel()
    @StateObject private var budgetVM = BudgetViewModel()
    @StateObject private var savingsVM = SavingsViewModel()
    @StateObject private var pairingVM = PairingViewModel()
    @StateObject private var locationVM = LocationViewModel()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(themeVM)
                .environmentObject(budgetVM)
                .environmentObject(savingsVM)
                .environmentObject(pairingVM)
                .environmentObject(locationVM)
                .onAppear {
                    NotificationManager.shared.requestAuthorization()
                    locationVM.configure(
                        myName: pairingVM.link.myName,
                        myCode: pairingVM.link.myCode,
                        linkedCode: pairingVM.link.linkedCode
                    )
                    if let linkedCode = pairingVM.link.linkedCode {
                        savingsVM.startObservingSharedContributions(linkedCode: linkedCode)
                    }
                }
                .onChange(of: pairingVM.link.linkedCode) { _, newLinkedCode in
                    locationVM.configure(
                        myName: pairingVM.link.myName,
                        myCode: pairingVM.link.myCode,
                        linkedCode: newLinkedCode
                    )
                    if let newLinkedCode {
                        savingsVM.startObservingSharedContributions(linkedCode: newLinkedCode)
                    }
                }
        }
    }
}
