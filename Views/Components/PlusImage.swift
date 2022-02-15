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
//                .foregroundColor(colorScheme == .dark ? Color.subColorDark : Color.subColor)
                .foregroundColor(Color(UIColor(named: "mainColor")!))
//            Color(UIColor(named: "mainColor")!)
                .background(Color(UIColor(named: "mainColor")!))
                .clipShape(Circle())
            ChangeableImage(imageSystemName: "plus")
                .frame(width: 25, height: 25)
                .foregroundColor(colorScheme.adjustBlackAndWhite())
        }
    }
}

struct PlusImage2: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        
        ZStack {
            ChangeableImage(imageSystemName: "circle", width: 50, height: 50)
                .foregroundColor(Color(UIColor(named: "subColor")!))
                .background(Color(UIColor(named: "subColor")!))
                .clipShape(Circle())
            ChangeableImage(imageSystemName: "plus")
                .frame(width: 25, height: 25)
                .foregroundColor(colorScheme.adjustBlackAndWhite())
        }
    }
}



struct PlusImage_Previews: PreviewProvider {
    static var previews: some View {
        PlusImage()
            .previewLayout(.sizeThatFits)
    }
}
