//
//  PlusImage.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/21.
//

import SwiftUI

struct PlusImage: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
//        EmptyView()
//        Image(systemName: "plus.circle")
//            .resizable()
////            .frame(width: 30, height: 30)
//            .frame(width: 45, height: 45)
//            .aspectRatio( contentMode: .fit)
//            .tint(.black)
        
        ChangeableImage(colorScheme: _colorScheme, imageSystemName: "plus.circle", width: 40, height: 40)
            .frame(width: 40, height: 40)
        
    }
}


struct PlusImage_Previews: PreviewProvider {
    static var previews: some View {
        PlusImage()
            .previewLayout(.sizeThatFits)
    }
}
