import SwiftUI

struct HomeListView<ViewModel: HomeListViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    var selectedFilter: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if viewModel.filteredHomes.isEmpty {
                    Text("Inga tillgängliga boende")
                        .foregroundColor(.gray)
                } else {
                    ForEach(viewModel.filteredHomes.filter { home in
                        guard let selectedFilter = selectedFilter else { return true }
                        return home.animals.keys.contains(selectedFilter)
                    }) { home in
                        HomeView(
                            images: Array(home.images.values).sorted { $0.absoluteString < $1.absoluteString },
                            city: home.city,
                            name: home.name,
                            roomsBeds: "\(home.rooms) rum, \(home.beds) sängar",
                            availability: "v.\(home.availability)",
                            rating: home.rating,
                            homeID: home.id ?? ""
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
