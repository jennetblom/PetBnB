import SwiftUI

struct HomeDetailsView: View {
    var home: Home
    @State private var showFullInfo = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Storlek")
                        .font(.subheadline)
                        .foregroundColor(Color("text"))
                    Spacer()
                    Text("\(home.size, specifier: "%.0f") m")
                        + Text("2").font(.system(size: 12)).baselineOffset(6)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Info om boendet")
                        .font(.subheadline)
                        .foregroundColor(Color("text"))
                    
                    if home.additionalInfoHome.count > 6 {
                        Text(home.additionalInfoHome)
                            .font(.subheadline)
                            .foregroundColor(Color("text"))
                            .lineLimit(6)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Button(action: {
                            showFullInfo.toggle()
                        }) {
                            Text("Visa mer")
                                .font(.subheadline)
                                .foregroundColor(Color("text"))
                                .underline()
                            + Text(" >")
                                .font(.subheadline)
                                .foregroundColor(Color("text"))
                        }
                        .sheet(isPresented: $showFullInfo) {
                            FullInfoView(
                                home: home,
                                info: home.additionalInfoHome,
                                activities: home.activities,
                                startDate: home.startDate,
                                endDate: home.endDate,
                                guestAccess: home.guestAccess,
                                otherNotes: home.otherNotes
                            )
                        }
                    } else {
                        Text(home.additionalInfoHome)
                            .font(.subheadline)
                            .foregroundColor(Color("text"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding(.horizontal)
            
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(.gray)
                .padding(.horizontal, 17)
        }
        .padding(.top)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

struct FullInfoView: View {
    var home: Home
    var info: String
    var activities: String
    var startDate: Date?
    var endDate: Date?
    var guestAccess: String
    var otherNotes: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.subheadline)
                            .foregroundColor(Color("text"))
                    }
                    Spacer()
                    Text("Om detta boende")
                        .font(.subheadline)
                        .padding()
                    Spacer()
                }
                .padding([.leading, .top])
                
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 0)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Info om boendet")
                            .font(.title)
                            .padding(.horizontal)
                        
                        Text(info)
                            .font(.subheadline)
                            .padding(.horizontal)
                        
                        Text("Aktiviteter")
                            .font(.title)
                            .padding(.horizontal)
                        
                        Text(activities)
                            .font(.subheadline)
                            .padding(.horizontal)
                        
                        Text("Tillgänglighet")
                            .font(.title)
                            .padding(.horizontal)
                        
                        if let startDate = startDate, let endDate = endDate {
                            Text("\(formatDate(startDate)) - \(formatDate(endDate))")
                                .font(.subheadline)
                                .padding(.horizontal)
                        } else {
                            Text("N/A")
                                .font(.subheadline)
                                .padding(.horizontal)
                        }
                        
                        Text("Gästernas tillgång")
                            .font(.title)
                            .padding(.horizontal)
                        
                        Text(guestAccess)
                            .font(.subheadline)
                            .padding(.horizontal)
                        
                        Text("Andra saker att notera")
                            .font(.title)
                            .padding(.horizontal)
                        
                        Text(otherNotes)
                            .font(.subheadline)
                            .padding(.horizontal)

                        Text("Storlek")
                            .font(.title)
                            .padding(.horizontal)

                    
                        (Text("Boendet har plats för \(home.guests) gäster, det finns \(home.rooms) rum med \(home.beds) sängar. Boendet har även \(home.bathrooms ?? 0) badrum och storleken är \(home.size, specifier: "%.0f") m") + Text("2").font(.system(size: 12)).baselineOffset(6))
                                                  .font(.subheadline)
                                                  .padding(.horizontal)
                                          }
                                      }
                                      .padding(.horizontal)
                                  }
                                  .navigationBarHidden(true)
                              }
                          }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

#Preview {
    HomeDetailsView(
        home: Home(
            id: "tTCAOPeuRXAGLY2PXQTg",
            userID: "pdKIMskgwUTSTPeN15wkG5TbI3D2",
            name: "Fransk bulldog i villa",
            beds: 2,
            rooms: 3,
            size: 100,
            guests: 4,
            animals: [
                "Hund": AnimalInfo(type: "Bulldog", age: 2, additionalInfoAnimal: "Friendly dog loves to cuddle"),
                "Katt": AnimalInfo(type: "Persian", age: 3, additionalInfoAnimal: "Loves to cuddle")
            ],
            additionalInfoHome: "Mysig och idyllisk stuga/sommarstuga för en familj eller par som vill övernatta. Möjlighet att fiska i roddbåt finns vid uthyrning av stugan. Stäng av dina telefoner och njut av en trevlig vistelse och/eller helg med de människor du älskar.  Om det tas på de dagar du vill, skriv till mig. Jag har två stugor. Boendet Mysigt semesterhus 1 meter från stor sjö. Här kan du både bada och fiska Gästers tillgång Du har allt för dig själv. Andra saker att notera Mysigt och lugnt område",
            city: "Göteborg",
            availability: 28,
            startDate: Date(),
            endDate: Date().addingTimeInterval(86400 * 7),
            images: [
                "image1": URL(string: "https://firebasestorage.googleapis.com/v0/b/petbnb-267ff.appspot.com/o/placeholder_home.png?alt=media&token=0e13552e-0052-4bd2-9170-856beacea3b1")!,
                "image2": URL(string: "https://firebasestorage.googleapis.com/v0/b/petbnb-267ff.appspot.com/o/placeholder_home2.png?alt=media&token=a2c1ea5a-134a-466d-be39-19aedfa13e9a")!
            ],
            rating: 4.8,
            country: "Sweden",
            bathrooms: 2,
            activities: "Fiska, vandra, cykla",
            guestAccess: "Hela stugan",
            otherNotes: "Husdjur tillåtna"
        )
    )
}
