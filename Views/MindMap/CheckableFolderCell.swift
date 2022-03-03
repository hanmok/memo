//
//  CheckableFolderCell.swift
//  DeeepMemo (iOS)
//
//  Created by Mac mini on 2022/03/03.
//

import SwiftUI


struct CheckableFolderCell: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @ObservedObject var folder: Folder
    
    var level: Int
    
    var shouldCheck = false
    
    var body: some View {
        HStack {
            ForEach( 0 ..< level) { _ in
                Text("  ") // double Space for each level
            }
            
            Text(folder.title)
                .foregroundColor(Color.blackAndWhite)
            
            if folder.isFavorite {
                Text(Image(systemName: "star.fill"))
                    .foregroundColor(Color.blackAndWhite)
            }
            
            Spacer()
            if shouldCheck {
                Button {
                } label: {
                    SystemImage( "checkmark")
                    
                }
                .tint(.swipeBtnColor2)
            }
        }
    }
}

