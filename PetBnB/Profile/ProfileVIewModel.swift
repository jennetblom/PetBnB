
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
    @Published var housingInfo = ""
    @Published var animalType = "Katt"
    @Published var animalAge = 0
    @Published var animalInfo = ""
    @Published var userGuestAge = 0
    @Published var userGuestInfo = ""
    @Published var animalGuestExperienceType = "Reptil"
    @Published var animalGuestExperienceInfo = ""
    
    func fetchUserProfileFromFirebase() {
            guard let user = auth.currentUser else { return }
            
            db.collection("users").document(user.uid).getDocument { document, error in
                if let document = document, document.exists {
                    let data = document.data()
                    self.name = data?["name"] as? String ?? ""
                    self.rating = data?["rating"] as? Int ?? 0
                    self.city = data?["city"] as? String ?? ""
                    self.numberOfBeds = data?["numberOfBeds"] as? Int ?? 0
                    self.numberOfRooms = data?["numberOfRooms"] as? Int ?? 0
                    self.housingInfo = data?["housingInfo"] as? String ?? ""
                    self.animalType = data?["animalType"] as? String ?? ""
                    self.animalAge = data?["animalAge"] as? Int ?? 0
                    self.animalInfo = data?["animalInfo"] as? String ?? ""
                    self.userGuestAge = data?["userGuestAge"] as? Int ?? 0
                    self.userGuestInfo = data?["userGuestInfo"] as? String ?? ""
                    self.animalGuestExperienceType = data?["animalGuestExperienceType"] as? String ?? ""
                    self.animalGuestExperienceInfo = data?["animalGuestExperienceInfo"] as? String ?? ""
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
                "housingInfo": self.housingInfo,
                "animalType": self.animalType,
                "animalAge": self.animalAge,
                "animalInfo": self.animalInfo,
                "userGuestAge": self.userGuestAge,
                "userGuestInfo": self.userGuestInfo,
                "animalGuestExperienceType": self.animalGuestExperienceType,
                "animalGuestExperienceInfo": self.animalGuestExperienceInfo
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
