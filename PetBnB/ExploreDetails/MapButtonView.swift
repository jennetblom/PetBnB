
import SwiftUI

struct MapButtonView: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                }) {
                    HStack {
                        Text("Kartor")
                        Image(systemName: "map")
                    }
                    .padding()
                    .background(Color("primary"))
                    .foregroundColor(Color("text"))
                    .cornerRadius(12)
                }
                Spacer()
            }
            .padding()
        }
    }
}
