
import Foundation
import Combine
import MapKit

class MapViewModel: ObservableObject {
    @Published var city: String
    @Published var region: MKCoordinateRegion
    @Published var coordinates : [IdentiifiableCoordinate]
    
    init(city: String) {
        self.city = city
        let coordinate = CLLocationCoordinate2D(latitude: 57.70887, longitude: 11.97456)
        self.region = MKCoordinateRegion(
            center: coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        
        )
        self.coordinates = [IdentiifiableCoordinate(coordinate: coordinate)]
    }
}
