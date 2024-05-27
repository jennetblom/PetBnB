import SwiftUI
import Combine
import PhotosUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

class AddHomeViewModel: ObservableObject {
    @Published var homeTitle: String = ""
    @Published var beds: Int = 0
    @Published var rooms: Int = 0
    @Published var size: Int = 0
    @Published var additionalInfo: String = ""
    @Published var city: String = ""
    @Published var availability: Int = 0
    @Published var selectedImages: [UIImage] = []
    @Published var animalCount: Int = 1
    @Published var animalType: [String] = [""]
    @Published var animalAge: [Int] = [0]
    @Published var animalInfo: [String] = [""]
    @Published var rating: Double = 0.0
    @Published var isShowingImagePicker: Bool = false
    
    private let firestoreUtils = FirestoreUtils()

    func addAnimal() {
        animalType.append("")
        animalAge.append(0)
        animalInfo.append("")
        animalCount += 1
    }

    func saveHome(completion: @escaping (Result<Void, Error>) -> Void) {
        firestoreUtils.saveHome(homeTitle: homeTitle, beds: beds, rooms: rooms, size: size, additionalInfo: additionalInfo, city: city, availability: availability, selectedImages: selectedImages, animalCount: animalCount, animalType: animalType, animalAge: animalAge, animalInfo: animalInfo, rating: rating, completion: completion)
        //TODO: Save chosen availability
    }

    func uploadImages(completion: @escaping (Result<[String: URL], Error>) -> Void) {
        firestoreUtils.uploadImages(images: selectedImages, completion: completion)
    }
    
    func fetchAndUpdateUser() {
            guard let userID = Auth.auth().currentUser?.uid else {
                print("Error: No user is logged in")
                return
            }
            firestoreUtils.fetchUser(withID: userID) { result in
                switch result {
                case .success(let user):
                    DispatchQueue.main.async {
                        self.city = user.city
                        self.beds = user.numberOfBeds
                        self.rooms = user.numberOfRooms
                        self.animalType = user.animals.map { $0.value.type }
                        self.animalAge = user.animals.map { $0.value.age }
                        self.animalInfo = user.animals.map { $0.value.additionalInfoAnimal }
                        self.animalCount = user.animals.count
                    }
                case .failure(let error):
                    print("Error fetching user: \(error)")
                }
            }
        }
}
