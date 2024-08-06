//
//  APButton.swift
//  Appetizers
//
//  Created by Jakub Włodarski on 06/08/2024.
//

import SwiftUI

struct APButton: View {
    
    var title: LocalizedStringKey
    
    var body: some View {
        Text(title)
            .font(.title3)
            .fontWeight(.semibold)
            .frame(width: 260, height: 50)
            .foregroundColor(.white)
            .background(Color.brandPrimaryColor)
            .cornerRadius(10)
    }
}

#Preview {
    APButton(title: "Test")
}
