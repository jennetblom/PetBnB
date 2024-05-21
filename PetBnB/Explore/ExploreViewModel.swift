import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

class ExploreViewModel: ObservableObject, HomeListViewModel {
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
    
    func updateFavoriteStatus(for homeID: String, isFavorite: Bool) {
        firestoreUtils.updateFavoriteStatus(homeID: homeID, isFavorite: isFavorite)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error updating favorite status: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] in
                self?.fetchHomes()
            })
            .store(in: &cancellables)
    }

    var filteredHomes: [Home] {
        homes.filter { home in
            searchText.isEmpty || home.city.lowercased().contains(searchText.lowercased())
        }
    }
}
