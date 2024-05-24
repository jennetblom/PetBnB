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
                    Text(name)
                        .font(.subheadline)
                    Text(roomsBeds)
                        .font(.subheadline)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(availability)
                        .font(.headline)
                    HStack(spacing: 2) {
                        Text(String(format: "%.1f", rating))
                            .font(.subheadline)
                        Image(systemName: "star.fill")
                            .font(.subheadline)
                            .foregroundColor(Color("details"))
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
    }
}
