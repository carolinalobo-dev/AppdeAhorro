import SwiftUI

struct PairingView: View {
    @Environment(\.themePalette) private var palette
    @EnvironmentObject private var pairingVM: PairingViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    Image(systemName: "link.circle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(palette.primary)
                    Text("Vinculate con tu pareja")
                        .font(.title3.weight(.bold))
                        .foregroundColor(palette.textPrimary)
                    Text("Compartí tu código para ver la ubicación y ahorrar juntos.")
                        .font(.caption)
                        .foregroundColor(palette.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .cardStyle(palette)

                VStack(spacing: 10) {
                    Text("Tu código")
                        .font(.caption)
                        .foregroundColor(palette.textSecondary)
                    Text(pairingVM.link.myCode)
                        .font(.system(size: 28, weight: .bold, design: .monospaced))
                        .foregroundColor(palette.primary)
                    ShareLink(item: pairingVM.link.myCode) {
                        Label("Compartir código", systemImage: "square.and.arrow.up")
                            .font(.caption.weight(.semibold))
                    }
                }
                .cardStyle(palette)

                VStack(spacing: 10) {
                    Text("Ingresá el código de tu pareja")
                        .font(.caption)
                        .foregroundColor(palette.textSecondary)
                    TextField("EJ: NOVIO-1234", text: $pairingVM.partnerCodeInput)
                        .textInputAutocapitalization(.characters)
                        .padding()
                        .background(palette.background)
                        .cornerRadius(10)

                    if let error = pairingVM.linkErrorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(palette.warning)
                    }

                    Button {
                        pairingVM.linkWithPartner()
                    } label: {
                        Text("Vincular")
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .background(palette.primary)
                            .cornerRadius(10)
                    }
                }
                .cardStyle(palette)
            }
            .padding()
        }
    }
}
