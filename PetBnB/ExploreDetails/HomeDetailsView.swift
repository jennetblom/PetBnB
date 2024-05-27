import SwiftUI

struct HomeDetailsView: View {
    var home: Home
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Boende")
                .font(.headline)
            HStack {
                Text("Stad:")
                Spacer()
                Text(home.city)
            }
            HStack {
                Text("Sovplatser:")
                Spacer()
                Text("\(home.beds)")
            }
            HStack {
                Text("Antal rum:")
                Spacer()
                Text("\(home.rooms)")
            }
            HStack {
                Text("Storlek:")
                Spacer()
                Text("\(home.size) kvm2")
            }
            HStack {
                Text("Tillgänglighet:")
                Spacer()
                if let startDate = home.startDate, let endDate = home.endDate {
                    Text("\(formatDate(startDate)) - \(formatDate(endDate))")
                } else {
                    Text("N/A")
                }
            }
            HStack(alignment: .top) {
                Text("Info om boendet:")
                Spacer()
                Text(home.additionalInfoHome)
                    .frame(width: UIScreen.main.bounds.width * 0.5)
            }
        }
        .padding(.horizontal)
        .foregroundColor(.black)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
