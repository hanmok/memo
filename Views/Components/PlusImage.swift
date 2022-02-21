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
//                .foregroundColor(colorScheme.adjustMainColors())
//                .background(colorScheme.adjustMainColors())
                .foregroundColor(Color(red: 232, green: 228, blue: 199))
                .background(Color(red: 232, green: 228, blue: 199))
                .clipShape(Circle())
            ChangeableImage(imageSystemName: "plus")
                .frame(width: 25, height: 25)
//                .foregroundColor(colorScheme.adjustBlackAndWhite())
                .foregroundColor(colorScheme.adjustInverseBlackAndWhite())
        }
    }
}

struct PlusImage2: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        
        ZStack {
            ChangeableImage(imageSystemName: "circle", width: 50, height: 50)
//                .foregroundColor(colorScheme.adjustMainColors())
//                .background(colorScheme.adjustMainColors())
                .foregroundColor(Color(red: 232, green: 228, blue: 199))
                .background(Color(red: 232, green: 228, blue: 199))
                .clipShape(Circle())
            ChangeableImage(imageSystemName: "plus")
                .frame(width: 25, height: 25)
//                .foregroundColor(colorScheme.adjustBlackAndWhite())
                .foregroundColor(colorScheme.adjustInverseBlackAndWhite())
        }
    }
}






struct PlusImage_Previews: PreviewProvider {
    static var previews: some View {
        PlusImage()
            .previewLayout(.sizeThatFits)
    }
}
