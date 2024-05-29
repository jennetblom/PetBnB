import SwiftUI

struct HomeHeaderView: View {
    var home: Home
    var userName: String?
    var userRating: Double?
    var userAge: Int?
    var userInfo: String?
    
    var body: some View {
        Section(header: Text("Uthyrare")) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    if let userName = userName, let userID = home.userID {
                        NavigationLink(destination: ProfileView(userID: userID)) {
                            Text(userName)
                                .underline()
                                .foregroundColor(.blue)
                        }
                    }
                    Spacer()
                    if let userRating = userRating {
                        HStack(spacing: 2) {
                            Text(String(format: "%.1f", userRating))
                            Image(systemName: "star.fill")
                                .foregroundColor(Color(red: 1.0, green: 0.843, blue: 0.0))
                        }
                    }
                }
                
                if let userAge = userAge {
                    Text("Ålder: \(userAge)")
                }
                
                if let userInfo = userInfo {
                    Text(userInfo)
                }
            }
        }
        .padding(.horizontal)
    }
}
