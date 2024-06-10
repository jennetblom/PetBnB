//
//  UserHeaderView.swift
//  PetBnB
//
//  Created by Frida on 2024-06-07.
//

import Foundation
import SwiftUI

struct UserHeaderView: View {
    var userName: String?
    var userRating: Double?
    var userAge: Int?
    var userInfo: String?
    var userJob: String?
    var profilePictureUrl: URL?

    
    @State private var profileImage: Image? // Lägg till @State för att kunna ändra profilbilden
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                if let profileImage = profileImage { // Visa profilbilden om den finns
                    profileImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    if let userName = userName {
                        Text("\(userName) är din värd")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(Color("text"))
                    }
                    
                    if let userJob = userJob {
                        Text(userJob)
                            .font(.subheadline)
                            .foregroundColor(Color(white: 0.3))
                    }
                }
                
                Spacer()
                
                if let userRating = userRating {
                    HStack(spacing: 2) {
                        Text(String(format: "%.1f", userRating))
                            .font(.subheadline)
                            .foregroundColor(Color("text"))
                        Image(systemName: "star.fill")
                            .foregroundColor(Color(red: 1.0, green: 0.843, blue: 0.0))
                    }
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        guard let url = profilePictureUrl else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.profileImage = Image(uiImage: uiImage) // Här kan vi ändra profilbilden eftersom det är @State
                }
            }
        }.resume()
    }
}
#Preview {
    UserHeaderView(
        userName: "John Doe",
        userRating: 4.5,
        userAge: 30,
        userInfo: "Loves pets and has been a host for 5 years.",
        profilePictureUrl: URL(string: "https://example.com/profile.png")
    )
}

