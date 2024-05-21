//
//  HomeSectionView.swift
//  PetBnB
//
//  Created by Ina Burström on 2024-05-21.
//

struct HomeSectionView: View {
    @Binding var beds: String
    @Binding var rooms: String
    @Binding var city: String
    @Binding var additionalInfo: String

    var body: some View {
        Section(header: Text("Boende")) {
            HStack {
                Text("Sovplatser:")
                TextField("Sovplatser", text: $beds)
            }
            HStack {
                Text("Antal rum:")
                TextField("Antal rum", text: $rooms)
            }
            HStack {
                Text("Stad:")
                TextField("Stad", text: $city)
            }
            HStack {
                Text("Övrig info:")
                TextField("Övrig info", text: $additionalInfo)
            }
        }
    }
}
