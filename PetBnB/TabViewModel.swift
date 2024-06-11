
import Foundation
import SwiftUI
import Combine

class TabViewModel: ObservableObject {
    @Published var selectedTab = 0
    @Published var isAddHomePresented = false
    @Published var isExploreDetailsPresented = false
    @Published var isProfileViewPresented = false 
    @Published var totalUnreadMessagesCount: Int = 0
    @Published var isMapViewPresented = false

    
    
    func dismissActiveViews() {
            isAddHomePresented = false
            isExploreDetailsPresented = false
            isProfileViewPresented = false
            isMapViewPresented = false 
        }
}
