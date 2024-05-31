import SwiftUI

struct AnimalDetailsView: View {
    var home: Home
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Section(header: Text("Djur")
                        .font(.title)
                        .padding(.horizontal)) {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(home.animals.keys.sorted(), id: \.self) { key in
                        if let animalInfo = home.animals[key] {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Typ")
                                        .font(.subheadline)
                                        .foregroundColor(Color("text"))
                                    Spacer()
                                    Text(animalInfo.type)
                                        .font(.subheadline)
                                        .foregroundColor(Color("text"))
                                }
                                
                                HStack {
                                    Text("Ålder")
                                        .font(.subheadline)
                                        .foregroundColor(Color("text"))
                                    Spacer()
                                    Text("\(animalInfo.age)")
                                        .font(.subheadline)
                                        .foregroundColor(Color("text"))
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Info om djuret")
                                        .font(.subheadline)
                                        .foregroundColor(Color("text"))
                                    Text(animalInfo.additionalInfoAnimal)
                                        .font(.subheadline)
                                        .foregroundColor(Color("text"))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(.gray)
                .padding(.horizontal, 17)
        }
        .padding(.top)
    }
}

#Preview {
    AnimalDetailsView(
        home: Home(
            id: "tTCAOPeuRXAGLY2PXQTg",
            userID: "pdKIMskgwUTSTPeN15wkG5TbI3D2",
            name: "Fransk bulldog i villa",
            beds: 2,
            rooms: 3,
            size: 100,
            guests: 4,
            animals: [
                "Hund": AnimalInfo(type: "Bulldog", age: 2, additionalInfoAnimal: "Friendly dog loves to cuddle"),
                "Katt": AnimalInfo(type: "Persian", age: 3, additionalInfoAnimal: "Loves to cuddle")
            ],
            additionalInfoHome: "Additional information about the home.",
            city: "Göteborg",
            availability: 28,
            startDate: Date(),
            endDate: Date().addingTimeInterval(86400 * 7),
            images: [
                "image1": URL(string: "https://firebasestorage.googleapis.com/v0/b/petbnb-267ff.appspot.com/o/placeholder_home.png?alt=media&token=0e13552e-0052-4bd2-9170-856beacea3b1")!,
                "image2": URL(string: "https://firebasestorage.googleapis.com/v0/b/petbnb-267ff.appspot.com/o/placeholder_home2.png?alt=media&token=a2c1ea5a-134a-466d-be39-19aedfa13e9a")!
            ],
            rating: 4.8,
            country: "Sweden",
            bathrooms: 2,
            activities: "Fiska, vandra, cykla",
            guestAccess: "Hela stugan",
            otherNotes: "Husdjur tillåtna"
        )
    )
}
