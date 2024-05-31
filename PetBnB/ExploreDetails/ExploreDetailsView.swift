import SwiftUI
import MapKit
import FirebaseAuth

struct ExploreDetailsView: View {
    var home: Home
    @StateObject private var exploreDetailsViewModel = ExploreDetailsViewModel()
    @StateObject var chatViewModel = ChatViewModel()
    @State var conversationId: String?
    @State var isChatActive: Bool = false
    
    @State private var showMapView = false
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
                    
                    AdditionalInfoView(additionalInfo: home.additionalInfoHome)
                }
                    Button(action: {
                        showMapView = true
                        
                    }) {
                        HStack {
                            Text("Kartor")
                            Image(systemName: "map")
                        }
                        .padding()
                        .background(Color("primary"))
                        .foregroundColor(Color("text"))
                        .cornerRadius(12)
                }
            }
            .navigationTitle(home.name) // ?? "Ingen användare")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if let userID = home.userID {
                    exploreDetailsViewModel.fetchUser(by: userID)
                }
            }
            .background(
                NavigationLink(
                    destination: MapShowView(viewModel: MapViewModel(city: home.city)),
                    isActive: $showMapView,
                    label: { EmptyView() }
                    
                )
            )
        }
        .navigationBarItems(trailing: MessageButton(isChatActive: $isChatActive, conversationId: $conversationId, home: home, chatViewModel: chatViewModel ))    }
}

//
//   #Preview {
//    ExploreDetailsView(home: Home(
//           id: "tTCAOPeuRXAGLY2PXQTg",
//       userID: "pdKIMskgwUTSTPeN15wkG5TbI3D2",
//        name: "Fransk bulldog i villa",
//        beds: 2,
//       rooms: 3,
//     size: 100,
//    animals: [
//          "Hund": AnimalInfo(type: "Bulldog", age: 2, additionalInfoAnimal: "Friendly dog loves to cuddle"),
//                "Katt": AnimalInfo(type: "Persian", age: 3, additionalInfoAnimal: "Loves to cuddle")
//              ],
//           additionalInfoHome: "Additional information about the home.",
//           city: "Göteborg",
//          latitude: 57.70887,
//          longitude: 11.97456,
//            availability: 28,
//          startDate: Date(),
//           endDate: Date().addingTimeInterval(86400 * 7),
//          images: [
//               "image1": URL(string: "https://firebasestorage.googleapis.com/v0/b/petbnb-267ff.appspot.com/o/placeholder_home.png?alt=media&token=0e13552e-0052-4bd2-9170-856beacea3b1")!,
//                "image2": URL(string: "https://firebasestorage.googleapis.com/v0/b/petbnb-267ff.appspot.com/o/placeholder_home2.png?alt=media&token=a2c1ea5a-134a-466d-be39-19aedfa13e9a")!
//             ],
//          rating: 4.8
//         ))
//     }
//
