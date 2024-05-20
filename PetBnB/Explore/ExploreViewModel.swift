import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

class ExploreViewModel: ObservableObject {
    @Published var homes = [Home]()
    private let firestoreUtils = FirestoreUtils()

    init() {
        fetchHomes()
    }

    func fetchHomes() {
           firestoreUtils.fetchHomes { result in
               switch result {
               case .success(let homes):
                   DispatchQueue.main.async {
                       self.homes = homes
                   }
               case .failure(let error):
                   print("Error fetching homes: \(error.localizedDescription)")
               }
           }
       }
}
