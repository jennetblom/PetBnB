
import SwiftUI

struct AddHomeVIew: View {
    @State private var beds: String = "6"
    
    var body: some View {
        VStack{
            Form {
                Section(header: Text("Boende")) {
                    HStack{
                        Text("Antal bäddar:")
                        TextField("Antal sängar", text: $beds) }
                }
                
                Section(header: Text("Djur")) {
                    
                }
                
            }
            
            .onAppear{
                
            }
        }
    }
}

#Preview {
    AddHomeVIew()
}
