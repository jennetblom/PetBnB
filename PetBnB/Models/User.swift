import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var uid: String?
    var name: String
    var email: String?
    var password: String?
    var homeIDs: [String]?
    var favourite: Bool?
    
    var profilePictureUrl : URL?
    var rating: Double?
    var ratingCount: Int?
    var city : String
    var numberOfBeds : Int
    var numberOfRooms : Int
    var homeInfo : String
    var animals: [String: AnimalInfo]
    var userAge : Int
    var userInfo : String
    var animalExperienceType : String
    var animalExperienceInfo : String
    
}
