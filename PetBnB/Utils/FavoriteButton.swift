import SwiftUI

struct FavouriteButton: View {
    @Binding var isFavorite: Bool

    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0)) {
                isFavorite.toggle()
            }
        }) {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .foregroundColor(Color("details"))
                .padding()
                .background(Color.black.opacity(0.5))
                .clipShape(Circle())
                .shadow(radius: 4)
                .scaleEffect(isFavorite ? 1.2 : 1.0)
                .padding([.top, .trailing])
        }
    }
}
