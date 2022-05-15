//
//  MemoOrderingMenu.swift
//  DeeepMemo (iOS)
//
//  Created by Mac mini on 2022/03/03.
//
import SwiftUI


struct MemoOrderingMenu: View {
    @Environment(\.colorScheme) var colorScheme
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
                .tint(colorScheme == .dark ? .navColorForDark : .navColorForLight)
        }
    }
}


struct MemoOrderingMenuInSecondView: View {

    var body: some View {
        Menu {
            
            MemoOrderingButton2( type: .modificationDate)
            MemoOrderingButton2( type: .creationDate)
            MemoOrderingButton2( type: .alphabetical)
            
            Divider()
            
            MemoAscDecButton2(isAscending: true)
            MemoAscDecButton2(isAscending: false)
            
        } label: {
            Text(LocalizedStringStorage.memoOrdering)
        }
    }
}
