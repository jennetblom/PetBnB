
import Foundation
import SwiftUI
import Combine

class TabViewModel: ObservableObject {
    @Published var selectedTab = 0
    @Published var isAddHomePresented = false
    @Published var isExploreDetailsPresented = false
    @Published var isProfileViewPresented = false
    @Published var isMapViewPresented = false
    @Published var isChatWindowPresented = false
    @Published var totalUnreadMessagesCount: Int = 0
    @Published var returningFromMap = false

    
    
    func dismissActiveViews() {
        if isMapViewPresented {
            isMapViewPresented = false
        } else {
            isAddHomePresented = false
            isExploreDetailsPresented = false
            isProfileViewPresented = false
            isMapViewPresented = false
            isChatWindowPresented = false
        }
    }
}
