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
           animals.append(AnimalInfo(type: "", age: 0, additionalInfoAnimal: ""))
       }
       
       func removeAnimal(at index: Int) {
           guard index < animalCount else { return }
           animals.remove(at: index)
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
