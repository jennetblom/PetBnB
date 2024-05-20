import SwiftUI

struct ExploreView: View {
    @State private var selectedFilter: String = "Hund"
    
    let filters = ["Fågel", "Fisk", "Reptil", "Hund", "Katt", "Pälsdjur"]

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    TextField("Sök stad", text: .constant(""))
                        .padding(.leading, 10)
                }
                .padding()
                .background(Color("background"))
                .cornerRadius(8)
                .padding(.horizontal)
                
                ZStack(alignment: .bottom) {
                    HStack(spacing: 0) {
                        ForEach(filters, id: \.self) { filter in
                            FilterButton(filter: filter, isSelected: filter == selectedFilter) {
                                selectedFilter = filter
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
                        HomeView(
                            images: ["placeholder_home", "placeholder_home", "placeholder_home"],
                            city: "Göteborg",
                            description: "Fransk bulldog i villa",
                            roomsBeds: "3 rum, 2 sängar",
                            week: "v.28",
                            rating: "4.8"
                        )
                        HomeView(
                            images: ["placeholder_home", "placeholder_home", "placeholder_home"],
                            city: "Another City",
                            description: "Cozy cabin in the mountains",
                            roomsBeds: "2 rum, 1 säng",
                            week: "$900/week",
                            rating: "4.5"
                        )
                    }
                }
                
                Spacer()
            }
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
