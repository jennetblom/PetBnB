import SwiftUI

struct HomeInformationView: View {
    var city: String
    var name: String
    var roomsBeds: String
    var availability: String
    var rating: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                VStack(alignment: .leading) {
                    Text(city)
                        .font(.headline)
                        .foregroundColor(Color("text"))
                    Text(name)
                        .font(.subheadline)
                        .foregroundColor(Color("text"))
                    Text(roomsBeds)
                        .font(.subheadline)
                        .foregroundColor(Color("text"))
                        .opacity(0.8)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(availability)
                        .font(.headline)
                        .foregroundColor(Color("text"))
                    HStack(spacing: 2) {
                        Text(String(format: "%.1f", rating))
                            .font(.subheadline)
                            .foregroundColor(Color("text"))
                        Image(systemName: "star.fill")
                            .font(.subheadline)
                            .foregroundColor(Color(red: 1.0, green: 0.843, blue: 0.0))
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
    }
}
