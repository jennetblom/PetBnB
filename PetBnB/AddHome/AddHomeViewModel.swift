import SwiftUI
import Combine
import PhotosUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

class AddHomeViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var beds: Int = 0
    @Published var rooms: Int = 0
    @Published var bathrooms: Int = 0
    @Published var size: Int = 0
    @Published var guests: Int = 0
    @Published var additionalInfoHome: String = ""
    @Published var city: String = ""
    @Published var country: String = ""
    var availability: Int = 0
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var selectedImages: [UIImage] = []
    @Published var animals: [AnimalInfo] = [AnimalInfo(type: "", age: 0, additionalInfoAnimal: "")]
    @Published var rating: Double = 0.0
    @Published var isShowingImagePicker: Bool = false
    @Published var activities: String = ""
    @Published var guestAccess: String = ""
    @Published var otherNotes: String = ""
    @Published var latitude: Double?
    @Published var longitude: Double?
    
    
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
            !name.isEmpty &&
            beds > 0 &&
            rooms > 0 &&
            size > 0 &&
            bathrooms > 0 &&
            guests > 0 &&
            !guestAccess.isEmpty &&
            !activities.isEmpty &&
            latitude != nil &&
            selectedImages != [] &&
            longitude != nil &&
            !additionalInfoHome.isEmpty &&
            !city.isEmpty &&
            !animals.contains { $0.type.isEmpty || $0.age == 0 || $0.additionalInfoAnimal.isEmpty }
        }
    
    func saveHome(completion: @escaping (Result<Void, Error>) -> Void) {
        calculateAvailability()
        firestoreUtils.saveHome(
            name: name,
            beds: beds,
            rooms: rooms,
            size: size,
            guests: guests,
            additionalInfoHome: additionalInfoHome,
            city: city,
            country: country,
            bathrooms: bathrooms,
            availability: availability,
            startDate: startDate,
            endDate: endDate,
            selectedImages: selectedImages,
            animals: animals,
            rating: rating,
            activities: activities,
            guestAccess: guestAccess,
            otherNotes: otherNotes,
            latitude: latitude,
            longitude: longitude,
            completion: completion
        )
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
                    self.guests = user.guests
                    self.bathrooms = user.bathrooms
                    self.size = user.size
                    self.additionalInfoHome = user.homeInfo
                    self.rooms = user.numberOfRooms
                    self.animals = user.animals.map { AnimalInfo(type: $0.value.type, age: $0.value.age, additionalInfoAnimal: $0.value.additionalInfoAnimal) }
                }
            case .failure(let error):
                print("Error fetching user: \(error)")
            }
        }
    }
    func fetchCity(completion: @escaping (Result<String, Error>) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "No user logged in"])))
            return
        }
        
        firestoreUtils.fetchUser(withID: userID) { result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    completion(.success(user.city))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
