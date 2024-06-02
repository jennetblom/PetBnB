import SwiftUI

struct HomeSectionView: View {
    @Binding var beds: Int
    @Binding var rooms: Int
    @Binding var city: String
    @Binding var additionalInfo: String
    @Binding var homeTitle: String
    @Binding var startDate: Date
    @Binding var endDate: Date

    @Binding var showMapView: Bool

    let limit = 20

    var body: some View {
        Section(header: Text("Rubrik")) {
            TextField("Fyll i din rubrik för boendet här", text: $homeTitle)
                .onChange(of: homeTitle) { newValue in
                    if newValue.count > limit {
                        homeTitle = String(newValue.prefix(limit))
                    }
                }
        }

        Section(header: Text("Boende")) {
            HStack {
                Text("Sovplatser:")
                TextField("Fyll i här", value: $beds, formatter: NumberFormatter())
            }
            HStack {
                Text("Antal rum:")
                TextField("Fyll i här", value: $rooms, formatter: NumberFormatter())
            }
            HStack {
                Text("Stad:")
                TextField("Fyll i här", text: $city)
                Image(systemName: "map")
                    .foregroundColor(Color("primary"))
                    .onTapGesture {
                        showMapView = true
                    }
            }
            HStack {
                Text("Övrig info:")
                TextField("Fyll i här", text: $additionalInfo)
            }

            HStack {
                Text("Tillgängligt från:")
                DatePicker(
                    "",
                    selection: $startDate,
                    in: Date()...,
                    displayedComponents: [.date]
                )
            }
            HStack {
                Text("Tillgängligt till:")
                DatePicker(
                    "",
                    selection: $endDate,
                    in: startDate...,
                    displayedComponents: [.date]
                )
            }
        }
    }
}
