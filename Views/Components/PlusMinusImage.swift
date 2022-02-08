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
        
        ZStack {
            ChangeableImage(imageSystemName: "circle", width: 50, height: 50)
//                .foregroundColor(.green)
//                .background(.green)
                .foregroundColor(colorScheme == .dark ? Color.subColorDark : Color.subColor)
                .background(colorScheme == .dark ? Color.subColorDark : Color.subColor)
                .clipShape(Circle())
            ChangeableImage(imageSystemName: "plus")
                .frame(width: 25, height: 25)
//                .foregroundColor(.black)
                .foregroundColor(colorScheme.adjustBlackAndWhite())
        }
    }
}

struct MinusImage: View {
    
//    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        
        ChangeableImage( imageSystemName: "minus.circle", width: 40, height: 40)
            .frame(width: 40, height: 40)
        
    }
}




struct PlusImage_Previews: PreviewProvider {
    static var previews: some View {
        PlusImage()
            .previewLayout(.sizeThatFits)
    }
}
