import SwiftUI

struct HomeHeaderView: View {
    var home: Home
    
    var body: some View {
        HStack {
            Text(home.name)
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            HStack(spacing: 2) {
                Text(String(format: "%.1f", home.rating))
                    .font(.headline)
                Image(systemName: "star.fill")
                    .foregroundColor(Color(red: 1.0, green: 0.843, blue: 0.0))
            }
        }
        .padding(.horizontal)
    }
}
