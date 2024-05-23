//
//  HomeOwnerView.swift
//  PetBnB
//
//  Created by Jennet on 2024-05-23.
//

import Foundation
import SwiftUI

struct HomeOwnerView : View {
    @EnvironmentObject var viewModel: ProfileViewModel
    
    var body: some View {
        VStack{
            ScrollView {
                HousingInfoView()
                AnimalInfoView()
            }
            //                Button("Spara") {
            //                    
            //                }.frame(width: 220, height: 40)
            //                    .background(Color("primary"))
            //                    .foregroundColor(.black)
            //                    .cornerRadius(10.0)
            //                    .padding()
            //            }
        }
    }
}
struct HousingInfoView : View {
    @EnvironmentObject var viewModel: ProfileViewModel
    
    var cities = ["Stockholm", "Göteborg", "Malmö", "Uppsala", "Jönköping", "Linköping", "Örebro", "Helsingborg"]
    var beds = Array(0...10)
    var rooms = Array(0...10)
    
    var body: some View {
            VStack{
                HStack{
                    Text("Boende")
                        .padding(.horizontal)
                        .fontWeight(.bold)
                    Spacer()
                }
                
                RowView(title: "Stad") {
                    Picker("Välj stad", selection: $viewModel.city){
                        ForEach(cities, id: \.self) { city in
                            Text(city).tag(city)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .accentColor(.gray)
                }.padding(.horizontal, 10)
                
                
                RowView(title: "Sovplatser") {
                    Picker("Välj sovplatser", selection: $viewModel.numberOfBeds) {
                        ForEach(beds, id: \.self) { bed in
                            Text("\(bed)").tag(bed)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .accentColor(.gray)
                }.padding(.horizontal,10)
                
                RowView(title: "Antal rum") {
                    Picker("Välj antal rum", selection: $viewModel.numberOfRooms) {
                        ForEach(rooms, id: \.self) { room in
                            Text("\(room)").tag(room)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .accentColor(.gray)
                }.padding(.horizontal,10)
                
                InfoRowView(title: "Info om boendet") {
                    TextEditor(text: $viewModel.housingInfo)
                            .scrollContentBackground(.hidden)
                            .frame(height: 70)
                            .padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2))
                            .multilineTextAlignment(.leading)
                            .offset(x: 8, y: -30)

                }.padding(.horizontal, 10)
               
            }.padding(.vertical)
        }
}
struct AnimalInfoView : View {
    
    @EnvironmentObject var viewModel: ProfileViewModel
    var animals = ["Hund", "Katt", "Fågel", "Fisk", "Reptil", "Pälsdjur"]
    var ages = Array(0...100)
    
    var body: some View {
        VStack{
            HStack{
                Text("Djur")
                    .padding(.horizontal)
                    .fontWeight(.bold)
                Spacer()
            }
            RowView(title: "Typ av djur") {
                Picker("Välj djur", selection: $viewModel.animalType){
                    ForEach(animals, id: \.self) { animal in
                        Text(animal).tag(animal)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .accentColor(.gray)
            }.padding(.horizontal, 10)
            
            RowView(title: "Ålder") {
                Picker("Välj ålder", selection: $viewModel.animalAge){
                    ForEach(ages, id: \.self) { age in
                        Text("\(age)").tag(age)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .accentColor(.gray)
            }.padding(.horizontal, 10)
            
            InfoRowView(title: "Info om djur") {
                TextEditor(text: $viewModel.animalInfo)
                        .scrollContentBackground(.hidden)
                        .frame(height: 70)
                        .padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2))
                        .multilineTextAlignment(.leading)
                        .offset(x: 8, y: -30)

            }.padding(.horizontal, 10)
        }
    }
}
