import SwiftUI

struct AdditionalInfoView: View {
    var additionalInfo: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Section(header: Text("Mer info")
                        .font(.title)
                        .padding(.horizontal)) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(additionalInfo)
                        .font(.subheadline)
                        .foregroundColor(Color("text"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal)
            }
            
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(.gray)
                .padding(.horizontal, 17)
        }
        .padding(.top)
    }
}

#Preview {
    AdditionalInfoView(
        additionalInfo: "This is some additional information about the home, the animals, or other relevant details that might be interesting for the guests to know."
    )
}
