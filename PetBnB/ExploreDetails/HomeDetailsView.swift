import SwiftUI

struct HomeDetailsView: View {
    var home: Home
    @State private var showFullInfo = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
    
                    if home.additionalInfoHome.count > 5 {
                        Text(home.additionalInfoHome)
                            .font(.subheadline)
                            .foregroundColor(Color("text"))
                            .lineLimit(5)
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
            
        }
        .padding(.top)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        formatter.locale = Locale(identifier: "sv_SE")
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
                        .font(.body)
                        .bold()
                        .padding()
                    Spacer()
                }
                .padding([.leading, .top])
                
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {

                        Text(info)
                            .font(.subheadline)
                            .padding(.horizontal)
                            .padding(.vertical)
                        
                        Text("Aktiviteter")
                            .font(.body)
                            .bold()
                            .padding(.horizontal)
                        
                        Text(activities)
                            .font(.subheadline)
                            .padding(.horizontal)
                            .padding(.bottom)

                        
                        Text("Tillgänglighet")
                            .font(.body)
                            .bold()
                            .padding(.horizontal)
                        
                        if let startDate = startDate, let endDate = endDate {
                            Text("Boendet är ledigt mellan den \(formatDate(startDate)) och \(formatDate(endDate))")
                                .font(.subheadline)
                                .padding(.horizontal)
                                .padding(.bottom)
                        } else {
                            Text("N/A")
                                .font(.subheadline)
                                .padding(.horizontal)
                                .padding(.bottom)
                        }
                        
                        Text("Gästernas tillgång")
                            .font(.body)
                            .bold()
                            .padding(.horizontal)
                        
                        Text(guestAccess)
                            .font(.subheadline)
                            .padding(.horizontal)
                            .padding(.bottom)
                        
                        Text("Andra saker att notera")
                            .font(.body)
                            .bold()
                            .padding(.horizontal)
                        
                        Text(otherNotes)
                            .font(.subheadline)
                            .padding(.horizontal)
                            .padding(.bottom)

                        Text("Storlek")
                            .font(.body)
                            .bold()
                            .padding(.horizontal)

                    
                        (Text("Boendet har plats för \(home.guests) gäster, det finns \(home.rooms) rum med \(home.beds) sängar. Boendet har även \(home.bathrooms ?? 0) badrum och dess storlek är \(home.size, specifier: "%.0f") m") + Text("2").font(.system(size: 12)).baselineOffset(6))
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
        formatter.dateFormat = "d MMMM"
        formatter.locale = Locale(identifier: "sv_SE")
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
