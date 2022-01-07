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
        
        ChangeableImage(colorScheme: _colorScheme, imageSystemName: "plus.circle", width: 40, height: 40)
            .frame(width: 40, height: 40)
        
    }
}

struct MinusImage: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        
        ChangeableImage(colorScheme: _colorScheme, imageSystemName: "minus.circle", width: 40, height: 40)
            .frame(width: 40, height: 40)
        
    }
}



struct PlusImage_Previews: PreviewProvider {
    static var previews: some View {
        PlusImage()
            .previewLayout(.sizeThatFits)
    }
}