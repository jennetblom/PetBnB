//
//  RowViews.swift
//  PetBnB
//
//  Created by Jennet on 2024-05-23.
//

import Foundation
import SwiftUI

struct RowView<Content : View>:View {
    let title : String
    let content : Content
    
    init(title: String, @ViewBuilder content : () -> Content) {
        self.title = title
        self.content = content()
    }
    var body: some View {
        HStack {
            Text(title)
                .padding(.horizontal)
            Spacer()
            content
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}
struct InfoRowView<Content : View>:View {
    let title : String
    let content : Content
    
    init(title: String, @ViewBuilder content : () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack {
            HStack{
                Text(title)
                    .padding()
                    .fontWeight(.medium)
                Spacer()
            }
            content
                .fontWeight(.light)
                .font(.headline)
        }.background(Color.gray.opacity(0.1))
        
        .cornerRadius(8)
    }
}
