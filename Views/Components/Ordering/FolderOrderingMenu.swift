//
//  FolderOrderingMenu.swift
//  DeeepMemo (iOS)
//
//  Created by Mac mini on 2022/03/03.
//

import SwiftUI


struct FolderOrderingMenu: View {
    @ObservedObject var folderOrder: FolderOrder
  
    var body: some View {
        Menu {
            Text(LocalizedStringStorage.folderOrdering)
                .font(.title3)
            
//            FolderOrderingButton(type: .modificationDate)
            FolderOrderingButton(type: .creationDate)
            FolderOrderingButton(type: .alphabetical)
            
            Divider()
//                .foregroundColor(.cream)
//                .tint(.cream)
//                .background(Color.cream)
//                .colorMultiply(.cream)
//            Color.cream
//                .frame(height: 3)
            
            FolderAscDecButton(isAscending: true)
            FolderAscDecButton(isAscending: false)
            
        } label: {
            SystemImage("arrow.up.arrow.down")
                .tint(Color.navBtnColor)
        }
    }
}
