//
//  SubFolderButtonImage.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/02/04.
//

import SwiftUI

struct SubFolderButtonImage: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
//            Circle()
//                .stroke(.black, lineWidth: 2)
//                .frame(width: 52, height: 52)
//                .background(.clear)
//                .foregroundColor(.clear)

            
            ChangeableImage(imageSystemName: "circle", width: 50, height: 50)
            // FG and BG should be the same color

//                .foregroundColor(colorScheme.adjustMainColors())
//                .background(colorScheme.adjustMainColors())
//                .foregroundColor(Color(red: 237, green: 233, blue: 204))
//                .background(Color(red: 237, green: 233, blue: 204))
            
                .foregroundColor(Color(red: 232, green: 228, blue: 199))
                .background(Color(red: 232, green: 228, blue: 199))

                .clipShape(Circle())
            UnchangeableImage(imageSystemName: "folder")

                .frame(width: 25, height: 25)
//                .foregroundColor(colorScheme == .dark ? Color(white: 1) : Color(white: 0))
                .foregroundColor(colorScheme.adjustInverseBlackAndWhite())
        }
    }
}
