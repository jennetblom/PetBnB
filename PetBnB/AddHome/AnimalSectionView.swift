//
//  AnimalSectionView.swift
//  PetBnB
//
//  Created by Ina Burström on 2024-05-21.
//

import SwiftUI

struct AnimalSectionView: View {
    let index: Int
    @Binding var animalType: String
    @Binding var animalAge: Int
    @Binding var animalInfo: String
    var isLast: Bool
    var addAnimalAction: () -> Void

    var body: some View {
        Section(header: Text("Djur \(index + 1)")) {
            HStack {
                Text("Typ:")
                TextField("Fyll i här (ex. hund)", text: $animalType)
            }
            HStack {
                Text("Ålder:")
                TextField("Fyll i här", value: $animalAge, formatter: NumberFormatter())
            }
            HStack {
                Text("Övrig info:")
                TextField("Fyll i här", text: $animalInfo)
            }

            if isLast {
                Button(action: addAnimalAction) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Lägg till djur")
                            .foregroundStyle(Color("secondary"))
                    }
                }
            }
        }
    }
}
