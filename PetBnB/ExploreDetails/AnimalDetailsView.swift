import SwiftUI

struct AnimalDetailsView: View {
    var home: Home
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(home.animals.keys.sorted(), id: \.self) { key in
                if let animalInfo = home.animals[key] {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Djur")
                            .font(.headline)
                    
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
                        HStack(alignment: .top) {
                            Text("Info om djuret")
                            Spacer()
                            Text(animalInfo.additionalInfoAnimal)
                                .frame(width: UIScreen.main.bounds.width * 0.5)
                        }
                    }
                    .foregroundColor(.black)
                }
            }
        }
        .padding(.horizontal)
    }
}
