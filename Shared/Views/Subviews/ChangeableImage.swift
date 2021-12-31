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

//struct ChangeableImage_Previews: PreviewProvider {
//    static var previews: some View {
//        ChangeableImage()
//    }
//}

extension Image {
    func setupAdditional(scheme: ColorScheme, size: CGFloat = 20) -> some View {
        self
            .resizable()
            .aspectRatio( contentMode: .fit)
            .tint(scheme == .dark ? .white : .black)
            .frame(width: size , height: size)
    }
}
