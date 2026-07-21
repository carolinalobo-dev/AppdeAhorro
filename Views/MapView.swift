import SwiftUI
import MapKit

struct MapView: View {
    @Environment(\.themePalette) private var palette
    @EnvironmentObject private var pairingVM: PairingViewModel
    @EnvironmentObject private var locationVM: LocationViewModel

    @State private var cameraPosition: MapCameraPosition = .automatic

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if pairingVM.link.isLinked {
                    Map(position: $cameraPosition) {
                        if let userCoordinate = locationVM.userCoordinate {
                            Annotation("Yo", coordinate: userCoordinate) {
                                PersonPin(label: "Yo", color: palette.primary)
                            }
                        }
                        if let partner = locationVM.partnerLocation {
                            Annotation(partner.ownerName, coordinate: partner.coordinate) {
                                PersonPin(label: partner.ownerName, color: palette.accent)
                            }
                        }
                    }
                    .onAppear {
                        locationVM.requestPermission()
                    }
                } else {
                    PairingView()
                }
            }
            .background(palette.background)
            .navigationTitle("Ubicación")
        }
    }
}

private struct PersonPin: View {
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 2) {
            Image(systemName: "person.circle.fill")
                .font(.title)
                .foregroundColor(color)
                .background(Circle().fill(.white))
            Text(label)
                .font(.caption2.weight(.semibold))
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(.white)
                .cornerRadius(6)
        }
    }
}
