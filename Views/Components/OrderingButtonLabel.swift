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
    @AppStorage(AppStorageKeys.fOrderType) var folderOrderType = OrderType.creationDate
    var type: OrderType
    @Environment(\.managedObjectContext) var context
//    @ObservedObject var folderOrder: FolderOrder
//    var folderOrderType: OrderType
    var body: some View {
        
        Button {
//            folderOrder.orderType = type
//            Folder.orderType = type
            Folder.updateTopFolders(context: context)
            folderOrderType = type
            print("Folder orderType has changed to \(folderOrderType.rawValue)")
        } label: {
            HStack {
//                if folderOrder.orderType == type {
                if folderOrderType == type {
                    ChangeableImage(imageSystemName: "checkmark")
                }
                Text(type.rawValue)
            }
        }
    }
}


struct FolderAscDecButton: View {
    var isAscending: Bool
    @AppStorage("fOrderAsc") var folderOrderAsc = false
    @Environment(\.managedObjectContext) var context
//    @ObservedObject var folderOrder: FolderOrder
//    var folderOrderAsc: Bool
    var body: some View {
        Button {
//            folderOrder.isAscending = isAscending
//            Folder.isAscending = isAscending
            Folder.updateTopFolders(context: context)
            folderOrderAsc = isAscending
        } label: {
            HStack {
//                if folderOrder.isAscending == isAscending {
                if folderOrderAsc == isAscending {
                    ChangeableImage(imageSystemName: "checkmark")
                }
                Text(isAscending ? "Ascending Order" : "Decending Order")
            }
        }
    }
}


// MARK: - MEMO ORDERING



struct MemoOrderingButton: View {
    @Environment(\.managedObjectContext) var context
    var type: OrderType
    
    @AppStorage(AppStorageKeys.mOrderType) var mOrderType = OrderType.creationDate

    @ObservedObject var parentFolder: Folder
    
    var body: some View {
        
        Button {
            mOrderType = type
            Folder.updateTopFolders(context: context)
//            parentFolder.title += "" // update parent
            print("Memo orderType has changed to \(mOrderType.rawValue)")
            print("memo Type has changed to \(mOrderType.rawValue)")
        } label: {
            HStack {
                if mOrderType == type {
                    ChangeableImage(imageSystemName: "checkmark")
                }
                Text(type.rawValue)
            }
        }
    }
}


struct MemoAscDecButton: View {
    var isAscending: Bool
    
    @AppStorage("mOrderAsc") var mOrderAsc = false
    @ObservedObject var parentFolder: Folder
    @Environment(\.managedObjectContext) var context
    var body: some View {
        Button {
            mOrderAsc = isAscending
            Folder.updateTopFolders(context: context)
        } label: {
            HStack {
                if mOrderAsc == isAscending {
                    ChangeableImage(imageSystemName: "checkmark")
                }
                Text(isAscending ? "Ascending Order" : "Decending Order")
            }
        }
    }
}

struct FolderOrderingMenu: View {
    @AppStorage(AppStorageKeys.fOrderType) var fOrderType = OrderType.creationDate
    @AppStorage(AppStorageKeys.fOrderAsc) var fOrderAsc = false
    
    var body: some View {
        Menu {
            Text("Folder Ordering")
                .font(.title3)
            
            FolderOrderingButton(type: .modificationDate)
            FolderOrderingButton(type: .creationDate)
            FolderOrderingButton(type: .alphabetical)
            
            Divider()
            
         FolderAscDecButton(isAscending: true)
            FolderAscDecButton(isAscending: false)
        } label: {
            ChangeableImage(imageSystemName: "arrow.up.arrow.down")
        }
    }
}


struct MemoOrderingMenu: View {
    
    @AppStorage(AppStorageKeys.mOrderType) var mOrderType = OrderType.creationDate
    @AppStorage(AppStorageKeys.mOrderAsc) var mOrderAsc = false
    
    
//    @ObservedObject var memoOrder: MemoOrder
    @ObservedObject var parentFolder: Folder
    
//    @AppStorage("ordering") private(set) var order: Ordering = Ordering(folderType: OrderType.creationDate.rawValue, memoType: OrderType.modificationDate.rawValue, folderAsc: true, memoAsc: false)
    
    var body: some View {
        Menu {
            Text("Memo Ordering")
//            MemoOrderingButton(type: .modificationDate, memoOrder: memoOrder, parentFolder: parentFolder)
            MemoOrderingButton(type: .modificationDate, parentFolder: parentFolder)
            MemoOrderingButton(type: .creationDate, parentFolder: parentFolder)
            MemoOrderingButton(type: .alphabetical, parentFolder: parentFolder)
//            MemoOrderingButton(type: .modificationDate)
//            MemoOrderingButton(type: .creationDate)
//            MemoOrderingButton(type: .alphabetical)
            
            Divider()
            
//            MemoAscDecButtonLabel(isAscending: true, memoOrder: memoOrder, parentFolder: parentFolder)
            MemoAscDecButton(isAscending: true, parentFolder: parentFolder)
//            MemoAscDecButton(isAscending: true)
//            MemoAscDecButtonLabel(isAscending: true, parentFolder: parentFolder)
            
//            MemoAscDecButtonLabel(isAscending: false, memoOrder: memoOrder, parentFolder: parentFolder)
            MemoAscDecButton(isAscending: false, parentFolder: parentFolder)
//            MemoAscDecButton(isAscending: false)
//            MemoAscDecButtonLabel(isAscending: false, parentFolder: parentFolder)
            
        } label: {
            ChangeableImage(imageSystemName: "arrow.up.arrow.down")
        }
    }
}
