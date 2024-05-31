import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import Combine

class FirestoreUtils {
    private let db = Firestore.firestore()
    
    func fetchHomes(completion: @escaping (Result<[Home], Error>) -> Void) {
        db.collection("homes").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                if let querySnapshot = querySnapshot {
                    do {
                        let homes = try querySnapshot.documents.compactMap { document in
                            try document.data(as: Home.self)
                        }
                        completion(.success(homes))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.success([]))
                }
            }
        }
    }
    
    func updateFavoriteStatus(homeID: String, isFavorite: Bool, userID: String) -> AnyPublisher<Void, Error> {
        let userFavoritesRef = db.collection("users").document(userID).collection("favorites")
        return Future<Void, Error> { promise in
            if isFavorite {
                userFavoritesRef.document(homeID).setData(["homeID": homeID]) { error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                    }
                }
            } else {
                userFavoritesRef.document(homeID).delete { error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchFavoriteHomes(userID: String, completion: @escaping (Result<[Home], Error>) -> Void) {
        let userFavoritesRef = db.collection("users").document(userID).collection("favorites")
        userFavoritesRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let favoriteHomeIDs = querySnapshot?.documents.map { $0.documentID } ?? []
                let homesRef = self.db.collection("homes")
                let dispatchGroup = DispatchGroup()
                var favoriteHomes = [Home]()
                var fetchError: Error?
                
                for homeID in favoriteHomeIDs {
                    dispatchGroup.enter()
                    homesRef.document(homeID).getDocument { (document, error) in
                        if let error = error {
                            fetchError = error
                        } else if let document = document, document.exists {
                            do {
                                let home = try document.data(as: Home.self)
                                favoriteHomes.append(home)
                            } catch {
                                fetchError = error
                            }
                        }
                        dispatchGroup.leave()
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    if let fetchError = fetchError {
                        completion(.failure(fetchError))
                    } else {
                        completion(.success(favoriteHomes))
                    }
                }
            }
        }
    }
    
    func fetchUser(withID id: String, completion: @escaping (Result<User, Error>) -> Void) {
        db.collection("users").document(id).getDocument { (document, error) in
            if let document = document, document.exists {
                do {
                    let user = try document.data(as: User.self)
                    completion(.success(user))
                } catch let error {
                    completion(.failure(error))
                }
            } else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])))
                }
            }
        }
    }
    
    func saveHome(name: String, beds: Int, rooms: Int, size: Int, guests: Int, additionalInfoHome: String, city: String, country: String, availability: Int, startDate: Date, endDate: Date, selectedImages: [UIImage], animals: [AnimalInfo], rating: Double, activities: String, guestAccess: String, otherNotes: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "SaveHome", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user is logged in"])))
            return
        }
        
        let homeRef = db.collection("homes").document()
        
        // Convert array of AnimalInfo to dictionary
        var animalInfos: [String: AnimalInfo] = [:]
        for (index, animal) in animals.enumerated() {
            animalInfos["animal\(index)"] = animal
        }
        
        uploadImages(images: selectedImages) { result in
            switch result {
            case .success(let imageUrls):
                let home = Home(
                    id: homeRef.documentID,
                    userID: userID,
                    name: name,
                    beds: beds,
                    rooms: rooms,
                    size: size,
                    guests: guests,
                    animals: animalInfos,
                    additionalInfoHome: additionalInfoHome,
                    city: city,
                    availability: availability,
                    startDate: startDate,
                    endDate: endDate,
                    images: imageUrls,
                    rating: rating,
                    country: country,
                    activities: activities,
                    guestAccess: guestAccess,
                    otherNotes: otherNotes
                )
                
                // Save home document
                do {
                    try homeRef.setData(from: home) { error in
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            self.updateUserHomeIDs(userID: userID, homeID: homeRef.documentID, completion: completion)
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

    
    private func updateUserHomeIDs(userID: String, homeID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let userRef = db.collection("users").document(userID)
        
        userRef.getDocument { document, error in
            if let document = document, document.exists {
                userRef.updateData([
                    "homeIDs": FieldValue.arrayUnion([homeID])
                ]) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            } else {
                // If document does not exist, create the document with homeID
                userRef.setData([
                    "homeIDs": [homeID]
                ], merge: true) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            }
        }
    }
    
    func fetchUser(by userID: String, completion: @escaping (Result<User, Error>) -> Void) {
            db.collection("users").document(userID).getDocument { document, error in
                if let document = document, document.exists {
                    do {
                        let user = try document.data(as: User.self)
                        completion(.success(user))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])))
                    }
                }
            }
        }
    
    func uploadImages(images: [UIImage], completion: @escaping (Result<[String: URL], Error>) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("homeImages")
        
        var imageUrls: [String: URL] = [:]
        var uploadCount = 0
        
        for (index, image) in images.enumerated() {
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
                            
                            if uploadCount == images.count {
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
