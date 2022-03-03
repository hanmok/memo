//
//  ChangeableImage.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/22.
//

import SwiftUI
/// white for dark, black for light mode size of 20
struct ChangeableImage: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var imageSystemName: String
    
    var width: CGFloat = 20
    var height: CGFloat = 20
    
    var body: some View {

        Image(systemName: imageSystemName)
            .resizable()
            .aspectRatio( contentMode: .fit)
            .tint(colorScheme == .dark ? .white : .black)
            .frame(width: width, height: height)
    }
}

/// black color size of 20
struct UnchangeableImage: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var imageSystemName: String
    
    var width: CGFloat = 20
    var height: CGFloat = 20
    
    var body: some View {

        Image(systemName: imageSystemName)
            .resizable()
            .aspectRatio( contentMode: .fit)
            .tint(Color.black)
            .frame(width: width, height: height)
    }
}

