import SwiftUI

struct ExploreDetailsView: View {
    var home: Home

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Image Carousel
                ImageCarouselView(images: Array(home.images.values).sorted { $0.absoluteString < $1.absoluteString })
                    .frame(height: 300)
                
                // Home name and rating
                HStack {
                    Text(home.name)
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    HStack(spacing: 2) {
                        Text(String(format: "%.1f", home.rating))
                            .font(.headline)
                        Image(systemName: "star.fill")
                            .foregroundColor(Color(red: 1.0, green: 0.843, blue: 0.0)) // Gold color for star
                    }
                }
                .padding(.horizontal)

                Text("Boende")
                    .font(.headline)
                    .padding(.horizontal)

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Stad:")
                        Spacer()
                        Text(home.city)
                    }
                    HStack {
                        Text("Sovplatser:")
                        Spacer()
                        Text("\(home.beds)")
                    }
                    HStack {
                        Text("Antal rum:")
                        Spacer()
                        Text("\(home.rooms)")
                    }
                    HStack {
                        Text("Storlek:")
                        Spacer()
                        Text("\(home.size) kvm2")
                    }
                    HStack {
                        Text("Tillgänglighet:")
                        Spacer()
                        if let startDate = home.startDate, let endDate = home.endDate {
                            Text("\(formatDate(startDate)) - \(formatDate(endDate))")
                        } else {
                            Text("N/A")
                        }
                    }
                    HStack(alignment: .top) {
                        Text("Info om boendet:")
                        Spacer()
                        Text(home.additionalInfoHome)
                            .frame(width: UIScreen.main.bounds.width * 0.5)
                    }
                }
                .padding(.horizontal)
                .foregroundColor(.black)

                Text("Animals")
                    .font(.headline)
                    .padding(.horizontal)

                VStack(alignment: .leading, spacing: 16) {
                    ForEach(home.animals.keys.sorted(), id: \.self) { key in
                        if let animalInfo = home.animals[key] {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Typ:")
                                    Spacer()
                                    Text(animalInfo.type)
                                }
                                HStack {
                                    Text("Ålder:")
                                    Spacer()
                                    Text("\(animalInfo.age)")
                                }
                                HStack(alignment: .top) {
                                    Text("Info om djuret:")
                                    Spacer()
                                    Text(animalInfo.additionalInfoAnimal)
                                        .frame(width: UIScreen.main.bounds.width * 0.5)
                                }
                            }
                            .padding(.horizontal)
                            .foregroundColor(.black)
                        }
                    }
                }

                Text("Mer info")
                    .font(.headline)
                    .padding(.horizontal)

                Text(home.additionalInfoHome)
                    .padding(.horizontal)
                    .foregroundColor(.black)

                Spacer()
            }
        }
        .navigationTitle(home.city)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

#Preview {
    ExploreDetailsView(home: Home(
        id: "example_home_id",
        userID: "example_user_id",
        name: "Fransk bulldog i villa",
        beds: 2,
        rooms: 3,
        size: 100,
        animals: [
            "Hund": AnimalInfo(type: "Bulldog", age: 2, additionalInfoAnimal: "Friendly dog loves to cuddle"),
            "Katt": AnimalInfo(type: "Persian", age: 3, additionalInfoAnimal: "Loves to cuddle")
        ],
        additionalInfoHome: "Additional information about the home.",
        city: "Göteborg",
        availability: 28,
        startDate: Date(),
        endDate: Date().addingTimeInterval(86400 * 7), // 1 week later
        images: [
            "image1": URL(string: "https://firebasestorage.googleapis.com/v0/b/petbnb-267ff.appspot.com/o/placeholder_home.png?alt=media&token=0e13552e-0052-4bd2-9170-856beacea3b1")!,
            "image2": URL(string: "https://firebasestorage.googleapis.com/v0/b/petbnb-267ff.appspot.com/o/placeholder_home2.png?alt=media&token=a2c1ea5a-134a-466d-be39-19aedfa13e9a")!
        ],
        rating: 4.8
    ))
}
