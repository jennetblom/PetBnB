import SwiftUI

struct HomeHeaderView: View {
    var home: Home
    var userName: String?
    var userRating: Double?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(home.name)
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                if let userRating = userRating {
                    HStack(spacing: 2) {
                        Text(String(format: "%.1f", userRating))
                            .font(.headline)
                        Image(systemName: "star.fill")
                            .foregroundColor(Color(red: 1.0, green: 0.843, blue: 0.0))
                    }
                }
            }
            
            if let userName = userName {
                Text(userName)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal)
    }
}
