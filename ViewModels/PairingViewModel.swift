import Foundation
import Combine

final class PairingViewModel: ObservableObject {
    @Published var link: PartnerLink
    @Published var partnerCodeInput: String = ""
    @Published var linkErrorMessage: String?

    private let store = PersistenceStore<PartnerLink>(fileName: "partner_link.json")
    private let backend: SharedBackendService
    private var cancellables = Set<AnyCancellable>()

    init(myName: String = "Yo", backend: SharedBackendService = MockSharedBackendService.shared) {
        self.backend = backend
        if let saved = store.load() {
            self.link = saved
        } else {
            let code = PartnerLink.generateCode()
            self.link = PartnerLink(myCode: code, myName: myName, linkedCode: nil, partnerName: nil)
        }
        backend.registerLink(myCode: link.myCode, myName: link.myName)
        observeIncomingLinkRequests()
    }

    func linkWithPartner() {
        let trimmed = partnerCodeInput.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        guard !trimmed.isEmpty else {
            linkErrorMessage = "Ingresá el código de tu pareja."
            return
        }
        guard trimmed != link.myCode else {
            linkErrorMessage = "No podés vincularte con tu propio código."
            return
        }

        backend.attemptLink(myCode: link.myCode, partnerCode: trimmed, myName: link.myName)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updatedLink in
                self?.link = updatedLink
                self?.linkErrorMessage = nil
                self?.store.save(updatedLink)
            }
            .store(in: &cancellables)
    }

    func unlink() {
        link.linkedCode = nil
        link.partnerName = nil
        store.save(link)
    }

    private func observeIncomingLinkRequests() {
        backend.observeLinkStatus(myCode: link.myCode)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updatedLink in
                self?.link = updatedLink
                self?.store.save(updatedLink)
            }
            .store(in: &cancellables)
    }
}
