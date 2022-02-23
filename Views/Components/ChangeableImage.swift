//
//  ChangeableImage.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/22.
//

import SwiftUI

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

struct SystemImage: View {
    internal init(_ imageSystemName: String, size: CGFloat = 20) {
        self.imageSystemName = imageSystemName
        self.size = size
    }
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var imageSystemName: String
//    var width: CGFloat = 20
//    var height: CGFloat = 20
    var size: CGFloat
    var body: some View {

        Image(systemName: imageSystemName)
            .resizable()
            .aspectRatio( contentMode: .fit)
//            .tint(Color.black)
            .frame(width: size, height: size)
    }
}

