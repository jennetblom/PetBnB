import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreLocation

struct Home: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var type: String
    var beds: Int
    var rooms: Int
    var size: Int
    var animals: [String]
    var age: Int
    var additionalInfoAnimal: String
    var additionalInfoHome: String
    var city: String
    var avalaibilty: Int
    var geopoint: GeoPoint
    var images: [String: URL]
    
   
}
