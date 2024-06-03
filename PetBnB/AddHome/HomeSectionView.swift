import SwiftUI
import MapKit
import CoreLocation

struct HomeSectionView: View {
    @Binding var beds: Int
    @Binding var rooms: Int
    @Binding var size: Int
    @Binding var city: String
    @Binding var additionalInfoHome: String
    @Binding var name: String
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var activities: String
    @Binding var bathrooms: Int
    @Binding var guests: Int
    @Binding var country: String
    @Binding var guestAccess: String
    @Binding var otherNotes: String
    @Binding var size: Int

    @State private var coordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var showMap: Bool = false
    @State private var pinnedLocation: IdentifiableCoordinate?
    
    let guestAccessOptions = ["Hela hemmet", "Delat badrum", "Delat boende"]
    let limit = 20
    
    var body: some View {
        Section(header: Text("Rubrik")) {
            TextField("Fyll i din rubrik för boendet här", text: $name)
                .onChange(of: name) { newValue in
                    if newValue.count > limit {
                        name = String(newValue.prefix(limit))
                    }
                }
        }
        
        Section(header: Text("Boende")) {
            HStack {
                Text("Sovplatser:")
                TextField("Fyll i här", value: $beds, formatter: NumberFormatter())
            }
            HStack {
                Text("Gäster:")
                TextField("Fyll i här", value: $guests, formatter: NumberFormatter())
            }
            HStack {
                Text("Antal rum:")
                TextField("Fyll i här", value: $rooms, formatter: NumberFormatter())
            }
            HStack {
                Text("Badrum:")
                TextField("Fyll i här", value: $bathrooms, formatter: NumberFormatter())
            }
            HStack {
                Text("Storlek:")
                TextField("Fyll i här", value: $size, formatter: NumberFormatter())
            }
            HStack {
                Text("Stad:")
                TextField("Fyll i här", text: $city)
                    .onChange(of: city) { newValue in
                        if !newValue.isEmpty {
                            country = "Sverige"
                        }
                    }
                
                NavigationLink(destination: MapView(coordinateRegion: $coordinateRegion, pinnedLocation: $pinnedLocation)) {
                    Image(systemName: "map")
                        .foregroundColor(Color("primary"))
                }
                .onTapGesture {
                    geocodeCity()
                }
            }
            HStack {
                Text("Land:")
                TextField("Fyll i här", text: $country)
            }
            HStack {
                Text("Tillgängligt från:")
                DatePicker(
                    "",
                    selection: $startDate,
                    in: Date()...,
                    displayedComponents: [.date])
            }
            HStack {
                Text("Tillgängligt till:")
                DatePicker(
                    "",
                    selection: $endDate,
                    in: startDate...,
                    displayedComponents: [.date])
            }
            HStack {
                Text("Gästernas tillgång:")
                Spacer()
                Menu {
                    ForEach(guestAccessOptions, id: \.self) { option in
                        Button(action: {
                            guestAccess = option
                        }) {
                            Text(option)
                        }
                    }
                } label: {
                    Text(guestAccess.isEmpty ? "Välj här" : guestAccess)
                        .foregroundColor(Color("text"))
                }
                .padding(.trailing)
            }
            
            HStack(alignment: .top) {
                            Text("Beskrivelse:")
                                .padding(.top, 8)
                            TextEditorWithPlaceholder(placeholder: "Beskriv ditt hem här...", text: $additionalInfoHome)
                                .frame(height: 100)
                        }
            
            HStack(alignment: .top) {
                            Text("Aktiviteter:")
                                .padding(.top, 8)
                            TextEditorWithPlaceholder(placeholder: "Skriv hemmets aktiviteter...", text: $activities)
                                .frame(height: 50)
                        }
            
            HStack(alignment: .top) {
                            Text("Övrigt:")
                                .padding(.top, 8)
                            TextEditorWithPlaceholder(placeholder: "Övrig info...", text: $otherNotes)
                                .frame(height: 50)
                        }
            
        }
    }
    
    private func geocodeCity() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(city) { (placemarks, error) in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
            } else if let placemarks = placemarks, let location = placemarks.first?.location {
                coordinateRegion = MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
                showMap = true
            }
        }
    }
}

struct IdentifiableCoordinate: Identifiable {
    var id = UUID()
    var coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    @Binding var coordinateRegion: MKCoordinateRegion
    @Binding var pinnedLocation: IdentifiableCoordinate?

    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Map(coordinateRegion: $coordinateRegion, interactionModes: .all, showsUserLocation: true, annotationItems: [pinnedLocation].compactMap { $0 }) { location in
                MapPin(coordinate: location.coordinate, tint: .red)
            }
            .navigationBarTitle("Pinna plats", displayMode: .inline)
            .navigationBarItems(leading: Button("Tillbaka") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Pinna") {
                pinnedLocation = IdentifiableCoordinate(coordinate: coordinateRegion.center)
            })
        }
    }
}

struct TextEditorWithPlaceholder: View {
    var placeholder: String
    @Binding var text: String
    @State private var showPlaceholder: Bool = true
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if showPlaceholder {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .padding(.top, 8)
                    .padding(.horizontal, 4)
            }
            TextEditor(text: $text)
                .onChange(of: text) { _ in
                    showPlaceholder = text.isEmpty
                }
                .padding(.horizontal, 4)
        }
    }
}
