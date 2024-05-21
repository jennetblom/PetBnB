import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

class FavoritesViewModel: ObservableObject, HomeListViewModel {
    @Published var homes = [Home]()
    @Published var loading = true
    @Published var searchText: String = ""
    private let firestoreUtils = FirestoreUtils()
    private var cancellables = Set<AnyCancellable>()

    init() {
        fetchHomes()
    }

    func fetchHomes() {
        loading = true
        firestoreUtils.fetchFavoriteHomes(userID: "currentUserID") { result in
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
