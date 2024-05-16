//
//  ContentView.swift
//  PetBnB
//
//  Created by Jennet on 2024-05-15.
//

import SwiftUI
import Firebase

struct ContentView: View {
    let db = Firestore.firestore()
    
    @State var signedIn = false
    
    var body: some View {
        if !signedIn {
            SignInView(signedIn: $signedIn)
        } else {
            ExploreView()
        }
    }
        
}
struct SignInView : View {
    @Binding var signedIn : Bool
    var auth = Auth.auth()
    
    
    var body: some View {
        Button("Sign in") {
            auth.signInAnonymously { result, error in
                if let error = error {
                    print("error signing in")
                } else {
                    signedIn = true
                }
                
            }
            
        }
    }
}
struct ExploreView: View {
    let db = Firestore.firestore()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }.onAppear {
//            db.collection("test").addDocument(data: ["name" : "Test"])
        }
        
    }
}

#Preview {
    ContentView()
}
