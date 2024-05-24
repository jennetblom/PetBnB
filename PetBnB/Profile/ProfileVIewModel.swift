
import Foundation
import Firebase

class ProfileViewModel: ObservableObject {
    
    let db = Firestore.firestore()
    let auth = Auth.auth()
    @Published var users = [User]()
    
    
    @Published var name = ""
    @Published var rating = 3
    @Published var city = "Stockholm"
    @Published var numberOfBeds = 0
    @Published var numberOfRooms = 0
    @Published var homeInfo = ""
    @Published var animalType = "Katt"
    @Published var animalAge = 0
    @Published var animalInfo = ""
    @Published var userAge = 0
    @Published var userInfo = ""
    @Published var animalExperienceType = "Reptil"
    @Published var animalExperienceInfo = ""
    
    func fetchUserProfileFromFirebase() {
            guard let user = auth.currentUser else { return }
            
            db.collection("users").document(user.uid).getDocument { document, error in
                if let document = document, document.exists {
                    let data = document.data()
                    self.name = data?["name"] as? String ?? ""
                    self.rating = data?["rating"] as? Int ?? 0
                    self.city = data?["city"] as? String ?? "Göteborg"
                    self.numberOfBeds = data?["numberOfBeds"] as? Int ?? 0
                    self.numberOfRooms = data?["numberOfRooms"] as? Int ?? 0
                    self.homeInfo = data?["homeInfo"] as? String ?? ""
                    self.animalType = data?["animalType"] as? String ?? "Reptil"
                    self.animalAge = data?["animalAge"] as? Int ?? 0
                    self.animalInfo = data?["animalInfo"] as? String ?? ""
                    self.userAge = data?["userAge"] as? Int ?? 0
                    self.userInfo = data?["userInfo"] as? String ?? ""
                    self.animalExperienceType = data?["animalExperienceType"] as? String ?? "Katt"
                    self.animalExperienceInfo = data?["animalExperienceInfo"] as? String ?? ""
                } else {
                    print("Document does not exist")
                }
            }
        }
        func saveUserProfileToFirebase() {
            
            guard let user = auth.currentUser else {return}
            
            let userProfileData: [String: Any] = [
                "rating": self.rating,
                "city": self.city,
                "numberOfBeds": self.numberOfBeds,
                "numberOfRooms": self.numberOfRooms,
                "homeInfo": self.homeInfo,
                "animalType": self.animalType,
                "animalAge": self.animalAge,
                "animalInfo": self.animalInfo,
                "userAge": self.userAge,
                "userInfo": self.userInfo,
                "animalGuestExperienceType": self.animalExperienceType,
                "animalGuestExperienceInfo": self.animalExperienceInfo
            ]
            
            db.collection("users").document(user.uid).setData(userProfileData, merge: true) { error in
                if let error = error {
                    print("Error writing document: \(error)")
                } else {
                    print("Document sucessfully written!")
                }
                
            }
    }
}
