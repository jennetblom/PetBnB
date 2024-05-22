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
    @State private var selectedImages: [UIImage] = []
    @State private var isShowingImagePicker = false

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(selectedImages, id: \.self) { image in
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 200, height: 200)
                                    .clipped()
                                    .cornerRadius(10)
                                    .padding(.trailing, 10)
                            }
                            Button(action: {
                                isShowingImagePicker = true
                            }) {
                                ZStack {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 200, height: 200)
                                        .cornerRadius(10)
                                    
                                    VStack {
                                        Image(systemName: "photo.on.rectangle")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                        Text("Lägg till bilder")
                                            .font(.headline)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                    }
                    .frame(height: 200)
                    
                    HomeSectionView(beds: $beds, rooms: $rooms, city: $city, additionalInfo: $additionalInfo)

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
                
                Spacer()
                
            }
            .navigationTitle("Lägg till boende")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(selectedImages: $selectedImages)
            }
        }
    }

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
