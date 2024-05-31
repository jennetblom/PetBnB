import SwiftUI
import FirebaseAuth

struct ExploreDetailsView: View {
    var home: Home
    @StateObject private var exploreDetailsViewModel = ExploreDetailsViewModel()
    @StateObject var chatViewModel = ChatViewModel()
    @State var conversationId: String?
    @State var isChatActive: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                ImageCarouselView(images: Array(home.images.values).sorted { $0.absoluteString < $1.absoluteString })
                    .frame(height: 300)
                
                Form {
                    HomeHeaderView(home: home,
                                   userName: exploreDetailsViewModel.user?.name,
                                   userRating: exploreDetailsViewModel.user?.rating,
                                   userAge: exploreDetailsViewModel.user?.userAge,
                                   userInfo: exploreDetailsViewModel.user?.userInfo)
                    
                    HomeDetailsView(home: home)
                    
                    AnimalDetailsView(home: home)
                    
                    AdditionalInfoView(home: home)
                }
            }
            MapButtonView()
        }
        .navigationTitle(exploreDetailsViewModel.user?.name ?? "Ingen användare")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let userID = home.userID {
                exploreDetailsViewModel.fetchUser(by: userID)
            }
        }
        .navigationBarItems(trailing: MessageButton(isChatActive: $isChatActive, conversationId: $conversationId, home: home, chatViewModel: chatViewModel))
    }
}

#Preview {
    ExploreDetailsView(home: Home(
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
        additionalInfoHome: "Mysig och idyllisk stuga/sommarstuga för en familj eller par som vill övernatta. Möjlighet att fiska i roddbåt finns vid uthyrning av stugan. Stäng av dina telefoner och njut av en trevlig vistelse och/eller helg med de människor du älskar.  Om det tas på de dagar du vill, skriv till mig. Jag har två stugor. Boendet Mysigt semesterhus 1 meter från stor sjö. Här kan du både bada och fiska Gästers tillgång Du har allt för dig själv. Andra saker att notera Mysigt och lugnt område",
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
    ))
}
