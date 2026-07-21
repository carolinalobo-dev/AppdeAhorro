import Foundation
import CoreLocation

struct SharedLocation: Codable, Equatable {
    var ownerName: String
    var latitude: Double
    var longitude: Double
    var timestamp: Date

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init(ownerName: String, coordinate: CLLocationCoordinate2D, timestamp: Date = Date()) {
        self.ownerName = ownerName
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        self.timestamp = timestamp
    }
}
