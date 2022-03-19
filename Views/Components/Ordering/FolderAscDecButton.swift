//
//  FolderAscDecButton.swift
//  DeeepMemo (iOS)
//
//  Created by Mac mini on 2022/03/03.
//

import SwiftUI

struct FolderAscDecButton: View {
    
    var isAscending: Bool
    
    @AppStorage(AppStorageKeys.fOrderAsc) var folderOrderAsc = false
    @AppStorage(AppStorageKeys.fOrderType) var folderOrderType = OrderType.creationDate
    
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        Button {
            folderOrderAsc = isAscending
            Folder.updateTopFolders(context: context)
            
        } label: {
            HStack {
                if folderOrderAsc == isAscending {
                    ChangeableImage(imageSystemName: "checkmark")
                }
//                Text(isAscending ? LocalizedStringStorage.AscendingOrder : LocalizedStringStorage.DecendingOrder)
                if folderOrderType != .alphabetical {
                    Text(isAscending ? LocalizedStringStorage.AscendingOrder : LocalizedStringStorage.DecendingOrder)
                } else {
                    Text(isAscending ? LocalizedStringStorage.AlphabeticalOrder : LocalizedStringStorage.InverseOrder)
                }
            }
        }
    }
}
