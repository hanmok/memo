//
//  FolderOrderingMenu.swift
//  DeeepMemo (iOS)
//
//  Created by Mac mini on 2022/03/03.
//

import SwiftUI


struct FolderOrderingMenu: View {
      
    var body: some View {
        Menu {
            Text(LocalizedStringStorage.folderOrdering)
                .font(.title3)
            
            FolderOrderingButton(type: .creationDate)
            FolderOrderingButton(type: .alphabetical)
            
            Divider()
            
            FolderAscDecButton(isAscending: true)
            FolderAscDecButton(isAscending: false)
            
        } label: {
            SystemImage("arrow.up.arrow.down")
                .tint(Color.navBtnColor)
        }
    }
}

struct FolderOrderingMenuInSecondView: View {
    
    // not updating correctly..
    
    var body: some View {
        Menu {
//            Text(LocalizedStringStorage.folderOrdering)
//                .font(.title3)
            
            FolderOrderingButton(type: .creationDate)
            FolderOrderingButton(type: .alphabetical)
            
            Divider()
            
            FolderAscDecButton(isAscending: true)
            FolderAscDecButton(isAscending: false)
            
        } label: {
//            SystemImage("arrow.up.arrow.down")
//                .tint(Color.navBtnColor)
            Text(LocalizedStringStorage.folderOrdering)
        }
    }
}
