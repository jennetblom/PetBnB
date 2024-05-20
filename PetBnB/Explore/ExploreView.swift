import SwiftUI

struct ExploreView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var selectedFilter: String = "Hund"
    
    let filters = ["Fågel", "Fisk", "Reptil", "Hund", "Katt", "Pälsdjur"]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                TextField("Sök stad", text: .constant(""))
                    .padding(.leading, 10)
            }
            .padding(.top)
            .background(Color("background"))
            .cornerRadius(8)
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .bottom) {
                    HStack(spacing: 0) {
                        ForEach(filters, id: \.self) { filter in
                            FilterButton(filter: filter, isSelected: filter == selectedFilter) {
                                selectedFilter = filter
                                print("Selected filter: \(filter)")
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color("background"))
                    .padding(.vertical, 0)
                    .padding(.trailing, 10)
                    
                    Rectangle()
                        .fill(Color.gray)
                        .frame(height: 0.5)
                        .padding(.bottom, 8)
                }
                .padding(.top)

                ScrollView {
                    VStack(spacing: 16) {
                        if viewModel.homes.isEmpty {
                            Text("No homes available")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(viewModel.homes.filter { $0.animals.keys.contains(selectedFilter) }) { home in
                                HomeView(
                                    images: Array(home.images.values),
                                    city: home.city,
                                    description: home.additionalInfoHome,
                                    roomsBeds: "\(home.rooms) rum, \(home.beds) sängar",
                                    availability: "v.\(home.availability)",
                                    rating: home.rating
                                )
                                .onAppear {
                                    print("Displayed home: \(home.name)")
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal) 
                }
            }
            .padding(.top)
        }
        .onAppear {
            print("ExploreView appeared, fetching homes...")
            viewModel.fetchHomes()
        }
    }
}

struct FilterButton: View {
    var filter: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack {
                Text(filter)
                    .font(.system(size: 16))
                    .fontWeight(isSelected ? .bold : .regular)
                    .foregroundColor(isSelected ? Color("text") : .primary)
                Rectangle()
                    .fill(isSelected ? Color("text") : Color.clear)
                    .frame(height: 2)
                    .transition(.slide)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .padding(.horizontal, 0)
        }
    }
}

#Preview {
    ExploreView()
}
