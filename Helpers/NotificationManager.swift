import Foundation
import UserNotifications
import CoreLocation

final class NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    func notifyLowBalance(envelope: Envelope) {
        let content = UNMutableNotificationContent()
        content.title = "Saldo bajo en \(envelope.name)"
        content.body = "Te queda \(CurrencyFormatter.format(envelope.balance)) disponible en este sobre."
        content.sound = .default

        let request = UNNotificationRequest(identifier: "low-balance-\(envelope.id)", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }

    func notifyGoalReached(goal: SavingsGoal) {
        let content = UNMutableNotificationContent()
        content.title = "¡Meta alcanzada! 🎉"
        content.body = "Completaste \"\(goal.title)\": \(CurrencyFormatter.format(goal.targetAmount))"
        content.sound = .default

        let request = UNNotificationRequest(identifier: "goal-reached-\(goal.id)", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }

    /// Registers a geofence around a commercial zone so iOS notifies the user when they
    /// arrive, reminding them of their remaining "Gastos Libres" balance. Requires
    /// "Always" location authorization and the Background Modes > Location updates capability.
    func scheduleCommercialZoneReminder(center: CLLocationCoordinate2D, radius: CLLocationDistance, envelopeBalance: Double) {
        let content = UNMutableNotificationContent()
        content.title = "Estás cerca de una zona comercial"
        content.body = "Saldo disponible en Gastos Libres: \(CurrencyFormatter.format(envelopeBalance))"
        content.sound = .default

        let region = CLCircularRegion(center: center, radius: radius, identifier: "commercial-zone-\(UUID().uuidString)")
        region.notifyOnEntry = true
        region.notifyOnExit = false

        let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
        let request = UNNotificationRequest(identifier: region.identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
