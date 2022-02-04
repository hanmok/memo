//
//  OrderingButton.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/02/01.
//

import SwiftUI
import CoreData


// MARK: - ORDERING BASIC STRUCTURE
enum OrderType: String {
    case modificationDate = "Modification Date"
    case creationDate = "Creation Date"
    case alphabetical = "Alphabetical"
}


// MARK: - FOLDER ORDERING

class FolderOrder: ObservableObject {
    @Published var isAscending = true
    
    @Published var orderType: OrderType = .creationDate
}


struct FolderOrderingButton: View {
    
    var type: OrderType
    @Environment(\.managedObjectContext) var context
    @ObservedObject var folderOrder: FolderOrder
    
    var body: some View {
        
        Button {
            folderOrder.orderType = type
            Folder.orderType = type
            Folder.updateTopFolders(context: context)
        } label: {
            HStack {
                if folderOrder.orderType == type {
                    ChangeableImage(imageSystemName: "checkmark")
                }
                Text(type.rawValue)
            }
        }
    }
}


struct FolderAscDecButton: View {
    var isAscending: Bool
    
    @Environment(\.managedObjectContext) var context
    @ObservedObject var folderOrder: FolderOrder
    
    var body: some View {
        Button {
            folderOrder.isAscending = isAscending
            Folder.isAscending = isAscending
            Folder.updateTopFolders(context: context)
        } label: {
            HStack {
                if folderOrder.isAscending == isAscending {
                    ChangeableImage(imageSystemName: "checkmark")
                }
                Text(isAscending ? "Ascending Order" : "Decending Order")
            }
        }
    }
}


// MARK: - MEMO ORDERING

class MemoOrder: ObservableObject {
    @Published var isAscending = false
    
    @Published var orderType: OrderType = .modificationDate
}

struct MemoOrderingButton: View {

    var type: OrderType
    
    @ObservedObject var memoOrder: MemoOrder
    
    @ObservedObject var parentFolder: Folder
    
    var body: some View {
        
        Button {
            memoOrder.orderType = type
            Memo.orderType = type
            parentFolder.title += "" // update parent
            // but .. it goes back to mindmapView... why ?
            // i don't know ....
        } label: {
            HStack {
                if memoOrder.orderType == type {
                    ChangeableImage(imageSystemName: "checkmark")
                }
                Text(type.rawValue)
            }
        }
    }
}


struct MemoAscDecButtonLabel: View {
    var isAscending: Bool
    @ObservedObject var memoOrder: MemoOrder
    @ObservedObject var parentFolder: Folder
    
    var body: some View {
        Button {
            memoOrder.isAscending = isAscending
            Memo.isAscending = isAscending
            parentFolder.title += ""
        } label: {
            HStack {
                if memoOrder.isAscending == isAscending {
                    ChangeableImage(imageSystemName: "checkmark")
                }
                Text(isAscending ? "Ascending Order" : "Decending Order")
            }
        }
    }
}
