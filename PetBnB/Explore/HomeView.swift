import SwiftUI

struct HomeView: View {
    var images: [URL]
    var city: String
    var description: String
    var roomsBeds: String
    var availability: String
    var rating: Double

    @State private var isFavorite: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                TabView {
                    ForEach(images, id: \.self) { imageUrl in
                        AsyncImage(url: imageUrl) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 250)
                                    .clipped()
                            } else if phase.error != nil {
                                Color.red 
                                    .frame(height: 250)
                            } else {
                                Color.gray
                                    .frame(height: 250)
                            }
                        }
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
                        Text(availability)
                            .font(.headline)
                        HStack(spacing: 2) {
                            Text(String(format: "%.1f", rating))
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
        images: [
                    URL(string: "https://firebasestorage.googleapis.com/v0/b/petbnb-267ff.appspot.com/o/placeholder_home.png?alt=media&token=0e13552e-0052-4bd2-9170-856beacea3b1")!,
                    URL(string: "https://firebasestorage.googleapis.com/v0/b/petbnb-267ff.appspot.com/o/placeholder_home2.png?alt=media&token=a2c1ea5a-134a-466d-be39-19aedfa13e9a")!,
                    URL(string: "https://firebasestorage.googleapis.com/v0/b/petbnb-267ff.appspot.com/o/placeholder_home3.png?alt=media&token=2f52cde5-4812-43df-8772-82c6c54d7b71")!
                ],
        city: "Göteborg",
        description: "Fransk bulldog i villa",
        roomsBeds: "3 rum, 2 sängar",
        availability: "v.28",
        rating: 4.8
    )
}
