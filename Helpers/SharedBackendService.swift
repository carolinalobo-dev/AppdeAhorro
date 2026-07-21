import Foundation
import Combine
import CoreLocation

/// Everything two linked users need to exchange: pairing codes, live location, and shared
/// savings contributions. `MockSharedBackendService` below is a fully working in-memory
/// simulation so the app runs standalone. To go live, create `FirebaseSharedBackendService`
/// conforming to this same protocol, backed by Firebase Realtime Database, using paths like:
///   /links/{code}                -> { ownerName, linkedCode, partnerName }
///   /locations/{code}             -> { ownerName, latitude, longitude, timestamp }
///   /sharedSavings/{code}/events  -> list of SavingsContribution
/// Then swap the single line in `AhorroCompartidoApp.swift` that instantiates the service.
protocol SharedBackendService {
    func registerLink(myCode: String, myName: String)
    func attemptLink(myCode: String, partnerCode: String, myName: String) -> AnyPublisher<PartnerLink, Never>
    func observeLinkStatus(myCode: String) -> AnyPublisher<PartnerLink, Never>

    func publishLocation(_ location: SharedLocation, forCode code: String)
    func observePartnerLocation(linkedCode: String) -> AnyPublisher<SharedLocation, Never>

    func publishSharedContribution(_ contribution: SavingsContribution, linkedCode: String)
    func observeSharedContributions(linkedCode: String) -> AnyPublisher<SavingsContribution, Never>
}

/// In-memory simulation shared across ViewModel instances within the same app run.
/// Two devices can't actually see each other here — this exists so the pairing, map,
/// and shared-goal UI are fully exercisable while a real backend is wired in.
final class MockSharedBackendService: SharedBackendService {
    static let shared = MockSharedBackendService()

    private var links: [String: PartnerLink] = [:]
    private let linkSubject = PassthroughSubject<PartnerLink, Never>()
    private let locationSubject = PassthroughSubject<(String, SharedLocation), Never>()
    private let contributionSubject = PassthroughSubject<(String, SavingsContribution), Never>()

    private init() {}

    func registerLink(myCode: String, myName: String) {
        links[myCode] = PartnerLink(myCode: myCode, myName: myName, linkedCode: nil, partnerName: nil)
    }

    func attemptLink(myCode: String, partnerCode: String, myName: String) -> AnyPublisher<PartnerLink, Never> {
        var updated = links[myCode] ?? PartnerLink(myCode: myCode, myName: myName, linkedCode: nil, partnerName: nil)
        updated.linkedCode = partnerCode
        updated.partnerName = links[partnerCode]?.myName ?? "Tu pareja"
        links[myCode] = updated

        if var partnerEntry = links[partnerCode] {
            partnerEntry.linkedCode = myCode
            partnerEntry.partnerName = myName
            links[partnerCode] = partnerEntry
            linkSubject.send(partnerEntry)
        }

        return Just(updated).eraseToAnyPublisher()
    }

    func observeLinkStatus(myCode: String) -> AnyPublisher<PartnerLink, Never> {
        linkSubject.filter { $0.myCode == myCode }.eraseToAnyPublisher()
    }

    func publishLocation(_ location: SharedLocation, forCode code: String) {
        locationSubject.send((code, location))
    }

    func observePartnerLocation(linkedCode: String) -> AnyPublisher<SharedLocation, Never> {
        locationSubject
            .filter { $0.0 == linkedCode }
            .map { $0.1 }
            .eraseToAnyPublisher()
    }

    func publishSharedContribution(_ contribution: SavingsContribution, linkedCode: String) {
        contributionSubject.send((linkedCode, contribution))
    }

    func observeSharedContributions(linkedCode: String) -> AnyPublisher<SavingsContribution, Never> {
        contributionSubject
            .filter { $0.0 == linkedCode }
            .map { $0.1 }
            .eraseToAnyPublisher()
    }
}
