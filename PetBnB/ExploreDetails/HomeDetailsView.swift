import SwiftUI

struct HomeDetailsView: View {
    var home: Home
    
    var body: some View {
        Section(header: Text("Boende")) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Stad")
                    Spacer()
                    Text(home.city)
                }
                HStack {
                    Text("Sovplatser")
                    Spacer()
                    Text("\(home.beds)")
                }
                HStack {
                    Text("Antal rum")
                    Spacer()
                    Text("\(home.rooms)")
                }
                HStack {
                    Text("Storlek")
                    Spacer()
                    Text("\(home.size, specifier: "%.0f") m")
                                    + Text("2").font(.system(size: 12)).baselineOffset(6)
                            }               
            
                VStack(alignment: .leading, spacing: 4) {
                    if let startDate = home.startDate, let endDate = home.endDate {
                        HStack {
                            Text("Tillgänglighet")
                            Spacer()
                            Text(formatDate(startDate))
                        }
                        HStack {
                            Spacer()
                            Text(formatDate(endDate))
                        }
                    } else {
                        HStack {
                            Text("N/A")
                            Spacer()
                        }
                    }
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Info om boendet")
                    Text(home.additionalInfoHome)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding(.horizontal)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
