
import Foundation
import Combine
import MapKit

class MapViewModel: ObservableObject {
    @Published var city: String
    @Published var country: String
    @Published var region: MKCoordinateRegion
    @Published var coordinates: [IdentiifiableCoordinate] 
    

    
    init(city: String, country: String, latitude: Double?, longitude: Double?) {
        self.city = city
        self.country = country
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude ?? 57.70887, longitude: longitude ?? 11.97456)
        self.region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        self.coordinates = [IdentiifiableCoordinate(coordinate: coordinate)]
    }
    
    func geocodeCity() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString("\(city), \(country)") { (placemarks, error) in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
            } else if let placemarks = placemarks, let location = placemarks.first?.location {
                DispatchQueue.main.async {
                    self.region = MKCoordinateRegion(
                        center: location.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    )
                    self.coordinates = [IdentiifiableCoordinate(coordinate: location.coordinate)]
                }
            }
        }
    }
}
