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
    @Binding var latitude: Double?
    @Binding var longitude: Double?
    @Binding var shouldDismiss: Bool
    
    
    @EnvironmentObject var tabViewModel: TabViewModel
    @StateObject var addHomeViewModel = AddHomeViewModel()
    
    @State private var coordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var showMap: Bool = false
    @State private var pinnedLocation: IdentifiableCoordinate?
    @State private var geocodingComplete: Bool = false // För att hålla reda på om geokodningen är klar
    
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
                    shouldDismiss = false
                    tabViewModel.returningFromMap = true
                    geocodeCity(city: city)
                }
            }
            .onChange(of: pinnedLocation) { newValue in
                if let newLocation = newValue {
                    latitude = newLocation.coordinate.latitude
                    longitude = newLocation.coordinate.longitude
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
        .onAppear {
            addHomeViewModel.fetchCity { result in
                switch result {
                case .success(let city):
                    DispatchQueue.main.async {
                        geocodeCity(city: city)
                    }
                case .failure(let error):
                    print("Error fetching city: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        setDefaultLocation()
                    }
                }
                
            }
        }
    }
    
    
    private func geocodeCity(city : String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(city) { (placemarks, error) in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                setDefaultLocation()
            } else if let placemarks = placemarks, let location = placemarks.first?.location {
                coordinateRegion = MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
                geocodingComplete = true // Mark geocoding as done
                showMap = true
            }
        }
    }
    func setDefaultLocation() {
        // Set default location to Stockholm, Sweden
        coordinateRegion.center = CLLocationCoordinate2D(latitude: 59.3293, longitude: 18.0686)
        showMap = true
    }
}
struct IdentifiableCoordinate: Identifiable, Equatable {
    var id = UUID()
    var coordinate: CLLocationCoordinate2D
    
    static func == (lhs: IdentifiableCoordinate, rhs: IdentifiableCoordinate) -> Bool {
        lhs.id == rhs.id && lhs.coordinate.latitude == rhs.coordinate.latitude && lhs.coordinate.longitude == rhs.coordinate.longitude
    }
}

struct MapView: View {
    @Binding var coordinateRegion: MKCoordinateRegion
    @Binding var pinnedLocation: IdentifiableCoordinate?
    @EnvironmentObject var tabViewModel: TabViewModel
    
    @Environment(\.presentationMode) var presentationMode
    @State private var isLocationPinned = false
    
    var body: some View {
        NavigationView {
            Map(coordinateRegion: $coordinateRegion, interactionModes: .all, showsUserLocation: true, annotationItems: [pinnedLocation].compactMap { $0 }) { location in
                MapPin(coordinate: location.coordinate, tint: .red)
            }
            .navigationBarTitle("Pinna plats", displayMode: .inline)
            .navigationBarItems(
                trailing: HStack {
                    if isLocationPinned {
                        Button("Spara") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    Button("Pin") {
                        pinnedLocation = IdentifiableCoordinate(coordinate: coordinateRegion.center)
                        isLocationPinned = true
                        
                    }
                }
            )
        }
        .onAppear {
            tabViewModel.isMapViewPresented = true
            tabViewModel.returningFromMap = true
        }
        .onDisappear {
            tabViewModel.isMapViewPresented = false
            
        }
    }
    
}


struct TextEditorWithPlaceholder: View {
    var placeholder: String
    @Binding var text: String
    @State private var showPlaceholder: Bool = true
    
    init(placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
        self._showPlaceholder = State(initialValue: text.wrappedValue.isEmpty)
    }
    
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
