import SwiftUI

struct AddHomeView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = AddHomeViewModel()
    @State private var isSaving: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var showMapView: Bool = false
    
    var body: some View {
            ZStack {
                VStack {
                    if isSaving {
                        ProgressView("Sparar...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                    } else {
                        Form {
                            ImagePickerView(selectedImages: $viewModel.selectedImages, isShowingImagePicker: $viewModel.isShowingImagePicker)
                            
                            HomeSectionView(beds: $viewModel.beds,
                                            rooms: $viewModel.rooms,
                                            city: $viewModel.city,
                                            additionalInfo: $viewModel.additionalInfo,
                                            homeTitle: $viewModel.homeTitle,
                                            startDate: $viewModel.startDate,
                                            endDate: $viewModel.endDate,
                                            showMapView: $showMapView)
                                .onChange(of: viewModel.city) { newCity in
                                    viewModel.mapViewModel.city = newCity
                                }
                            
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
                            }
                        }
                        Spacer()
                    }
                }
                .navigationTitle("Lägg till boende")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    leading: Button("Tillbaka") {
                        presentationMode.wrappedValue.dismiss()
                    },
                    trailing: Button(action: saveHome) {
                        Text("Spara")
                            .foregroundColor(Color("secondary"))
                    }
                )
                .sheet(isPresented: $viewModel.isShowingImagePicker) {
                    ImagePicker(selectedImages: $viewModel.selectedImages)
                }
                .alert(isPresented: $showError) {
                    Alert(title: Text("Fel"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                }
                .onAppear {
                    viewModel.fetchAndUpdateUser()
                }
                
                if showMapView {
                    MapNavigationView(viewModel: viewModel.mapViewModel, dismissAction: { showMapView = false })
                    
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddHomeView()
        }
    }
}

struct MapNavigationView: View {
    @ObservedObject var viewModel: MapViewModel
    var dismissAction: () -> Void
    
    var body: some View {
            NavigationView {
                MapView(viewModel: viewModel)
                    .navigationTitle("Karta")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarHidden(true) // Dölj navigeringsfältet
            }
            .navigationViewStyle(StackNavigationViewStyle()) // Använd StackNavigationViewStyle
        }
    }
