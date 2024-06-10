import SwiftUI
import Firebase
import FirebaseAuth

    struct HomeHeaderView: View {
        var home: Home
        var userName: String?
        var userRating: Double?
        var userAge: Int?
        var userInfo: String?
        var userJob: String?
       var profilePictureUrl: URL?

        @EnvironmentObject var tabViewModel: TabViewModel
        @Environment(\.presentationMode) var presentationMode
        
        
       // var exploreDetailsViewModel: ExploreDetailsViewModel
        @State private var profileImage: Image? = Image("placeholder")
        @State private var isLoadingImage: Bool = false
        

        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(home.name)
                        .font(.title)
                    
                    Text("\(home.city), \(home.country)")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(Color("text"))
                    
                    HStack(spacing: 2) {
                        Text("\(home.guests) gäster")
                            .font(.subheadline)
                            .foregroundColor(Color("text"))
                        
                        Text("•")
                            .font(.subheadline)
                            .foregroundColor(Color("text"))
                        
                        Text("\(home.rooms) rum")
                            .font(.subheadline)
                            .foregroundColor(Color("text"))
                        
                        Text("•")
                            .font(.subheadline)
                            .foregroundColor(Color("text"))
                        
                        Text("\(home.beds) sängar")
                            .font(.subheadline)
                            .foregroundColor(Color("text"))
                        
                        Text("•")
                            .font(.subheadline)
                            .foregroundColor(Color("text"))
                        
                        Text("\(home.bathrooms) badrum")
                            .font(.subheadline)
                            .foregroundColor(Color("text"))
                    }
                }
                .padding(.horizontal)
                
               /* Rectangle()
                 .frame(height: 0.5)
                 .foregroundColor(.gray)
                 .padding(.horizontal, 17)*/
                
            
                HStack{
                    AsyncImage(url: profilePictureUrl) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .onAppear {
                                    loadImage()
                                }
                                .opacity(isLoadingImage ? 0 : 1)
                                .animation(.easeInOut)
                                .overlay(
                                    Group {
                                        if isLoadingImage {
                                            ProgressView()
                                        }
                                    }
                                )
                        case .failure(_):
                            Image("error_loading_image")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        case .empty:
                            ProgressView()
                        }
                    }
                    
                    
                    VStack(alignment: .leading, spacing: 4) {
                    NavigationLink(destination: ProfileView(userID: home.userID ?? "")) {
                        if let userName = userName {
                        Text("\(userName) är din värd")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(Color("text"))
                    }
            }
                        
                        if let userJob = userJob {
                            Text(userJob)
                                .font(.subheadline)
                                .foregroundColor(Color(white: 0.3))
                        }
                    }
                    
                    Spacer()
                    
                    if let userRating = userRating {
                        HStack(spacing: 2) {
                            Text(String(format: "%.1f", userRating))
                                .font(.subheadline)
                                .foregroundColor(Color("text"))
                            Image(systemName: "star.fill")
                                .foregroundColor(Color(red: 1.0, green: 0.843, blue: 0.0))
                        }
                    }
                    
                }
            }
                
       }
        
        private func loadImage() {
            isLoadingImage = true
            guard let url = profilePictureUrl else { return }
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let uiImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.profileImage = Image(uiImage: uiImage)
                        isLoadingImage = false
                    }
                }
            }.resume()
        }
    }

#Preview {
    HomeHeaderView(
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
        ),
        userName: "John Doe",
        userRating: 4.5,
        userAge: 30,
        userInfo: "Loves pets and has been a host for 5 years.",
       // userJob: "Software Engineer",
        profilePictureUrl: URL(string: "https://example.com/profile.png")
       //exploreDetailsViewModel: ExploreDetailsViewModel()
       //profileImage: Image("error_loading_image")
    )
    
}
