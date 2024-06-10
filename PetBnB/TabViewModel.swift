
import Foundation
import SwiftUI
import Combine

class TabViewModel: ObservableObject {
    @Published var selectedTab = 0
    @Published var isAddHomePresented = false
    @Published var isExploreDetailsPresented = false
    @Published var isProfileViewPresented = false 
    @Published var totalUnreadMessagesCount: Int = 0

}
