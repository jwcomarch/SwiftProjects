//
//  AppetizerListCell.swift
//  Appetizers
//
//  Created by Jakub Włodarski on 05/08/2024.
//

import SwiftUI

struct AppetizerListCell: View {
    
    let appetizer: Appetizer
    
    var body: some View {
        HStack {
//            AppetizerRemoteImage(urlString: appetizer.imageURL)
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 120, height: 90)
//                .cornerRadius(8)
            
            //AsyncImage doesn't cache!!!
            AsyncImage(url: URL(string: appetizer.imageURL)) { image in
                AppetizerListCellImageStyle(image: image)
            } placeholder: {
                AppetizerListCellImageStyle(image: Image("food-placeholder"))
            }

            
            VStack(alignment: .leading, spacing: 5) {
                Text(appetizer.name)
                    .font(.title2)
                    .fontWeight(.medium)
                
                Text("$\(appetizer.price, specifier: "%.2f")")
                    .foregroundColor(.secondary)
                    .fontWeight(.semibold)
            }
            .padding(.leading)
        }
    }
}

struct AppetizerListCellImageStyle: View {
    
    var image: Image
    
    var body: some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 120, height: 90)
            .cornerRadius(8)
    }
}

#Preview {
    AppetizerListCell(appetizer: MockData.sampleAppetizer)
}
