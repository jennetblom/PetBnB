import SwiftUI

struct ExploreDetailsView: View {
    var home: Home

    var body: some View {
        VStack {
            Text(home.city)
                .font(.largeTitle)            
        }
    }
}


