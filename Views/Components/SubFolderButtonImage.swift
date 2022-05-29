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
            SystemImage("circle", size: UIScreen.hasSafeBottom ? 50 : 40)

//                .foregroundColor(colorScheme == .dark ? Color.black : Color.subColor)
//                .background(colorScheme == .dark ? Color.black : Color.subColor)
//                .foregroundColor(Color.swipeBtnColor2)
//                .background(Color.swipeBtnColor2)
//                .foregroundColor(colorScheme == .dark ? .white : .black)
                .foregroundColor(.clear)

//                .clipShape(Circle())
                .overlay(Circle()
                    .stroke(colorScheme == .dark ? .white : .black, lineWidth: 3))

            SystemImage("folder")
                .frame(width: UIScreen.hasSafeBottom ? 25 : 18, height: UIScreen.hasSafeBottom ? 25 : 18)
                .foregroundColor(colorScheme == .dark ? .white : .black)

        }
        
    }
}
