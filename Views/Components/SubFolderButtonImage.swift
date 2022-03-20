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
                .foregroundColor(colorScheme == .dark ? Color.black : Color.subColor)
                .background(colorScheme == .dark ? Color.black : Color.subColor)
            
                .clipShape(Circle())
                .overlay(Circle()
                            .stroke( Color.subColor, lineWidth: 3))
            
            SystemImage("folder")
                .frame(width: UIScreen.hasSafeBottom ? 25 : 18, height: UIScreen.hasSafeBottom ? 25 : 18)
                .foregroundColor(colorScheme == .dark ? Color.subColor : Color.black)
        }
    }
}
