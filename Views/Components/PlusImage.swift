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
//            SystemImage(imageSystemName: "circle", size: 50)
                .foregroundColor(Color.subColor)
                .background(Color.subColor)
                .clipShape(Circle())
//            ChangeableImage(imageSystemName: "plus")
            SystemImage(imageSystemName: "plus")
                .frame(width: 25, height: 25)
                .foregroundColor(Color.black)
        }
    }
}







struct PlusImage_Previews: PreviewProvider {
    static var previews: some View {
        PlusImage()
            .previewLayout(.sizeThatFits)
    }
}
