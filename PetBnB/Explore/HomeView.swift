import SwiftUI

struct HomeView: View {
    var images: [String]
    var city: String
    var description: String
    var roomsBeds: String
    var week: String
    var rating: String

    @State private var isFavorite: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                TabView {
                    ForEach(images, id: \.self) { imageName in
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 250)
                            .clipped()
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .frame(height: 250)

                Button(action: {
                    isFavorite.toggle()
                }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(Color("details"))
                        .padding()
                        .background(Color.black.opacity(0.6))
                        .clipShape(Circle())
                        .padding()
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(city)
                            .font(.headline)
                        Text(description)
                            .font(.subheadline)
                        Text(roomsBeds)
                            .font(.subheadline)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(week)
                            .font(.headline)
                        HStack(spacing: 2) {
                            Text(rating)
                                .font(.subheadline)
                            Image(systemName: "star")
                                .font(.subheadline)
                                .foregroundColor(Color("details"))
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color("background"))
        .cornerRadius(8)
        .shadow(radius: 4)
        .padding(.horizontal)
    }
}

#Preview {
    HomeView(
        images: ["placeholder_home", "placeholder_home2", "placeholder_home3"],
        city: "Göteborg",
        description: "Fransk bulldog i villa",
        roomsBeds: "3 rum, 2 sängar",
        week: "v.28",
        rating: "4.8"
    )
}
