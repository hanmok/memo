//
//  FolderOrderingMenu.swift
//  DeeepMemo (iOS)
//
//  Created by Mac mini on 2022/03/03.
//

import SwiftUI


struct FolderOrderingMenu: View {
    @Environment(\.colorScheme) var colorScheme
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
                .tint(colorScheme == .dark ? .navColorForDark : .navColorForLight)
        }
    }
}

struct FolderOrderingMenuInSecondView: View {
    
    
    var body: some View {
        Menu {
            FolderOrderingButton(type: .creationDate)
            FolderOrderingButton(type: .alphabetical)
            
            Divider()
            
            FolderAscDecButton(isAscending: true)
            FolderAscDecButton(isAscending: false)
            
        } label: {
            Text(LocalizedStringStorage.folderOrdering)
        }
    }
}
