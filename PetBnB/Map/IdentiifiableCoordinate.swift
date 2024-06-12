

import Foundation
import CoreLocation

struct IdentiifiableCoordinate: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
