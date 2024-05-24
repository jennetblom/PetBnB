import SwiftUI

struct ExploreView: View {
    @StateObject private var viewModel = ExploreViewModel()
    @State private var selectedFilter: String = "Hund"
    
    let filters = ["Fågel", "Fisk", "Reptil", "Hund", "Katt", "Pälsdjur"]

    var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                SearchBarView(searchText: $viewModel.searchText)
                FilterBarView(selectedFilter: $selectedFilter, filters: filters)
                
                if viewModel.loading {
                    ProgressView("Laddar...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    HomeListView(viewModel: viewModel, selectedFilter: selectedFilter)
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
                            .font(.title)
                            .foregroundColor(Color("details"))
                    }
                }
            }
        
    }
}

#Preview {
    ExploreView()
        .environmentObject(ExploreViewModel())
}

