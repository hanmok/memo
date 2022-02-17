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
            ChangeableImage(imageSystemName: "circle", width: 50, height: 50)
            // FG and BG should be the same color
//                .foregroundColor(Color(UIColor(named: "mainColor")!))
//                .background(Color(UIColor(named: "mainColor")!))
                .foregroundColor(colorScheme.adjustMainColors())
                .background(colorScheme.adjustMainColors())

                .clipShape(Circle())
            ChangeableImage(imageSystemName: "folder")
                .frame(width: 25, height: 25)
                .foregroundColor(colorScheme == .dark ? Color(white: 1) : Color(white: 0))
        }
    }
}
