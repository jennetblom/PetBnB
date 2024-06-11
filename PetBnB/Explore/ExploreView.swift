import SwiftUI

struct ExploreView: View {
    @StateObject private var viewModel = ExploreViewModel()
    @EnvironmentObject var tabViewModel: TabViewModel

    let filters = ["Fågel", "Fisk", "Reptil", "Hund", "Katt", "Pälsdjur"]

    var body: some View {
        NavigationStack {
            content
            .toolbar { navigationToolbar }
            .navigationDestination(isPresented: $tabViewModel.isAddHomePresented) {
                AddHomeView()
            }
        }
    }

private var content: some View {
        VStack(alignment: .leading, spacing: 0) {
            SearchBarView(searchText: $viewModel.searchText)
            FilterBarView(selectedFilter: $viewModel.selectedFilter, filters: filters)
            homesList
        }
        .onAppear(perform: viewModel.fetchHomes)
    }

private var homesList: some View {
        Group {
            if viewModel.loading {
                ProgressView("Laddar...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                HomeListView(viewModel: viewModel)
            }
        }
    }
private var navigationToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            addButton
        }
    }

    private var addButton: some View {
        Button(action: { tabViewModel.isAddHomePresented = true }) {
            Image(systemName: "plus")
                .foregroundColor(Color("secondary"))
        }
    }
}


