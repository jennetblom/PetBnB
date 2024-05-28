//
//  HomeGuestView.swift
//  PetBnB
//
//  Created by Jennet on 2024-05-23.
//

import Foundation
import SwiftUI

struct HomeGuestView : View {
    var body: some View {
        VStack{
            ScrollView {
                AboutMeGuestView()
                    .padding(.vertical)
                GuestAnimalExperienceView()
            }
        }
    }
}
struct AboutMeGuestView : View {
    
    @EnvironmentObject var viewModel: ProfileViewModel
    
    var ages = Array(0...100)
    
    var body: some View {
        VStack{
            HStack{
                Text("Om mig")
                    .fontWeight(.bold)
                    .padding(.horizontal)
                Spacer()
            }
            
            RowView(title: "Ålder") {
                Picker("Välj ålder", selection: $viewModel.userAge){
                    ForEach(ages, id: \.self) { age in
                        Text("\(age)").tag(age)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .accentColor(.gray)
            }.padding(.horizontal, 10)
            
            InfoRowView(title: "Berätta lite om dig själv") {
                TextEditor(text: $viewModel.userInfo)
                        .scrollContentBackground(.hidden)
                        .frame(height: 70)
                        .padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2))
                        .multilineTextAlignment(.leading)
                        .offset(x: 8, y: -30)

            }.padding(.horizontal, 10)
        }
    }
}
struct GuestAnimalExperienceView : View {
    
    @EnvironmentObject var viewModel: ProfileViewModel
    
    var animals = ["Hund", "Katt", "Fågel", "Fisk", "Reptil", "Pälsdjur"]
    
    var body: some View {
        VStack{
            HStack{
                Text("Djurerfarenhet")
                    .fontWeight(.bold)
                    .padding(.horizontal)
                Spacer()
            }
            RowView(title: "Typ av djur") {
                Picker("Välj djur", selection: $viewModel.animalExperienceType){
                    ForEach(animals, id: \.self) { animal in
                        Text(animal).tag(animal)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .accentColor(.gray)
            }.padding(.horizontal, 10)
            
            InfoRowView(title: "Vad har du för erfarenhet av djur?") {
                TextEditor(text: $viewModel.animalExperienceInfo)
                    .scrollContentBackground(.hidden)
                    .frame(height: 70)
                    .padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2))
                    .multilineTextAlignment(.leading)
                    .offset(x: 8, y: -30)
            }.padding(.horizontal, 10)
        }
    }
}
