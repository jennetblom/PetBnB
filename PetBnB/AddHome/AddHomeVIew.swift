import SwiftUI

struct AddHomeView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = AddHomeViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    ImagePickerView(selectedImages: $viewModel.selectedImages, isShowingImagePicker: $viewModel.isShowingImagePicker)
                    
                    HomeSectionView(beds: $viewModel.beds, rooms: $viewModel.rooms, city: $viewModel.city, additionalInfo: $viewModel.additionalInfo)
                    
                    ForEach(0..<viewModel.animalCount, id: \.self) { index in
                        AnimalSectionView(
                            index: index,
                            animalType: $viewModel.animalType[index],
                            animalAge: $viewModel.animalAge[index],
                            animalInfo: $viewModel.animalInfo[index],
                            isLast: index == viewModel.animalCount - 1,
                            addAnimalAction: viewModel.addAnimal
                        )
                    }
                }
                
                Spacer()
                
            }
            .navigationTitle("Lägg till boende")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { // Adding custom back button
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(Color("secondary"))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        //save
                    }) {
                        Text("Spara")
                            .foregroundColor(Color("secondary"))
                    }
                }
            }
            .sheet(isPresented: $viewModel.isShowingImagePicker) {
                ImagePicker(selectedImages: $viewModel.selectedImages)
            }
        }
    }
}
#Preview {
    AddHomeView()
}
