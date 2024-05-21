
import SwiftUI

import SwiftUI

struct AddHomeView: View {
    @State private var beds: String = "hämta från fb"
    @State private var animalCount = 1
    @State private var animalType: [String] = [""]
    @State private var animalAge: [String] = [""]
    @State private var animalInfo: [String] = [""]

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(header: Text("Boende")) {
                        HStack {
                            Text("Sovplatser:")
                            TextField("Sovplatser", text: $beds)
                        }
                    }

                    // Djuravsnitt
                    ForEach(0..<animalCount, id: \.self) { index in
                        AnimalSectionView(
                            index: index,
                            animalType: $animalType[index],
                            animalAge: $animalAge[index],
                            animalInfo: $animalInfo[index],
                            isLast: index == animalCount - 1,
                            addAnimalAction: {
                                addAnimal()
                            }
                        )
                    }
                }
                .padding()
                .onAppear {
                    // Initieringslogik om nödvändigt
                }
            }
            .navigationTitle("Lägg till boende")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // Funktion för att lägga till ett nytt djur
    private func addAnimal() {
        animalCount += 1
        animalType.append("")
        animalAge.append("")
        animalInfo.append("")
    }
}

#Preview {
    AddHomeView()
}
