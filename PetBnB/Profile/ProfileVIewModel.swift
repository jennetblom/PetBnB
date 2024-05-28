
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
    @Published var animalCount = 1
    @Published var animalType = ["Katt"]
    @Published var animalAge = [0]
    @Published var animalInfo = [""]
    @Published var userAge = 0
    @Published var userInfo = ""
    @Published var animalExperienceType = "Reptil"
    @Published var animalExperienceInfo = ""
    
    func addAnimal() {
         animalType.append("Fågel")
         animalAge.append(0)
         animalInfo.append("")
         animalCount += 1
     }
    func fetchUserProfileFromFirebase() {
        guard let user = auth.currentUser else { return }
        
        db.collection("users").document(user.uid).getDocument { [weak self] document, error in
            guard let self = self else { return }
            if let document = document, document.exists {
                guard let data = document.data() else { return }
                DispatchQueue.main.async {
                    self.name = data["name"] as? String ?? ""
                    self.rating = data["rating"] as? Int ?? 0
                    self.city = data["city"] as? String ?? "Göteborg"
                    self.numberOfBeds = data["numberOfBeds"] as? Int ?? 0
                    self.numberOfRooms = data["numberOfRooms"] as? Int ?? 0
                    self.homeInfo = data["homeInfo"] as? String ?? ""
                    self.userAge = data["userAge"] as? Int ?? 0
                    self.userInfo = data["userInfo"] as? String ?? ""
                    self.animalExperienceType = data["animalExperienceType"] as? String ?? "Katt"
                    self.animalExperienceInfo = data["animalExperienceInfo"] as? String ?? ""
                    
                    if let animalsData = data["animals"] as? [String: [String: Any]] {
                        self.animalType.removeAll()
                        self.animalAge.removeAll()
                        self.animalInfo.removeAll()
                        
                        for index in 0..<animalsData.count {
                            if let animalData = animalsData["animal\(index)"] {
                                self.animalType.append(animalData["type"] as? String ?? "Reptil")
                                self.animalAge.append(animalData["age"] as? Int ?? 0)
                                self.animalInfo.append(animalData["additionalInfoAnimal"] as? String ?? "")
                            }
                        }
                        self.animalCount = animalsData.count
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
        func saveUserProfileToFirebase() {
            guard let user = auth.currentUser else { return }
                 
                 var animalInfos: [String: AnimalInfo] = [:]
                 for index in 0..<animalCount {
                     let animalInfo = AnimalInfo(type: animalType[index], age: animalAge[index], additionalInfoAnimal: animalInfo[index])
                     animalInfos["animal\(index)"] = animalInfo
                 }
                 
                 let userProfileData: [String: Any] = [
                     "name": self.name,
                     "rating": self.rating,
                     "city": self.city,
                     "numberOfBeds": self.numberOfBeds,
                     "numberOfRooms": self.numberOfRooms,
                     "homeInfo": self.homeInfo,
                     "animals": animalInfos.mapValues { ["type": $0.type, "age": $0.age, "additionalInfoAnimal": $0.additionalInfoAnimal] },
                     "userAge": self.userAge,
                     "userInfo": self.userInfo,
                     "animalExperienceType": self.animalExperienceType,
                     "animalExperienceInfo": self.animalExperienceInfo
                 ]
                 
                 db.collection("users").document(user.uid).setData(userProfileData, merge: true) { error in
                     if let error = error {
                         print("Error writing document: \(error)")
                     } else {
                         print("Document successfully written!")
                     }
                 }
             }
}
