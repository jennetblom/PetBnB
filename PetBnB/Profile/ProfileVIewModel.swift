import Foundation
import Firebase
import FirebaseStorage

class ProfileViewModel: ObservableObject {
    
    let db = Firestore.firestore()
    let auth = Auth.auth()
    
    let storage = Storage.storage()
    
    @Published var users = [User]()
    
    
    @Published var name = ""
    @Published var rating: Double = 3
    @Published var ratingCount = 0
    @Published var city = "Stockholm"
    @Published var numberOfBeds = 0
    @Published var guests = 0
    @Published var bathrooms = 0
    @Published var size = 20
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
    @Published var profilePictureUrl: URL?
    
    func addAnimal() {
         animalType.append("Fågel")
         animalAge.append(0)
         animalInfo.append("")
         animalCount += 1
     }
    func fetchUserProfileFromFirebase(for userID: String, completion: @escaping () -> Void) {
        
        db.collection("users").document(userID).getDocument { [weak self] document, error in
            guard let self = self else { return }
            if let document = document, document.exists {
                guard let data = document.data() else { return }
                DispatchQueue.main.async {
                    self.name = data["name"] as? String ?? ""
                    self.rating = data["rating"] as? Double ?? 0
                    self.ratingCount = data["ratingCount"] as? Int ?? 0
                    self.city = data["city"] as? String ?? "Göteborg"
                    self.numberOfBeds = data["numberOfBeds"] as? Int ?? 0
                    self.guests = data["guests"] as? Int ?? 0
                    self.bathrooms = data["bathrooms"] as? Int ?? 0
                    self.size = data["size"] as? Int ?? 0
                    self.numberOfRooms = data["numberOfRooms"] as? Int ?? 0
                    self.homeInfo = data["homeInfo"] as? String ?? ""
                    self.userAge = data["userAge"] as? Int ?? 0
                    self.userInfo = data["userInfo"] as? String ?? ""
                    self.animalExperienceType = data["animalExperienceType"] as? String ?? "Katt"
                    self.animalExperienceInfo = data["animalExperienceInfo"] as? String ?? ""
                
                    if let profilePictureUrlString = data["profilePictureUrl"] as? String,
                        let url = URL(string: profilePictureUrlString) {
                        self.profilePictureUrl = url
                    }
                
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
                    completion()
                }
            } else {
                print("Document does not exist")
                completion()
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
                 "ratingCount": self.ratingCount,
                 "city": self.city,
                 "numberOfBeds": self.numberOfBeds,
                 "guests": self.guests,
                 "bathrooms": self.bathrooms,
                 "size": self.size,
                 "numberOfRooms": self.numberOfRooms,
                 "homeInfo": self.homeInfo,
                 "animals": animalInfos.mapValues { ["type": $0.type, "age": $0.age, "additionalInfoAnimal": $0.additionalInfoAnimal] },
                 "userAge": self.userAge,
                 "userInfo": self.userInfo,
                 "animalExperienceType": self.animalExperienceType,
                 "animalExperienceInfo": self.animalExperienceInfo,
                 
                 "profilePictureUrl": self.profilePictureUrl?.absoluteString ?? ""
             ]
             
             db.collection("users").document(user.uid).setData(userProfileData, merge: true) { error in
                 if let error = error {
                     print("Error writing document: \(error)")
                 } else {
                     print("Document successfully written!")
                 }
             }
    }

    func uploadProfileImage(_ image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(nil)
            return
        }

        let storageRef = Storage.storage().reference().child("profile_images/\(UUID().uuidString).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        storageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(nil)
                return
            }

            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    completion(nil)
                    return
                }

                completion(url)
            }
        }
    }

    func saveProfileImageUrl(_ url: URL) {
        guard let user = auth.currentUser else { return }
        
        db.collection("users").document(user.uid).updateData([
            "profilePictureUrl": url.absoluteString
        ]) { error in
            if let error = error {
                print("Error updating profile picture URL: \(error)")
            } else {
                print("Profile picture URL successfully updated!")
            }
        }
    }
    
    func saveUserRatingToFirebase(for userID: String) {
        guard let currentUserID = auth.currentUser?.uid else { return }
        
        if currentUserID != userID {
            let userDocRef = db.collection("users").document(userID)
            
            // Update selected user rating
            userDocRef.updateData([
                "rating": self.rating,
                "ratingCount": self.ratingCount
            ]) { error in
                if let error = error {
                    print("Error updating rating: \(error)")
                } else {
                    print("Rating successfully updated!")
                }
            }
        } else {
            print("Cannot rate yourself")
        }
    }
}
