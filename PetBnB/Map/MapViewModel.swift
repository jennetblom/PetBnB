import Foundation
import Combine
import MapKit

struct IdentifiableCoordinate: Identifiable {
    var id = UUID()
    var coordinate: CLLocationCoordinate2D
}

class MapViewModel: ObservableObject {
    @Published var city: String
    @Published var region: MKCoordinateRegion
    @Published var coordinates: [IdentifiableCoordinate]
    
    init(city: String) {
        self.city = city
        let coordinate = CLLocationCoordinate2D(latitude: 57.70887, longitude: 11.97456)
        self.region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        self.coordinates = [IdentifiableCoordinate(coordinate: coordinate)]
    }
    func updateCity(newCity: String) {
            self.city = newCity
            DispatchQueue.main.async {

            }
        }
    
    func geocodeCity(completion: @escaping (Result<Void, Error>) -> Void) {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(city) { (placemarks, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let placemarks = placemarks, let location = placemarks.first?.location {
                    self.region = MKCoordinateRegion(
                        center: location.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    )
                    self.coordinates = [IdentifiableCoordinate(coordinate: location.coordinate)]
                    completion(.success(()))
                }
            }
        }
    }
