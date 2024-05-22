import SwiftUI

struct ProfileView: View {
    @State private var selectedSegment = 0
    @State var rating = 4
    
    let segments = ["Uthyrare", "Hyresgäst"]
    
    var body: some View {
        VStack{
            Picker("Select View", selection: $selectedSegment) {
                ForEach(0..<segments.count) { index in
                    Text(segments[index])
                        .tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            profileHeaderWithImageAndStars(rating: $rating)
            
            if selectedSegment == 0 {
              
                HomeOwnerView()
            } else {
                HomeGuestView()
            }
            Spacer()
        }
    }
}
struct HomeOwnerView : View {
    var body: some View {
            VStack{
                ScrollView {
                    HousingInfoView()
                    AnimalInfoView()
                }
                Button("Spara") {
                    
                }.frame(width: 220, height: 40)
                    .background(Color("primary"))
                    .foregroundColor(.black)
                    .cornerRadius(10.0)
                    .padding()
            }
    }
}
struct profileHeaderWithImageAndStars : View {
    @Binding var rating : Int
    var body: some View {
        HStack{
            Image("catimage")
                .resizable()
                .frame(width: 100, height: 100)
                .offset(x: 0)
            VStack{
                Text("Martin")
                    .font(.title2)
                    .offset(x:-35, y: 0)
                RatingBar(rating: $rating)
                    .offset(x: 10, y: -5)
            }
        }.padding()
    }
}
struct HousingInfoView : View {
    @State var selectedBeds = 6
    @State var selectedCity = "Stockholm"
    @State var selectedRooms = 4
    
    var cities = ["Stockholm", "Göteborg", "Malmö", "Uppsala", "Jönköping", "Linköping", "Örebro", "Helsingborg"]
    
    var beds = Array(1...10)
    var rooms = Array(1...10)
    
    @State var additionalInfoHome = ""
    
    var body: some View {
            VStack{
                HStack{
                    Text("Boende")
                        .padding(.horizontal)
                        .fontWeight(.bold)
                    Spacer()
                }
                
                RowView(title: "Stad") {
                    Picker("Välj stad", selection: $selectedCity){
                        ForEach(cities, id: \.self) { city in
                            Text(city).tag(city)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .accentColor(.gray)
                }.padding(.horizontal, 10)
                
                
                RowView(title: "Sovplatser") {
                    Picker("Välj sovplatser", selection: $selectedBeds) {
                        ForEach(beds, id: \.self) { bed in
                            Text("\(bed)").tag(bed)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .accentColor(.gray)
                }.padding(.horizontal,10)
                
                RowView(title: "Antal rum") {
                    Picker("Välj antal rum", selection: $selectedRooms) {
                        ForEach(rooms, id: \.self) { room in
                            Text("\(room)").tag(room)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .accentColor(.gray)
                }.padding(.horizontal,10)
                
                InfoRowView(title: "Info om boendet") {
                        TextEditor(text: $additionalInfoHome)
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
    
    var animals = ["Hund", "Katt", "Fågel", "Fisk", "Reptil", "Pälsdjur"]
    var ages = Array(1...100)
    
    @State var selectedAnimal = "Katt"
    @State var selectedAge = 9
    @State var additionalInfoAnimal = ""
    var body: some View {
        VStack{
            HStack{
                Text("Djur")
                    .padding(.horizontal)
                    .fontWeight(.bold)
                Spacer()
            }
            RowView(title: "Typ av djur") {
                Picker("Välj djur", selection: $selectedAnimal){
                    ForEach(animals, id: \.self) { animal in
                        Text(animal).tag(animal)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .accentColor(.gray)
            }.padding(.horizontal, 10)
            
            RowView(title: "Ålder") {
                Picker("Välj ålder", selection: $selectedAge){
                    ForEach(ages, id: \.self) { age in
                        Text("\(age)").tag(age)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .accentColor(.gray)
            }.padding(.horizontal, 10)
            
            InfoRowView(title: "Info om djur") {
                    TextEditor(text: $additionalInfoAnimal)
                        .scrollContentBackground(.hidden)
                        .frame(height: 70)
                        .padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2))
                        .multilineTextAlignment(.leading)
                        .offset(x: 8, y: -30)

            }.padding(.horizontal, 10)
        }
    }
}
struct RowView<Content : View>:View {
    let title : String
    let content : Content
    
    init(title: String, @ViewBuilder content : () -> Content) {
        self.title = title
        self.content = content()
    }
    var body: some View {
        HStack {
            Text(title)
                .padding(.horizontal)
            Spacer()
            content
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}
struct InfoRowView<Content : View>:View {
    let title : String
    let content : Content
    
    init(title: String, @ViewBuilder content : () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack {
            HStack{
                Text(title)
                    .padding()
                    .fontWeight(.medium)
                Spacer()
            }
            content
                .fontWeight(.light)
                .font(.headline)
        }.background(Color.gray.opacity(0.1))
        
        .cornerRadius(8)
    }
}

struct HomeGuestView : View {
    var body: some View {
        VStack{
            ScrollView {
                AboutMeGuestView()
                    .padding(.vertical)
                GuestAnimalExperienceView()
            }
            Button("Spara") {
                
            }.frame(width: 220, height: 40)
                .background(Color("primary"))
                .foregroundColor(.black)
                .cornerRadius(10.0)
                .padding()
        }
    }
}
struct AboutMeGuestView : View {
    
    var ages = Array(1...100)
    
    @State var selectedAge = 9
    @State var infoGuest = ""
    
    var body: some View {
        VStack{
            HStack{
                Text("Om mig")
                    .fontWeight(.bold)
                    .padding(.horizontal)
                Spacer()
            }
            
            RowView(title: "Ålder") {
                Picker("Välj ålder", selection: $selectedAge){
                    ForEach(ages, id: \.self) { age in
                        Text("\(age)").tag(age)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .accentColor(.gray)
            }.padding(.horizontal, 10)
            
            InfoRowView(title: "Berätta lite om dig själv") {
                    TextEditor(text: $infoGuest)
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
    
    @State var selectedAnimal = "Katt"
    @State var animalExperienceInfoText = ""
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
                Picker("Välj djur", selection: $selectedAnimal){
                    ForEach(animals, id: \.self) { animal in
                        Text(animal).tag(animal)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .accentColor(.gray)
            }.padding(.horizontal, 10)
            
            InfoRowView(title: "Vad har du för erfarenhet av djur?") {
                TextEditor(text: $animalExperienceInfoText)
                    .scrollContentBackground(.hidden)
                    .frame(height: 70)
                    .padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2))
                    .multilineTextAlignment(.leading)
                    .offset(x: 8, y: -30)
            }.padding(.horizontal, 10)
        }
    }
    
}

#Preview {
    ProfileView()
}
