import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

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
}
