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
    @AppStorage(AppStorageKeys.mOrderType) var mOrderType = OrderType.modificationDate
    
    @ObservedObject var parentFolder: Folder
    
    var isAscending: Bool
    
    @State var text = ""
    
    func determineText() -> String{
        if mOrderAsc == true {
            if mOrderType == .alphabetical {
                return "Alphabetical Order"
            } else { return LocalizedStringStorage.DecendingOrder}
        }
        if mOrderType == .alphabetical {
            return "Inserse Order"
        } else {
            return LocalizedStringStorage.AscendingOrder
        }
    }
    
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
                
                if mOrderType != .alphabetical {
                Text(isAscending ? LocalizedStringStorage.AscendingOrder : LocalizedStringStorage.DecendingOrder)
                } else {
                    Text(isAscending ? LocalizedStringStorage.AlphabeticalOrder : LocalizedStringStorage.InverseOrder)
                }
            }
        }
    }
}
