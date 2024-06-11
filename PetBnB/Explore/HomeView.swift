import SwiftUI

struct HomeView: View {
    var images: [URL]
    var city: String
    var name: String
    var roomsBeds: String
    var availability: String
    var homeID: String

    @EnvironmentObject var viewModel: ExploreViewModel
    
    @State private var isFavorite: Bool = false
    @State private var isInitialized: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                ImageCarouselView(images: images)
                FavouriteButton(isFavorite: $isFavorite)
                    .onChange(of: isFavorite) { oldValue, newValue in
                        if oldValue != newValue {
                            viewModel.updateFavoriteStatus(for: homeID, isFavorite: newValue)
                        }
                    }
            }
            HomeInformationView(
                city: city,
                name: name,
                roomsBeds: roomsBeds,
                availability: availability
            )
        }
        .background(Color("background"))
        .cornerRadius(12)
        .shadow(radius: 4)
        .padding(.horizontal)
        .padding(.vertical, 8)
        .onAppear {
            if !isInitialized {
                viewModel.fetchFavoriteHomes(userID: viewModel.currentUserID) { result in
                    switch result {
                    case .success(let homes):
                        self.isFavorite = homes.contains { $0.id == homeID }
                        self.isInitialized = true
                    case .failure(let error):
                        print("Error fetching favorite status: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}

