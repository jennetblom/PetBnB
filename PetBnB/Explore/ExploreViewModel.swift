import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class ExploreViewModel: ObservableObject, HomeListViewModel {
    @Published var homes = [Home]()
    @Published var loading = true
    @Published var searchText: String = ""
    @Published var selectedFilter: String? = nil
    private let firestoreUtils = FirestoreUtils()
    private var cancellables = Set<AnyCancellable>()
    
    var currentUserID: String {
        Auth.auth().currentUser?.uid ?? "unknownUser"
    }
    
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
        firestoreUtils.updateFavoriteStatus(homeID: homeID, isFavorite: isFavorite, userID: currentUserID)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error updating favorite status: \(error.localizedDescription)")
                }
            }, receiveValue: {

            })
            .store(in: &cancellables)
    }
    
    func fetchFavoriteHomes(userID: String, completion: @escaping (Result<[Home], Error>) -> Void) {
        firestoreUtils.fetchFavoriteHomes(userID: userID, completion: completion)
    }

    var filteredHomes: [Home] {
        homes.filter { home in
            (searchText.isEmpty || home.city.lowercased().contains(searchText.lowercased())) &&
            (selectedFilter == nil || home.animals.values.contains(where: { $0.type.lowercased() == selectedFilter!.lowercased() }))
        }
    }
}
