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
    var availability: Int = 0
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var selectedImages: [UIImage] = []
    @Published var animals: [AnimalInfo] = [AnimalInfo(type: "", age: 0, additionalInfoAnimal: "")]
    @Published var rating: Double = 0.0
    @Published var isShowingImagePicker: Bool = false
    
    var animalCount: Int {
        animals.count
    }
    
    private let firestoreUtils = FirestoreUtils()
    
    func addAnimal() {
        DispatchQueue.main.async {
            self.animals.append(AnimalInfo(type: "", age: 0, additionalInfoAnimal: ""))
            print("Added animal. Current count: \(self.animalCount)")
        }
    }
    
    func removeAnimal(at index: Int) {
        DispatchQueue.main.async {
            guard index < self.animalCount else {
                print("Index \(index) out of range. Current count: \(self.animalCount)")
                return
            }
            self.animals.remove(at: index)
            print("Removed animal at index \(index). Current count: \(self.animalCount)")
        }
    }
    
    var canSave: Bool {
            !homeTitle.isEmpty &&
            beds > 0 &&
            rooms > 0 &&
            size > 0 &&
            !additionalInfo.isEmpty &&
            !city.isEmpty &&
            !animals.contains { $0.type.isEmpty || $0.age == 0 || $0.additionalInfoAnimal.isEmpty }
        }
    
    func saveHome(completion: @escaping (Result<Void, Error>) -> Void) {
        calculateAvailability()
        firestoreUtils.saveHome(homeTitle: homeTitle, beds: beds, rooms: rooms, size: size, additionalInfo: additionalInfo, city: city, availability: availability, startDate: startDate, endDate: endDate, selectedImages: selectedImages, animals: animals, rating: rating, completion: completion)
    }
    
    func calculateAvailability() {
        let calendar = Calendar.current
        let weekOfYear = calendar.component(.weekOfYear, from: startDate)
        availability = weekOfYear
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
                    self.animals = user.animals.map { AnimalInfo(type: $0.value.type, age: $0.value.age, additionalInfoAnimal: $0.value.additionalInfoAnimal) }
                }
            case .failure(let error):
                print("Error fetching user: \(error)")
            }
        }
    }
}
