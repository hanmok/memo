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