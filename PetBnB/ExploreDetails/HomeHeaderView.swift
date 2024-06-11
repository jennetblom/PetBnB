import SwiftUI

struct HomeHeaderView: View {
    var home: Home
    var userName: String?
    var userRating: Double?
    var userAge: Int?
    var userInfo: String?
    var userJob: String?
    var profilePicture: Image?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(home.name ?? "No name")
                    .font(.title)
                
                Text("\(home.city ?? ""), \(home.country ?? "Sweden")")
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
                    
                    Text("\(home.bathrooms ?? 0) badrum")
                        .font(.subheadline)
                        .foregroundColor(Color("text"))
                }
            }
            .padding(.horizontal)
            
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(.gray)
                .padding(.horizontal, 17)
            
            if let userID = home.userID {
                NavigationLink(destination: ProfileView(userID: userID, isEditable: false)) {

                    HStack {
                        if let profilePicture = profilePicture {
                            profilePicture
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            if let userName = userName {
                                Text("\(userName) är din värd")
                                    .font(.subheadline)
                                    .bold()
                                    .foregroundColor(Color("text"))
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
                    .padding(.horizontal)
                    
                }
            }
        
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(.gray)
                .padding(.horizontal, 17)
            
        }
    }
}

