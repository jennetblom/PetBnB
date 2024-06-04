
import Foundation

class TabViewModel: ObservableObject {
    @Published var selectedTab = 0
    @Published var isAddHomePresented = false
}
