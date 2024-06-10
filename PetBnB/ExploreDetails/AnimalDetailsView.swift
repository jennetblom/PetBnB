import SwiftUI

struct AnimalDetailsView: View {
    var home: Home
    @State private var showFullInfo = false
    @StateObject private var viewModel = ExploreDetailsViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.animalSummary(for: home))
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
                    AnimalFullInfoView(home: home, viewModel: viewModel)
                }
            }
            
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(.gray)
                .padding(.horizontal, 17)
        }
        .padding(.top)
    }
}

struct AnimalFullInfoView: View {
    var home: Home
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ExploreDetailsViewModel
    
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
                    Text("Information om djur")
                        .font(.body)
                        .bold()
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
                                    
                                    
                                    Text(viewModel.randomAnimalSentence(for: animalInfo))
                                        .font(.subheadline)
                                        .foregroundColor(Color("text"))
                                    
                                    Text(animalInfo.additionalInfoAnimal)
                                        .font(.subheadline)
                                        .foregroundColor(Color("text"))
                                        .padding(.bottom)
                                        .padding(.top)
                                    
                                    Rectangle()
                                        .frame(height: 0.5)
                                        .foregroundColor(.gray)
                                        .padding(.vertical, 4)
                                }
                                .padding(.horizontal)
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
                "Hund": AnimalInfo(type: "Hund", age: 2, additionalInfoAnimal: "Vänlig hund som är väldigt mysig"),
                "Katt": AnimalInfo(type: "Katt", age: 3, additionalInfoAnimal: "Älskar att leka"),
                "Reptil": AnimalInfo(type: "Reptil", age: 1, additionalInfoAnimal: "En nyfiken reptil"),
                "Reptil2": AnimalInfo(type: "Reptil", age: 2, additionalInfoAnimal: "En till nyfiken reptil.")
            ],
            additionalInfoHome: "Ytterliggare information.",
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
