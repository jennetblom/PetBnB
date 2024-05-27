import SwiftUI

struct AddHomeView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = AddHomeViewModel()
    @State private var isSaving: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""

    var body: some View {
            VStack {
                if isSaving {
                    ProgressView("Sparar...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    Form {
                        ImagePickerView(selectedImages: $viewModel.selectedImages, isShowingImagePicker: $viewModel.isShowingImagePicker)
                        
                        HomeSectionView(beds: $viewModel.beds, rooms: $viewModel.rooms, city: $viewModel.city, additionalInfo: $viewModel.additionalInfo, homeTitle: $viewModel.homeTitle, startDate: $viewModel.startDate, endDate: $viewModel.endDate)
                        
                        ForEach(viewModel.animals.indices, id: \.self) { index in
                            AnimalSectionView(
                                index: index,
                                animalInfo: $viewModel.animals[index],
                                isLast: index == viewModel.animals.count - 1,
                                addAnimalAction: viewModel.addAnimal,
                                removeAnimalAction: {
                                    viewModel.removeAnimal(at: index)
                                }
                            )
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
            })
            .sheet(isPresented: $viewModel.isShowingImagePicker) {
                ImagePicker(selectedImages: $viewModel.selectedImages)
            }
            .alert(isPresented: $showError) {
                Alert(title: Text("Fel"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
            .onAppear {
                viewModel.fetchAndUpdateUser()
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
