//
//  AnimalSectionView.swift
//  PetBnB
//
//  Created by Ina Burström on 2024-05-21.
//

import SwiftUI

struct AnimalSectionView: View {
    let index: Int
    @Binding var animalInfo: AnimalInfo
    var isLast: Bool
    var addAnimalAction: () -> Void
    var removeAnimalAction: () -> Void

    var body: some View {
        Section(header: HStack {
            Text("Djur \(index + 1)")
            Spacer()
            Button(action: removeAnimalAction) {
                Image(systemName: "trash")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }) {
            HStack {
                Text("Typ:")
                TextField("Fyll i här (ex. hund)", text: $animalInfo.type)
            }
            HStack {
                Text("Ålder:")
                TextField("Fyll i här", value: $animalInfo.age, formatter: NumberFormatter())
            }
            HStack {
                Text("Övrig info:")
                TextField("Fyll i här", text: $animalInfo.additionalInfoAnimal)
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
