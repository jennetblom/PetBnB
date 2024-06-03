import SwiftUI
import MapKit

struct MapView: View {

    @ObservedObject var viewModel: MapViewModel
    
    var body: some View {
        Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.coordinates) { item in
            MapMarker(coordinate: item.coordinate)
        }
         addhomeMapFrida
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

        
        /*.onAppear {
            setRegion(for: viewModel.city)
        }
    }
    
    private func setRegion(for city: String) {
        let coordinate = CLLocationCoordinate2D(latitude: 57.70887, longitude: 11.97456)
        viewModel.region = MKCoordinateRegion(
            center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        viewModel.coordinates = [IdentiifiableCoordinate(coordinate: coordinate)]
    } */

}
