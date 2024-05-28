
import Foundation
import SwiftUI

struct HomeOwnerView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    @Binding var hasChanges: Bool
    @Binding var isLoading: Bool
    @Binding var ignoreChanges: Bool

    var body: some View {
        VStack {
            ScrollView {
                HousingInfoView(hasChanges: $hasChanges, isLoading: $isLoading, ignoreChanges: $ignoreChanges)
                animalInfoList
            }
        }
    }

    private var animalInfoList: some View {
        ForEach(0..<viewModel.animalCount, id: \.self) { index in
            AnimalInfoViewWrapper(index: index)
        }
    }

    private func AnimalInfoViewWrapper(index: Int) -> some View {
        AnimalInfoView(
            index: index,
            animalType: $viewModel.animalType[index],
            animalAge: $viewModel.animalAge[index],
            animalInfo: $viewModel.animalInfo[index],
            isLast: index == viewModel.animalCount - 1,
            addAnimalAction: viewModel.addAnimal,
            hasChanges: $hasChanges,
            ignoreChanges: $ignoreChanges
        )
    }
}

struct HousingInfoView: View {
    @EnvironmentObject var viewModel: ProfileViewModel

    var cities = ["Stockholm", "Göteborg", "Malmö", "Uppsala", "Jönköping", "Linköping", "Örebro", "Helsingborg"]
    var beds = Array(0...10)
    var rooms = Array(0...10)

    @Binding var hasChanges: Bool
    @Binding var isLoading: Bool
    @Binding var ignoreChanges: Bool

    var body: some View {
        VStack {
            HStack {
                Text("Boende")
                    .padding(.horizontal)
                    .fontWeight(.bold)
                Spacer()
            }

            RowView(title: "Stad") {
                Picker("Välj stad", selection: $viewModel.city) {
                    ForEach(cities, id: \.self) { city in
                        Text(city).tag(city)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .accentColor(.gray)
                .onChange(of: viewModel.city) {
                    if !ignoreChanges {
                        hasChanges = true
                    }
                }
            }
            .padding(.horizontal, 10)

            RowView(title: "Sovplatser") {
                Picker("Välj sovplatser", selection: $viewModel.numberOfBeds) {
                    ForEach(beds, id: \.self) { bed in
                        Text("\(bed)").tag(bed)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .accentColor(.gray)
                .onChange(of: viewModel.numberOfBeds) {
                    if !ignoreChanges {
                        hasChanges = true
                    }
                }
            }
            .padding(.horizontal, 10)

            RowView(title: "Antal rum") {
                Picker("Välj antal rum", selection: $viewModel.numberOfRooms) {
                    ForEach(rooms, id: \.self) { room in
                        Text("\(room)").tag(room)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .accentColor(.gray)
                .onChange(of: viewModel.numberOfRooms) {
                    if !ignoreChanges {
                        hasChanges = true
                    }
                }
            }
            .padding(.horizontal, 10)

            InfoRowView(title: "Info om boendet") {
                TextEditor(text: $viewModel.homeInfo)
                    .scrollContentBackground(.hidden)
                    .frame(height: 70)
                    .padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2))
                    .multilineTextAlignment(.leading)
                    .offset(x: 8, y: -30)
                    .onChange(of: viewModel.homeInfo) {
                        if !ignoreChanges {
                            hasChanges = true
                        }
                    }
            }
            .padding(.horizontal, 10)
        }
        .padding(.vertical)
    }
}

struct AnimalInfoView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    var animals = ["Hund", "Katt", "Fågel", "Fisk", "Reptil", "Pälsdjur"]
    var ages = Array(0...100)
    var index: Int
    @Binding var animalType: String
    @Binding var animalAge: Int
    @Binding var animalInfo: String
    var isLast: Bool
    var addAnimalAction: () -> Void
    @Binding var hasChanges: Bool
    @Binding var ignoreChanges: Bool

    var body: some View {
        VStack {
            HStack {
                Text("Djur")
                    .padding(.horizontal)
                    .fontWeight(.bold)
                Spacer()
            }
            RowView(title: "Typ av djur") {
                Picker("Välj djur", selection: $animalType) {
                    ForEach(animals, id: \.self) { animal in
                        Text(animal).tag(animal)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .accentColor(.gray)
                .onChange(of: animalType) {
                    if !ignoreChanges {
                        hasChanges = true
                    }
                }
            }.padding(.horizontal, 10)

            RowView(title: "Ålder") {
                Picker("Välj ålder", selection: $animalAge) {
                    ForEach(ages, id: \.self) { age in
                        Text("\(age)").tag(age)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .accentColor(.gray)
                .onChange(of: animalAge) {
                    if !ignoreChanges {
                        hasChanges = true
                    }
                }
            }.padding(.horizontal, 10)

            InfoRowView(title: "Info om djur") {
                TextEditor(text: $animalInfo)
                    .scrollContentBackground(.hidden)
                    .frame(height: 70)
                    .padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2))
                    .multilineTextAlignment(.leading)
                    .offset(x: 8, y: -30)
                    .onChange(of: animalInfo) {
                        if !ignoreChanges {
                            hasChanges = true
                        }
                    }
            }.padding(.horizontal, 10)

            if isLast {
                Button(action: addAnimalAction) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Lägg till djur")
                            .foregroundStyle(Color("secondary"))
                    }
                }
            }
        }
    }
}
