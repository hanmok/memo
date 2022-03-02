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
            SystemImage("circle", size: 50)
//                .foregroundColor(Color.subColor)
//                .background(Color.subColor)
                .foregroundColor(colorScheme == .dark ? Color.black : Color.subColor)
                .background(colorScheme == .dark ? Color.black : Color.subColor)
            
                .clipShape(Circle())
                .overlay(Circle()
                            .stroke( Color.subColor, lineWidth: 3))
//            UnchangeableImage(imageSystemName: "folder")
            
            SystemImage("folder")
                .frame(width: 25, height: 25)
//                .foregroundColor(Color.black)
                .foregroundColor(colorScheme == .dark ? Color.subColor : Color.black)
        }
    }
}
