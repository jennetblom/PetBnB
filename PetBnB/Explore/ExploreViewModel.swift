import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

class ExploreViewModel: ObservableObject {
    @Published var homes = [Home]()
    @Published var loading = true
    private let firestoreUtils = FirestoreUtils()

    init() {
        fetchHomes()
    }

    func fetchHomes() {
        loading = true
        firestoreUtils.fetchHomes { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let homes):
                    self.homes = homes
                    self.loading = false
                case .failure(let error):
                    print("Error fetching homes: \(error.localizedDescription)")
                    self.loading = false
                }
            }
        }
    }
}
