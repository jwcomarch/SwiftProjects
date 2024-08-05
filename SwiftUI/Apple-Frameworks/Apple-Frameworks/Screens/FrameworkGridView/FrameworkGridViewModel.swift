//
//  FrameworkGridViewModel.swift
//  Apple-Frameworks
//
//  Created by Jakub Włodarski on 02/08/2024.
//

import SwiftUI

final class FrameworkGridViewModel: ObservableObject {
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
}
