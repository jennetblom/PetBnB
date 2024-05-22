import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var uid: String
    var name: String
    var email: String
    var password: String
    var homeID: String?
    var rating: Double
    var favourite: Bool
    var profilePicture: URL?
    
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
