//
//  SystemImage.swift
//  DeeepMemo (iOS)
//
//  Created by Mac mini on 2022/03/03.
//

import SwiftUI


struct SystemImage: View {
    
    var imageSystemName: String
    var size: CGFloat
    
    internal init(_ imageSystemName: String, size: CGFloat = 20) {
        self.imageSystemName = imageSystemName
        self.size = size
    }
    
    var body: some View {

        Image(systemName: imageSystemName)
            .resizable()
            .aspectRatio( contentMode: .fit)
            .frame(width: size, height: size)
    }
}
