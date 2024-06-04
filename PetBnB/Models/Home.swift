import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Home: Identifiable, Codable {
    @DocumentID var id: String?
    var userID: String?
    var name: String
    var beds: Int
    var rooms: Int
    var size: Int
    var guests: Int
    var animals: [String: AnimalInfo]
    var additionalInfoHome: String
    var city: String
    var availability: Int
    var startDate: Date?
    var endDate: Date?
    var images: [String: URL]
    var rating: Double
    var country: String
    var bathrooms: Int?
    var activities: String
    var guestAccess: String
    var otherNotes: String 
    var latitude: Double?
    var longitude: Double?
}
