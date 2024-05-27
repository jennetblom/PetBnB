import SwiftUI
import Firebase

struct ContentView: View {
    let db = Firestore.firestore()
    
    @State var signedIn = false
    
    var body: some View {
        if !signedIn {
            LogInView(signedIn: $signedIn)
        } else {
            MainTabView()
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            createTabView(view: ExploreView(), title: "Utforska", systemImage: "magnifyingglass", showTitle: false)
            createTabView(view: FavoritesView(), title: "Favoriter", systemImage: "heart", showTitle: true)
            createTabView(view: ChatView(), title: "Chatt", systemImage: "message", showTitle: true)
            createTabView(view: ProfileView(), title: "Profil", systemImage: "person", showTitle: false)
        }
        .accentColor(Color("secondary"))
    }
    
    @ViewBuilder
        func createTabView<V: View>(view: V, title: String, systemImage: String, showTitle: Bool) -> some View {
            NavigationView {
                if showTitle {
                    view
                        .navigationTitle("")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                Text(title)
                                    .font(.headline)
                                    .foregroundColor(.text)
                            }
                        }
                } else {
                    view
                }
            }
            .tabItem {
                Label(title, systemImage: systemImage)
            }
        }
    }

#Preview {
    ContentView()
}
