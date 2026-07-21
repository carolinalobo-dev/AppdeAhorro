import Foundation
import CoreLocation
import Combine

final class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userCoordinate: CLLocationCoordinate2D?
    @Published var partnerLocation: SharedLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined

    private let manager = CLLocationManager()
    private let backend: SharedBackendService
    private var cancellables = Set<AnyCancellable>()

    private var myName: String = "Yo"
    private var myCode: String = ""
    private var linkedCode: String?

    init(backend: SharedBackendService = MockSharedBackendService.shared) {
        self.backend = backend
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func configure(myName: String, myCode: String, linkedCode: String?) {
        self.myName = myName
        self.myCode = myCode
        self.linkedCode = linkedCode

        if let linkedCode {
            backend.observePartnerLocation(linkedCode: linkedCode)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] location in
                    self?.partnerLocation = location
                }
                .store(in: &cancellables)
        }
    }

    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }

    func startUpdating() {
        manager.startUpdatingLocation()
    }

    func stopUpdating() {
        manager.stopUpdatingLocation()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            startUpdating()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.last?.coordinate else { return }
        userCoordinate = coordinate

        let shared = SharedLocation(ownerName: myName, coordinate: coordinate)
        backend.publishLocation(shared, forCode: myCode)
    }
}
