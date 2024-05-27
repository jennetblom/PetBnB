import SwiftUI

struct HomeInformationView: View {
    var city: String
    var name: String
    var roomsBeds: String
    var availability: String

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
                    
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
    }
}
