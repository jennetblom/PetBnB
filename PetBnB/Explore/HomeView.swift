import SwiftUI

struct HomeView: View {
    var images: [URL]
    var city: String
    var name: String
    var roomsBeds: String
    var availability: String
    var homeID: String

    @State private var isFavorite: Bool = false
    @State private var isInitialized: Bool = false
    @EnvironmentObject var viewModel: ExploreViewModel

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

#Preview {
    HomeView(
        images: [
            URL(string: "https://firebasestorage.googleapis.com/v0/b/petbnb-267ff.appspot.com/o/placeholder_home.png?alt=media&token=0e13552e-0052-4bd2-9170-856beacea3b1")!,
            URL(string: "https://firebasestorage.googleapis.com/v0/b/petbnb-267ff.appspot.com/o/placeholder_home2.png?alt=media&token=a2c1ea5a-134a-466d-be39-19aedfa13e9a")!,
            URL(string: "https://firebasestorage.googleapis.com/v0/b/petbnb-267ff.appspot.com/o/placeholder_home3.png?alt=media&token=2f52cde5-4812-43df-8772-82c6c54d7b71")!
        ],
        city: "Göteborg",
        name: "Fransk bulldog i villa",
        roomsBeds: "3 rum, 2 sängar",
        availability: "v.28",
        homeID: "example_home_id"
    ).environmentObject(ExploreViewModel())
}
