import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var viewModel: MapViewModel
    
    var body: some View {
        Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.coordinates) { item in
            MapMarker(coordinate: item.coordinate)
        }
        .onAppear {
            viewModel.geocodeCity { result in
                switch result {
                case .success:
                    break
                case .failure(let error):
                    print("Error geocoding city: \(error.localizedDescription)")
                }
            }
        }
    }
}
