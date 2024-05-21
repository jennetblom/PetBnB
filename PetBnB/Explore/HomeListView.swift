import SwiftUI

struct HomeListView<ViewModel: HomeListViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    var selectedFilter: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if viewModel.homes.isEmpty {
                    Text("No homes available")
                        .foregroundColor(.gray)
                } else {
                    ForEach(viewModel.homes.filter { home in
                        guard let selectedFilter = selectedFilter else { return true }
                        return home.animals.keys.contains(selectedFilter)
                    }) { home in
                        HomeView(
                            images: Array(home.images.values).sorted { $0.absoluteString < $1.absoluteString },
                            city: home.city,
                            description: home.additionalInfoHome,
                            roomsBeds: "\(home.rooms) rum, \(home.beds) sängar",
                            availability: "v.\(home.availability)",
                            rating: home.rating,
                            homeID: home.id ?? ""
                        )
                        .transition(.opacity)
                        .environmentObject(viewModel)
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}
