
import SwiftUI

struct AddHomeVIew: View {
    @State private var beds: String = "hämta från fb"
    
    var body: some View {
        NavigationStack{
        VStack{
            Form {
                Section(header: Text("Boende")) {
                    HStack{
                        Text("Sovplatser:")
                        TextField("Sovplatser", text: $beds) }
                }
                //If more than 1 animal add more sections
                Section(header: HStack {
                                    Text("Djur 1")
                                    Spacer()
                                    Button(action: {
                                        
                                        //viewModel.addAnimal()
                                    }) {
                                        Image(systemName: "plus")
                                    }
                                })  {
                    HStack{
                        Text("Typ:")
                        TextField("Typ", text: $beds) }
                    HStack{
                        Text("Ålder:")
                        TextField("Ålder", text: $beds) }
                    HStack{
                        Text("Övrig info:")
                        TextField("Övrig info", text: $beds) }
                    
                }
                
            }
            
            .onAppear{
                
            }
        }
        .navigationTitle("Lägg till boende")
        .navigationBarTitleDisplayMode(.inline)
    }
    }
}

#Preview {
    AddHomeVIew()
}
