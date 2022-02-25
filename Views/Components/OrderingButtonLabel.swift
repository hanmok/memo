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
    
    var body: some View {
        
        Button {
            folderOrderType = type
            Folder.updateTopFolders(context: context)
        } label: {
            HStack {
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
    
    @AppStorage(AppStorageKeys.fOrderAsc) var folderOrderAsc = false
    
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
                Text(isAscending ? "Ascending Order" : "Decending Order")
            }
        }
    }
}


// MARK: - MEMO ORDERING



struct MemoOrderingButton: View {

    @AppStorage(AppStorageKeys.mOrderType) var mOrderType = OrderType.modificationDate
    
    var type: OrderType
    
    @ObservedObject var parentFolder: Folder
    
    var body: some View {
        
        Button {
            mOrderType = type
            
            parentFolder.title += "" // update parent
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
    @Environment(\.managedObjectContext) var context
    
    @AppStorage(AppStorageKeys.mOrderAsc) var mOrderAsc = false
    
    @ObservedObject var parentFolder: Folder
    
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
                Text(isAscending ? "Ascending Order" : "Decending Order")
            }
        }
    }
}

struct FolderOrderingMenu: View {
    @ObservedObject var folderOrder: FolderOrder
  
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
            SystemImage( "arrow.up.arrow.down")
                .tint(Color.navBtnColor)
        }
    }
}


struct MemoOrderingMenu: View {
    @ObservedObject var memoOrder: MemoOrder
    @ObservedObject var parentFolder: Folder
    
    var body: some View {
        Menu {
            Text("Memo Ordering")
            MemoOrderingButton(type: .modificationDate, parentFolder: parentFolder)
            MemoOrderingButton(type: .creationDate, parentFolder: parentFolder)
            MemoOrderingButton(type: .alphabetical, parentFolder: parentFolder)
            


            Divider()
            
            MemoAscDecButton(isAscending: true, parentFolder: parentFolder)
            MemoAscDecButton(isAscending: false, parentFolder: parentFolder)
            
        } label: {
            SystemImage( "arrow.up.arrow.down")
                .tint(Color.navBtnColor)
        }
    }
}
