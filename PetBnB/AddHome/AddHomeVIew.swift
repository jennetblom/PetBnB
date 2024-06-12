import SwiftUI

struct AddHomeView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var tabViewModel: TabViewModel

    @StateObject private var viewModel = AddHomeViewModel()
    @State private var isSaving: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var shouldDismiss = true

    var body: some View {
        VStack {
            if isSaving {
                ProgressView("Sparar...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else {
                Form {
                    ImagePickerView(selectedImages: $viewModel.selectedImages, isShowingImagePicker: $viewModel.isShowingImagePicker)
                    
                    HomeSectionView(beds: $viewModel.beds, rooms: $viewModel.rooms, size: $viewModel.size, city: $viewModel.city, additionalInfoHome: $viewModel.additionalInfoHome, name: $viewModel.name, startDate: $viewModel.startDate, endDate: $viewModel.endDate, activities: $viewModel.activities, bathrooms: $viewModel.bathrooms, guests: $viewModel.guests, country: $viewModel.country, guestAccess: $viewModel.guestAccess, otherNotes: $viewModel.otherNotes, latitude: $viewModel.latitude, longitude: $viewModel.longitude, shouldDismiss: $shouldDismiss
)
                    
                    ForEach(viewModel.animals.indices, id: \.self) { index in
                        AnimalSectionView(
                            index: index,
                            animalInfo: $viewModel.animals[index],
                            isLast: index == viewModel.animals.count - 1,
                            addAnimalAction: viewModel.addAnimal,
                            removeAnimalAction: {
                                viewModel.removeAnimal(at: index)
                            },
                            hasMultipleAnimals: viewModel.animals.count > 1
                        )
                        .id(index)
                    }
                }
            }
            Spacer()
        }
        .navigationTitle("Lägg till boende")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing:
          Button(action: saveHome) {
            Text("Spara")
                .foregroundColor(Color("secondary"))
        }
            .disabled(!viewModel.canSave)
        )
        .sheet(isPresented: $viewModel.isShowingImagePicker) {
            ImagePicker(selectedImages: $viewModel.selectedImages)
        }
        .alert(isPresented: $showError) {
            Alert(title: Text("Fel"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            if !tabViewModel.returningFromMap {
                viewModel.fetchAndUpdateUser()
            } else {
            }
            tabViewModel.returningFromMap = false
        }
        .onDisappear {
            if !tabViewModel.isAddHomePresented {
                if shouldDismiss {
                    presentationMode.wrappedValue.dismiss()
                }
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
