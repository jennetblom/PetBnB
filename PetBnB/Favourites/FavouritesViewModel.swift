import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class FavoritesViewModel: ObservableObject, HomeListViewModel {
    @Published var homes = [Home]()
    @Published var loading = true
    @Published var searchText: String = ""
    private let firestoreUtils = FirestoreUtils()
    private var cancellables = Set<AnyCancellable>()

    var currentUserID: String? {
        Auth.auth().currentUser?.uid
    }

    init() {
        fetchHomes()
    }

    func fetchHomes() {
        guard let userID = currentUserID else {
            print("Error: No user is currently signed in.")
            self.loading = false
            return
        }

        loading = true
        firestoreUtils.fetchFavoriteHomes(userID: userID) { result in
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

    var filteredHomes: [Home] {
        homes.filter { home in
            searchText.isEmpty || home.city.lowercased().contains(searchText.lowercased())
        }
    }
}
