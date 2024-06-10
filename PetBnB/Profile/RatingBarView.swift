//
//  RatingBarView.swift
//  PetBnB
//
//  Created by Jennet on 2024-05-22.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct StarView : View {
    var filled : Bool
    var size : CGFloat = 20
    
    var body: some View {
        Image(systemName: filled ? "star.fill" : "star")
            .resizable()
            .frame(width: size, height: size)
            .foregroundColor(filled ? .yellow : .gray)
    }
}
struct RatingBar: View {
    @Binding var rating: Double
    var userID: String
    var maximumRating: Int = 5
    var starSize: CGFloat = 24
    @EnvironmentObject var viewModel: ProfileViewModel

    @State private var selectedRating: Double? = nil
    var currentUserID: String? = Auth.auth().currentUser?.uid // Hämta den aktuella autentiserade användarens ID

        var body: some View {
            HStack {
                ForEach(1..<maximumRating + 1, id: \.self) { number in
                    if canRate { // Kontrollera om användaren kan rösta
                        StarView(filled: number <= Int(selectedRating ?? rating), size: starSize)
                            .onTapGesture {
                                selectedRating = Double(number)
                                updateRating(newRating: Double(number))
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    selectedRating = nil
                                }
                            }
                    } else {
                        StarView(filled: number <= Int(rating), size: starSize)
                    }
                }
            }
        }

        var canRate: Bool {
            // Kontrollera om användaren kan rösta (om userID inte är samma som currentUserID)
            return userID != currentUserID
        }

    func updateRating(newRating: Double) {
        viewModel.ratingCount += 1
        let totalRating = rating * Double(viewModel.ratingCount - 1)
        rating = (totalRating + newRating) / Double(viewModel.ratingCount)
        viewModel.saveUserRatingToFirebase(for: userID)
    }
}
