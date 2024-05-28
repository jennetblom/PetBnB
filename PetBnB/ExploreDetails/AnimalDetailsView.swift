import SwiftUI

struct AnimalDetailsView: View {
    var home: Home
    
    var body: some View {
            Section(header: Text("Djur")) {
                VStack(alignment: .leading, spacing: 8) {
                ForEach(home.animals.keys.sorted(), id: \.self) { key in
                    if let animalInfo = home.animals[key] {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Typ")
                                Spacer()
                                Text(animalInfo.type)
                            }
                            HStack {
                                Text("Ålder")
                                Spacer()
                                Text("\(animalInfo.age)")
                            }
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Info om djuret")
                                Text(animalInfo.additionalInfoAnimal)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}
