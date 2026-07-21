import Foundation

struct PartnerLink: Codable, Equatable {
    var myCode: String
    var myName: String
    var linkedCode: String?
    var partnerName: String?

    var isLinked: Bool { linkedCode != nil }

    static func generateCode(prefix: String = "AHORRO") -> String {
        let digits = String(format: "%04d", Int.random(in: 0...9999))
        return "\(prefix)-\(digits)"
    }
}
