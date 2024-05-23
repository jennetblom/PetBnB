//
//  HomeSectionView.swift
//  PetBnB
//
//  Created by Ina Burström on 2024-05-21.
//
import SwiftUI

struct HomeSectionView: View {
    @Binding var beds: Int
    @Binding var rooms: Int
    @Binding var city: String
    @Binding var additionalInfo: String
    @Binding var homeTitle: String
    let limit = 20
    @State private var fromDate = Date()
    @State private var toDate = Date()
    
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
                TextField("Sovplatser", value: $beds, formatter: NumberFormatter())
            }
            HStack {
                Text("Antal rum:")
                TextField("Antal rum", value: $rooms, formatter: NumberFormatter())
            }
            HStack {
                Text("Stad:")
                TextField("Stad", text: $city)
            }
            HStack {
                Text("Övrig info:")
                TextField("Övrig info", text: $additionalInfo)
            }
            
            HStack{
                            Text("Tillgängligt från:")
                            DatePicker(
                                "",
                                selection: $fromDate,
                                in: Date()...,
                                displayedComponents: [.date])
                        }
                        HStack{
                            Text("Tillgängligt till:")
                            DatePicker(
                                "",
                                selection: $toDate,
                                in: fromDate...,
                                displayedComponents: [.date])
                        }
        }
    }
}
