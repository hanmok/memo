//
//  MemoAscDecButton.swift
//  DeeepMemo (iOS)
//
//  Created by Mac mini on 2022/03/03.
//

import SwiftUI


struct MemoAscDecButton: View {
    
    @Environment(\.managedObjectContext) var context
    
    @AppStorage(AppStorageKeys.mOrderAsc) var mOrderAsc = false
    
    @ObservedObject var parentFolder: Folder
    
    var isAscending: Bool
    
    
    var body: some View {
        Button {
            mOrderAsc = isAscending
            
            parentFolder.title += ""
            print("mOrder has changed to \(mOrderAsc)")
            Folder.updateTopFolders(context: context) // added
        } label: {
            HStack {
                if mOrderAsc == isAscending {
                    ChangeableImage(imageSystemName: "checkmark")
                }
//                Text(isAscending ? "Ascending Order" : "Decending Order")
                Text(isAscending ? LocalizedStringStorage.AscendingOrder : LocalizedStringStorage.DecendingOrder)
            }
        }
    }
}

