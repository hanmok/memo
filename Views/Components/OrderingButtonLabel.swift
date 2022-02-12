//
//  OrderingButton.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/02/01.
//

import SwiftUI
import CoreData




// MARK: - FOLDER ORDERING




struct FolderOrderingButton: View {
    
    @AppStorage("ordering") private(set) var order: Ordering = Ordering(folderType: "Modification Date", memoType: "Creation Date", folderAsc: true, memoAsc: false)
    
    var type: OrderType
    @Environment(\.managedObjectContext) var context
//    @ObservedObject var folderOrder: FolderOrderVM
    @ObservedObject var fastFolderWithLevelGroup: FastFolderWithLevelGroup
    var body: some View {
        
        Button {
//            folderOrder.orderType = type
            fastFolderWithLevelGroup.orderType = type
            order.folderOrderType = type.rawValue
//            Folder.orderType = type
            Folder.updateTopFolders(context: context)
        } label: {
            HStack {
//                if folderOrder.orderType == type {
                if fastFolderWithLevelGroup.orderType == type {
//                if order.folderOrderType == type.rawValue {
                    ChangeableImage(imageSystemName: "checkmark")
                }
                Text(type.rawValue)
            }
        }
    }
}


struct FolderAscDecButton: View {
    var isAscending: Bool
    @AppStorage("ordering") private(set) var order: Ordering = Ordering(folderType: OrderType.creationDate.rawValue, memoType: OrderType.modificationDate.rawValue, folderAsc: true, memoAsc: false)
    
    @Environment(\.managedObjectContext) var context
//    @ObservedObject var folderOrder: FolderOrderVM
    @ObservedObject var fastFolderWithLevelGroup: FastFolderWithLevelGroup
    
    var body: some View {
        Button {
//            folderOrder.isAscending = isAscending
            fastFolderWithLevelGroup.isAscending = isAscending
            order.folderAsc = isAscending

            Folder.updateTopFolders(context: context)
        } label: {
            HStack {
//                if folderOrder.isAscending == isAscending {
                if fastFolderWithLevelGroup.isAscending == isAscending {
//                if order.folderAsc == isAscending {
                    ChangeableImage(imageSystemName: "checkmark")
                }
                Text(isAscending ? "Ascending Order" : "Decending Order")
            }
        }
    }
}


// MARK: - MEMO ORDERING



struct MemoOrderingButton: View {

    var type: OrderType
    
    @ObservedObject var memoOrder: MemoOrder
    @AppStorage("ordering") private(set) var order: Ordering = Ordering(folderType: OrderType.creationDate.rawValue, memoType: OrderType.modificationDate.rawValue, folderAsc: true, memoAsc: false)
    
    @ObservedObject var parentFolder: Folder
    
    var body: some View {
        
        Button {
            memoOrder.orderType = type
            order.memoOrderType = type.rawValue
            
            parentFolder.title += "" // update parent
            // but .. it goes back to mindmapView... why ?
            // i don't know ....
        } label: {
            HStack {
                if memoOrder.orderType == type {
//                if order.memoOrderType == type.rawValue {
                    ChangeableImage(imageSystemName: "checkmark")
                }
                Text(type.rawValue)
            }
        }
    }
}


struct MemoAscDecButtonLabel: View {
    var isAscending: Bool
    
    @AppStorage("ordering") private(set) var order: Ordering = Ordering(folderType: OrderType.creationDate.rawValue, memoType: OrderType.modificationDate.rawValue, folderAsc: true, memoAsc: false)
    
    @ObservedObject var memoOrder: MemoOrder
    @ObservedObject var parentFolder: Folder
    
    var body: some View {
        Button {
            memoOrder.isAscending = isAscending
            order.memoAsc = isAscending
//            Memo.isAscending = isAscending
            parentFolder.title += ""
        } label: {
            HStack {
                if memoOrder.isAscending == isAscending {
//                if order.memoAsc == isAscending {
                    ChangeableImage(imageSystemName: "checkmark")
                }
                Text(isAscending ? "Ascending Order" : "Decending Order")
            }
        }
    }
}

