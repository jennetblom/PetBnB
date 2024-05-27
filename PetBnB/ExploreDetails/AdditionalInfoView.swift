import SwiftUI

struct AdditionalInfoView: View {
    var additionalInfo: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Mer info")
                .font(.headline)
                .padding(.horizontal)
            Text(additionalInfo)
                .padding(.horizontal)
                .foregroundColor(.black)
        }
    }
}
