import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if viewModel.loading {
                ProgressView("Laddar...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                HomeListView(viewModel: viewModel)
            }
        }
        .navigationBarTitle("Favoriter", displayMode: .inline)

        .onAppear {
            viewModel.fetchHomes()
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    FavoritesView()
}
