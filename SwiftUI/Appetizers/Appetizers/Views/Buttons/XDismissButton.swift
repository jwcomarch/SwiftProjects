//
//  XDismissButton.swift
//  Appetizers
//
//  Created by Jakub Włodarski on 06/08/2024.
//

import SwiftUI

struct XDismissButton: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
                .opacity(0.6)
            Image(systemName: "xmark")
                .imageScale(.small)
                .frame(width: 44, height: 44)
                .foregroundColor(.black)
                .opacity(0.9)
        }
    }
}

#Preview {
    XDismissButton()
}
