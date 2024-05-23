import SwiftUI

struct HomeView: View {
    var images: [URL]
    var city: String
    var name: String
    var roomsBeds: String
    var availability: String
    var rating: Double
    var homeID: String

    @State private var isFavorite: Bool = false
    @State private var isInitialized: Bool = false
    @EnvironmentObject var viewModel: ExploreViewModel

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                ImageCarouselView(images: images)
                FavouriteButton(isFavorite: $isFavorite)
                    .onChange(of: isFavorite) { newValue in
                        viewModel.updateFavoriteStatus(for: homeID, isFavorite: newValue)
                    }
            }
            HomeInformationView(
                city: city,
                name: name,
                roomsBeds: roomsBeds,
                availability: availability,
                rating: rating
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
