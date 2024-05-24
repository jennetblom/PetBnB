import SwiftUI

struct AddHomeView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = AddHomeViewModel()
    @State private var isSaving: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                if isSaving {
                    ProgressView("Sparar...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    Form {
                        ImagePickerView(selectedImages: $viewModel.selectedImages, isShowingImagePicker: $viewModel.isShowingImagePicker)
                        
                        HomeSectionView(beds: $viewModel.beds, rooms: $viewModel.rooms, city: $viewModel.city, additionalInfo: $viewModel.additionalInfo, homeTitle: $viewModel.homeTitle)
                        
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
                    Button(action: saveHome) {
                        Text("Spara")
                            .foregroundColor(Color("secondary"))
                    }
                }
            }
            .sheet(isPresented: $viewModel.isShowingImagePicker) {
                ImagePicker(selectedImages: $viewModel.selectedImages)
            }
            .alert(isPresented: $showError) {
                            Alert(title: Text("Fel"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                        }
        }
    }
    private func saveHome() {
        isSaving = true
        viewModel.saveHome { result in
            isSaving = false
            switch result {
            case .success:
                presentationMode.wrappedValue.dismiss()
            case .failure(let error):
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }
}
#Preview {
    AddHomeView()
}
