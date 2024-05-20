import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Home: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var type: String
    var beds: Int
    var rooms: Int
    var size: Int
    var animals: [String: AnimalInfo]
    var additionalInfoHome: String
    var city: String
    var availability: Int
    var images: [String: URL]
    var rating: Double
    
}
