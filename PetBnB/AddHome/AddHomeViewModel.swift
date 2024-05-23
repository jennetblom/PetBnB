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

    func addAnimal() {
        animalType.append("")
        animalAge.append(0)
        animalInfo.append("")
        animalCount += 1
    }

    func saveHome(completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        let homeRef = db.collection("homes").document()
        
        var animalInfos: [String: AnimalInfo] = [:]
        for index in 0..<animalCount {
            let animalInfo = AnimalInfo(type: animalType[index], age: animalAge[index], additionalInfoAnimal: animalInfo[index])
            animalInfos["animal\(index)"] = animalInfo
        }

        uploadImages { result in
            switch result {
            case .success(let imageUrls):
                let home = Home(
                    id: homeRef.documentID,
                    name: self.homeTitle,
                    beds: self.beds,
                    rooms: self.rooms,
                    size: self.size,
                    animals: animalInfos,
                    additionalInfoHome: self.additionalInfo,
                    city: self.city,
                    availability: self.availability,
                    images: imageUrls,
                    rating: self.rating
                )

                // Save home document
                do {
                    try homeRef.setData(from: home) { error in
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            completion(.success(()))
                        }
                    }
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func uploadImages(completion: @escaping (Result<[String: URL], Error>) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("homeImages")
        
        var imageUrls: [String: URL] = [:]
        var uploadCount = 0

        for (index, image) in selectedImages.enumerated() {
            let imageRef = storageRef.child(UUID().uuidString + ".jpg")
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                imageRef.putData(imageData, metadata: nil) { metadata, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }

                    imageRef.downloadURL { url, error in
                        if let error = error {
                            completion(.failure(error))
                            return
                        }

                        if let url = url {
                            imageUrls["image\(index)"] = url
                            uploadCount += 1

                            if uploadCount == self.selectedImages.count {
                                completion(.success(imageUrls))
                            }
                        }
                    }
                }
            } else {
                completion(.failure(NSError(domain: "imageDataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not convert image to data."])))
                return
            }
        }
    }
}
