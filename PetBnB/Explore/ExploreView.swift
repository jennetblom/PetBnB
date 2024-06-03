import SwiftUI

struct ExploreView: View {
    @StateObject private var viewModel = ExploreViewModel()
    
    let filters = ["Fågel", "Fisk", "Reptil", "Hund", "Katt", "Pälsdjur"]

    var body: some View {
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
        .environmentObject(viewModel)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: AddHomeView()) {
                    Image(systemName: "plus")
                        .foregroundColor(Color("secondary"))
                }
            }
        }
    }
}

#Preview {
    ExploreView()
        .environmentObject(ExploreViewModel())
}
