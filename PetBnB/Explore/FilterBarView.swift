import SwiftUI

struct FilterBarView: View {
    @Binding var selectedFilter: String
    let filters: [String]

    var body: some View {
        ZStack(alignment: .bottom) {
            HStack(spacing: 0) {
                ForEach(filters, id: \.self) { filter in
                    FilterButton(filter: filter, isSelected: filter == selectedFilter) {
                        withAnimation {
                            selectedFilter = filter
                        }
                        print("Selected filter: \(filter)")
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color("background"))
            .padding(.vertical, 0)
            .padding(.trailing, 10)
            
            Rectangle()
                .fill(Color.gray)
                .frame(height: 0.5)
                .padding(.bottom, 8)
        }
        .padding(.top)
    }
}

struct FilterButton: View {
    var filter: String
    var isSelected: Bool
    var action: () -> Void

    @State private var isPressed: Bool = false

    var body: some View {
        Button(action: action) {
            VStack {
                Text(filter)
                    .font(.system(size: 16))
                    .foregroundColor(isSelected ? Color("text") : .primary)
                    .scaleEffect(isSelected ? 1.2 : 1.0)
                    .scaleEffect(isPressed ? 1.1 : 1.0)
                    .animation(.spring(), value: isSelected)
                Rectangle()
                    .fill(isSelected ? Color("text") : Color.clear)
                    .frame(height: 2)
                    .transition(.slide)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .padding(.horizontal, 0)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 1.1 : 1.0)
        .animation(.spring(), value: isPressed)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation {
                        isPressed = false
                    }
                }
        )
    }
}
