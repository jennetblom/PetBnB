import Foundation
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
    
    func updateFavoriteStatus(homeID: String, isFavorite: Bool) -> AnyPublisher<Void, Error> {
        let userFavoritesRef = db.collection("users").document("currentUserID").collection("favorites")
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
}
