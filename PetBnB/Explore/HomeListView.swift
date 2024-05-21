import SwiftUI

struct HomeListView: View {
    @ObservedObject var viewModel: ExploreViewModel
    var selectedFilter: String

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if viewModel.homes.isEmpty {
                    Text("No homes available")
                        .foregroundColor(.gray)
                } else {
                    ForEach(viewModel.homes.filter { $0.animals.keys.contains(selectedFilter) }) { home in
                        HomeView(
                            images: Array(home.images.values).sorted { $0.absoluteString < $1.absoluteString },
                            city: home.city,
                            description: home.additionalInfoHome,
                            roomsBeds: "\(home.rooms) rum, \(home.beds) sängar",
                            availability: "v.\(home.availability)",
                            rating: home.rating
                        )
                        .transition(.opacity)
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}
