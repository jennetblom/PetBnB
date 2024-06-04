import SwiftUI

struct ExploreView: View {
    @StateObject private var viewModel = ExploreViewModel()
    @EnvironmentObject var tabViewModel: TabViewModel

    let filters = ["Fågel", "Fisk", "Reptil", "Hund", "Katt", "Pälsdjur"]

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                SearchBarView(searchText: $viewModel.searchText)
                FilterBarView(selectedFilter: $viewModel.selectedFilter, filters: filters)
                
                if viewModel.loading {
                    ProgressView("Laddar...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    HomeListView(viewModel: viewModel)
                }
            }
            .onAppear {
                viewModel.fetchHomes()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        tabViewModel.isAddHomePresented = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(Color("secondary"))
                    }
                }
            }
            .navigationDestination(isPresented: $tabViewModel.isAddHomePresented) {
                AddHomeView()
            }
        }
    }
}

#Preview {
    ExploreView()
        .environmentObject(ExploreViewModel())
        .environmentObject(TabViewModel())
}
