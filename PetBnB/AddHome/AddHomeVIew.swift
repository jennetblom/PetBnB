
import SwiftUI

import SwiftUI

struct AddHomeView: View {
    @State private var beds: String = "hämta från fb"
    @State private var rooms: String = ""
    @State private var city: String = ""
    @State private var additionalInfo: String = ""
    @State private var animalCount = 1
    @State private var animalType: [String] = [""]
    @State private var animalAge: [String] = [""]
    @State private var animalInfo: [String] = [""]
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    //Homes section
                    HomeSectionView(beds: $beds, rooms: $rooms, city: $city, additionalInfo: $additionalInfo)
                    
                    // Animal section
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
                    // Get info from profile
                }
            }
            .navigationTitle("Lägg till boende")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // Add a new animal
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
