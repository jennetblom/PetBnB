import Foundation

protocol HomeListViewModel: ObservableObject {
    var homes: [Home] { get }
    var loading: Bool { get }
    var searchText: String { get set }
    var filteredHomes: [Home] { get }
    func fetchHomes()
}
