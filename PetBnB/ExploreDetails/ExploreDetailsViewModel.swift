import Foundation
import Combine
import FirebaseFirestore

class ExploreDetailsViewModel: ObservableObject {
    @Published var user: User?
    private var cancellables = Set<AnyCancellable>()
    private let firestoreUtils = FirestoreUtils()
    
    func fetchUser(by userID: String) {
        firestoreUtils.fetchUser(by: userID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.user = user
                case .failure(let error):
                    print("Error fetching user: \(error.localizedDescription)")
                }
            }
        }
    }
}
