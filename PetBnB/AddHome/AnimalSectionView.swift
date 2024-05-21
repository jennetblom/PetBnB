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
    @Binding var animalAge: String
    @Binding var animalInfo: String
    var isLast: Bool
    var addAnimalAction: () -> Void

    var body: some View {
        Section(header: Text("Djur \(index + 1)")) {
            HStack {
                Text("Typ:")
                TextField("Typ", text: $animalType)
            }
            HStack {
                Text("Ålder:")
                TextField("Ålder", text: $animalAge)
            }
            HStack {
                Text("Övrig info:")
                TextField("Övrig info", text: $animalInfo)
            }

            if isLast {
                Button(action: addAnimalAction) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Lägg till djur")
                    }
                }
            }
        }
    }
}
