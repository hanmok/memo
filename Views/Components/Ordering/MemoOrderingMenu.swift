//
//  MemoOrderingMenu.swift
//  DeeepMemo (iOS)
//
//  Created by Mac mini on 2022/03/03.
//

import SwiftUI


struct MemoOrderingMenu: View {
//    @ObservedObject var memoOrder: MemoOrder
    @EnvironmentObject var memoOrder: MemoOrder
    @ObservedObject var parentFolder: Folder
    
    var body: some View {
        Menu {
            Text(LocalizedStringStorage.memoOrdering)
            MemoOrderingButton(parentFolder: parentFolder, type: .modificationDate)
            MemoOrderingButton(parentFolder: parentFolder, type: .creationDate)
            MemoOrderingButton(parentFolder: parentFolder, type: .alphabetical)
            
            Divider()
            
            MemoAscDecButton(parentFolder: parentFolder, isAscending: true)
            MemoAscDecButton(parentFolder: parentFolder, isAscending: false)
            
        } label: {
            SystemImage( "arrow.up.arrow.down")
                .tint(Color.navBtnColor)
        }
    }
}

