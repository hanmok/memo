//
//  TItleWithLavelView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/02/01.
//

import SwiftUI

struct TitleWithLevelView: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    @ObservedObject var folder: Folder
    
    var level: Int

    var shouldHideArrow = false
    
    var body: some View {
        HStack {
            ForEach( 0 ..< level) { _ in
                Text("  ") // double Space for each level
            }
            
            Text(folder.title)
                .foregroundColor(Color.blackAndWhite)
            
            if folder.isFavorite {
                Text(Image(systemName: "star.fill"))
//                    .tint(.yellow) // why not working ?
            }
            
            Spacer()
            Text("\(folder.memos.count)")
                .foregroundColor(.gray)
                
        }
        .frame(maxWidth: .infinity)
    }
}


struct CheckableFolderCell: View {

    @Environment(\.colorScheme) var colorScheme: ColorScheme

    @ObservedObject var folder: Folder

    var level: Int
    
    var shouldHideArrow = false
    var shouldCheck: Bool = false
    var body: some View {
        HStack {
            ForEach( 0 ..< level) { _ in
                Text("  ") // double Space for each level
            }
            
            Text(folder.title)
                .foregroundColor(Color.blackAndWhite)
            
            if folder.isFavorite {
                Text(Image(systemName: "star.fill"))
//                    .foregroundColor(colorScheme.adjustMainColors())
//                    .foregroundColor(colorScheme.adjustBlackAndWhite())
                    .foregroundColor(Color.blackAndWhite)
//                    .tint(.yellow) // why not working ?
            }
            
            Spacer()
            if shouldCheck {
            Button {
            } label: {
                SystemImage(imageSystemName: "checkmark")
                
            }
//            .tint(Color.subColor)
//            .tint(Color(UIColor(named: "mainColor")!))
//            .tint(colorScheme.adjustMainColors())
            .tint(Color.mainColor)
            }
        }
        
    }
    
}