struct FolderOrderingMenu: View {
    
//    @AppStorage("ordering") private(set) var order: Ordering = Ordering(folderType: OrderType.creationDate.rawValue, memoType: OrderType.modificationDate.rawValue, folderAsc: true, memoAsc: false)
    
//    @ObservedObject var folderOrder: FolderOrderVM
    @ObservedObject var fastFolderWithLevelGroup: FastFolderWithLevelGroup
  
    var body: some View {
        Menu {
            Text("Folder Ordering")
                .font(.title3)
            
//            FolderOrderingButton(type: .modificationDate, folderOrder: folderOrder)
            
            FolderOrderingButton(type: .modificationDate, fastFolderWithLevelGroup: fastFolderWithLevelGroup)
            FolderOrderingButton(type: .creationDate, fastFolderWithLevelGroup: fastFolderWithLevelGroup)
            FolderOrderingButton(type: .alphabetical, fastFolderWithLevelGroup: fastFolderWithLevelGroup)
            
//            FolderOrderingButton( type: .creationDate, folderOrder: folderOrder)
//            FolderOrderingButton(type: .alphabetical, folderOrder: folderOrder)
//            FolderOrderingButton(type: .modificationDate)
//            FolderOrderingButton(type: .creationDate)
//            FolderOrderingButton(type: .alphabetical)
            
            Divider()
            
//            FolderAscDecButton(isAscending: true, folderOrder: folderOrder)
//            FolderAscDecButton(isAscending: false, folderOrder: folderOrder)
            FolderAscDecButton(isAscending: true, fastFolderWithLevelGroup: fastFolderWithLevelGroup)
            FolderAscDecButton(isAscending: false, fastFolderWithLevelGroup: fastFolderWithLevelGroup)
            
//            FolderAscDecButton(isAscending: true, folderOrder: folderOrder)
//            FolderAscDecButton(isAscending: false, folderOrder: folderOrder)
            
//            FolderAscDecButton(isAscending: true)
//            FolderAscDecButton(isAscending: false)
            
            
        } label: {
            ChangeableImage(imageSystemName: "arrow.up.arrow.down")
        }
    }
}

struct MemoOrderingMenu: View {
    @ObservedObject var memoOrder: MemoOrder
    @ObservedObject var parentFolder: Folder
    
//    @AppStorage("ordering") private(set) var order: Ordering = Ordering(folderType: OrderType.creationDate.rawValue, memoType: OrderType.modificationDate.rawValue, folderAsc: true, memoAsc: false)
    
    var body: some View {
        Menu {
            Text("Memo Ordering")
            MemoOrderingButton(type: .modificationDate, memoOrder: memoOrder, parentFolder: parentFolder)
//            MemoOrderingButton(type: .modificationDate, parentFolder: parentFolder)
            MemoOrderingButton(type: .creationDate, memoOrder: memoOrder, parentFolder: parentFolder)
//            MemoOrderingButton(type: .creationDate, parentFolder: parentFolder)
            MemoOrderingButton(type: .alphabetical, memoOrder: memoOrder, parentFolder: parentFolder)
//            MemoOrderingButton(type: .alphabetical, parentFolder: parentFolder)
            
            Divider()
            
            MemoAscDecButtonLabel(isAscending: true, memoOrder: memoOrder, parentFolder: parentFolder)
//            MemoAscDecButtonLabel(isAscending: true, parentFolder: parentFolder)
            
            MemoAscDecButtonLabel(isAscending: false, memoOrder: memoOrder, parentFolder: parentFolder)
//            MemoAscDecButtonLabel(isAscending: false, parentFolder: parentFolder)
            
        } label: {
            ChangeableImage(imageSystemName: "arrow.up.arrow.down")
        }
    }
}
