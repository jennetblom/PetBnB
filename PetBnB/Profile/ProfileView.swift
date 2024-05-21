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
    @State var rating = 3
    var body: some View {
            VStack{
                ScrollView {
                    HStack{
                        Image("catimage")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .offset(x: 20)
                        VStack{
                            Text("Martin")
                                .font(.title2)
                                .offset(x:-20, y: 0)
                            RatingBar(rating: $rating)
                                .offset(x: 25, y: -5)
                        }
                    }.padding()
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
                            .offset(y: -30)

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
            
            RowView(title: "Typ") {
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
                        .offset(y: -30)

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
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
    }
}
struct StarView : View {
    var filled : Bool
    var size : CGFloat = 20
    
    var body: some View {
        Image(systemName: filled ? "star.fill" : "star")
            .resizable()
            .frame(width: size, height: size)
            .foregroundColor(filled ? .yellow : .gray)
    }
}
struct RatingBar: View {
    @Binding var rating: Int
    var maximumRating: Int = 5
    var starSize: CGFloat = 24
    
    var body: some View {
        HStack {
            ForEach(1..<maximumRating + 1, id: \.self) { number in
                StarView(filled: number <= rating, size: starSize)
                    .onTapGesture {
                        rating = number
                    }
            }
        }
    }
}


#Preview {
    ProfileView()
}
