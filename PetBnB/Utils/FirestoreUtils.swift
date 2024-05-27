import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift
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
    
    func saveHome(homeTitle: String, beds: Int, rooms: Int, size: Int, additionalInfo: String, city: String, availability: Int, selectedImages: [UIImage], animalCount: Int, animalType: [String], animalAge: [Int], animalInfo: [String], rating: Double, completion: @escaping (Result<Void, Error>) -> Void) {
            let homeRef = db.collection("homes").document()

            var animalInfos: [String: AnimalInfo] = [:]
            for index in 0..<animalCount {
                let animalInfo = AnimalInfo(type: animalType[index], age: animalAge[index], additionalInfoAnimal: animalInfo[index])
                animalInfos["animal\(index)"] = animalInfo
            }

            uploadImages(images: selectedImages) { result in
                switch result {
                case .success(let imageUrls):
                    let home = Home(
                        id: homeRef.documentID,
                        name: homeTitle,
                        beds: beds,
                        rooms: rooms,
                        size: size,
                        animals: animalInfos,
                        additionalInfoHome: additionalInfo,
                        city: city,
                        availability: availability,
                        images: imageUrls,
                        rating: rating
                    )

                    // Spara hem dokumentet
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
