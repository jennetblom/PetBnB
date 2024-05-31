import SwiftUI

struct AnimalDetailsView: View {
    var home: Home
    @State private var showFullInfo = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text(animalSummary())
                    .font(.subheadline)
                    .foregroundColor(Color("text"))
                    .padding(.horizontal)
                
                Button(action: {
                    showFullInfo.toggle()
                }) {
                    Text("Visa mer")
                        .font(.subheadline)
                        .foregroundColor(Color("text"))
                        .underline()
                    + Text(" >")
                        .font(.subheadline)
                        .foregroundColor(Color("text"))
                }
                .padding(.horizontal)
                .sheet(isPresented: $showFullInfo) {
                    AnimalFullInfoView(home: home)
                }
            }
            
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(.gray)
                .padding(.horizontal, 17)
        }
        .padding(.top)
    }
    
    private func animalSummary() -> String {
        var animalCounts: [String: Int] = [:]
        
        for animal in home.animals.values {
            animalCounts[animal.type, default: 0] += 1
        }
        
        let descriptions = animalCounts.map { "\($0.value) \($0.key.lowercased())\($0.value > 1 ? pluralForm(for: $0.key) : "")" }
        
        if descriptions.count > 2 {
            let allButLast = descriptions.dropLast().joined(separator: ", ")
            let last = descriptions.last!
            return "Boendet har " + allButLast + " och " + last + "."
        } else {
            return "Boendet har " + descriptions.joined(separator: " och ") + "."
        }
    }
    
    private func pluralForm(for type: String) -> String {
        switch type.lowercased() {
        case "hund":
            return "ar"
        case "fisk":
            return "ar"
        case "reptil":
            return "er"
        case "pälsdjur":
            return ""
        case "katt":
            return "er"
        case "fågel":
            return "ar"
        default:
            return ""
        }
    }
}

struct AnimalFullInfoView: View {
    var home: Home
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.subheadline)
                            .foregroundColor(Color("text"))
                    }
                    Spacer()
                    Text("Djur Information")
                        .font(.subheadline)
                        .padding()
                    Spacer()
                }
                .padding([.leading, .top])
                
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 0)
                
                ScrollView {
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
                                .padding(.horizontal)
                                .padding(.vertical, 4)
                                
                                Rectangle()
                                    .frame(height: 0.5)
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 17)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .navigationBarHidden(true)
        }
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
                "Hund": AnimalInfo(type: "Hund", age: 2, additionalInfoAnimal: "Friendly dog loves to cuddle"),
                "Katt": AnimalInfo(type: "Katt", age: 3, additionalInfoAnimal: "Loves to cuddle"),
                "Reptil": AnimalInfo(type: "Reptil", age: 1, additionalInfoAnimal: "Interesting reptile"),
                "Reptil2": AnimalInfo(type: "Reptil", age: 2, additionalInfoAnimal: "Another interesting reptile")
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
