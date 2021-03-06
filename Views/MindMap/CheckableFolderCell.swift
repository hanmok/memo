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
    
    var markCheck = false
    var markInvalid = false
    
    var body: some View {
        HStack {
            ForEach( 0 ..< level, id: \.self) { _ in
                Text("  ") // double Space for each level
            }
            
            Text(folder.title)
                .foregroundColor(Color.blackAndWhite)
            
            Spacer()
            if markCheck {
                Button {
                } label: {
                    SystemImage(.Icon.checkmark)
                    
                }
                .tint(.lightSwipeBtn1)
            }
            if markInvalid {
                Button { } label: {
                    SystemImage(.Icon.multiply)
                }
                .tint(.lightSwipeBtn1)
            }
        }
    }
}
