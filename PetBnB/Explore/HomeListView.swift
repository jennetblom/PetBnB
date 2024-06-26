import SwiftUI

struct HomeListView<ViewModel: HomeListViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    @EnvironmentObject var tabViewModel: TabViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if viewModel.filteredHomes.isEmpty {
                    Text("Inga tillgängliga boende")
                        .foregroundColor(.gray)
                } else {
                    ForEach(viewModel.filteredHomes) { home in
                        NavigationLink(destination: ExploreDetailsView(home: home).environmentObject(tabViewModel)) {
                            HomeView(
                                images: Array(home.images.values).sorted { $0.absoluteString < $1.absoluteString },
                                city: home.city,
                                name: home.name,
                                roomsBeds: "\(home.rooms) rum, \(home.beds) sängar",
                                availability: "v.\(home.availability)",
                                homeID: home.id ?? ""
                            )
                            .transition(.opacity)
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}
