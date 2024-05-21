import Foundation

protocol HomeListViewModel: ObservableObject {
    var homes: [Home] { get }
    var loading: Bool { get }
    func fetchHomes()
}
