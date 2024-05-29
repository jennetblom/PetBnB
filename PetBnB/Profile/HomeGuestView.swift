import Foundation
import SwiftUI

struct HomeGuestView: View {
    @Binding var hasChanges: Bool
    @Binding var isLoading: Bool
    @Binding var ignoreChanges: Bool
    var isEditable: Bool

    var body: some View {
        VStack {
            ScrollView {
                AboutMeGuestView(hasChanges: $hasChanges, ignoreChanges: $ignoreChanges, isEditable: isEditable)
                    .padding(.vertical)
                GuestAnimalExperienceView(hasChanges: $hasChanges, ignoreChanges: $ignoreChanges, isEditable: isEditable)
            }
        }
    }
}

struct AboutMeGuestView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    @Binding var hasChanges: Bool
    @Binding var ignoreChanges: Bool
    var isEditable: Bool

    var ages = Array(0...100)

    var body: some View {
        VStack {
            HStack {
                Text("Om mig")
                    .fontWeight(.bold)
                    .padding(.horizontal)
                Spacer()
            }

            if isEditable {
                RowView(title: "Ålder") {
                    Picker("Välj ålder", selection: $viewModel.userAge) {
                        ForEach(ages, id: \.self) { age in
                            Text("\(age)").tag(age)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .accentColor(.gray)
                    .disabled(!isEditable)
                    .onChange(of: viewModel.userAge) {
                        if !ignoreChanges && isEditable {
                            hasChanges = true
                        }
                    }
                }.padding(.horizontal, 10)
            } else {
                RowView(title: "Ålder") {
                    Text("\(viewModel.userAge)")
                        .padding(.horizontal, 10)
                }
            }

            InfoRowView(title: isEditable ? "Berätta lite om dig själv" : "Info om uthyraren") {
                TextEditor(text: $viewModel.userInfo)
                    .scrollContentBackground(.hidden)
                    .frame(height: 70)
                    .padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2))
                    .multilineTextAlignment(.leading)
                    .offset(x: 8, y: -30)
                    .disabled(!isEditable)
                    .onChange(of: viewModel.userInfo) {
                        if !ignoreChanges && isEditable {
                            hasChanges = true
                        }
                    }
            }.padding(.horizontal, 10)
        }
    }
}

struct GuestAnimalExperienceView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    @Binding var hasChanges: Bool
    @Binding var ignoreChanges: Bool
    var isEditable: Bool

    var animals = ["Hund", "Katt", "Fågel", "Fisk", "Reptil", "Pälsdjur"]

    var body: some View {
        VStack {
            HStack {
                Text("Djurerfarenhet")
                    .fontWeight(.bold)
                    .padding(.horizontal)
                Spacer()
            }

            RowView(title: "Typ av djur") {
                if isEditable {
                    Picker("Välj djur", selection: $viewModel.animalExperienceType) {
                        ForEach(animals, id: \.self) { animal in
                            Text(animal).tag(animal)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .accentColor(.gray)
                    .disabled(!isEditable)
                    .onChange(of: viewModel.animalExperienceType) {
                        if !ignoreChanges && isEditable {
                            hasChanges = true
                        }
                    }
                } else {
                    Text(viewModel.animalExperienceType)
                        .padding(.horizontal, 10)
                }
            }.padding(.horizontal, 10)

            if !isEditable {
                            InfoRowView(title: "Någon mer? ") {
                                Text("text")
                                    .scrollContentBackground(.hidden)
                                    .frame(height: 70)
                                    .padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2))
                                    .multilineTextAlignment(.leading)
                                    .offset(x: 8, y: -30)
                                    .disabled(true)
                            }.padding(.horizontal, 10)
                        }
            
            InfoRowView(title: "Vad har du för erfarenhet av djur?") {
                TextEditor(text: $viewModel.animalExperienceInfo)
                    .scrollContentBackground(.hidden)
                    .frame(height: 70)
                    .padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2))
                    .multilineTextAlignment(.leading)
                    .offset(x: 8, y: -30)
                    .disabled(!isEditable)
                    .onChange(of: viewModel.animalExperienceInfo) {
                        if !ignoreChanges && isEditable {
                            hasChanges = true
                        }
                    }
            }.padding(.horizontal, 10)
        }
    }
}
