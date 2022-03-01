//
//  FastVerCollapsibleFolder.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/25.
//

import SwiftUI
import CoreData

struct DynamicFolderCell: View {
    
    @Environment(\.managedObjectContext) var context
    
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    @EnvironmentObject var folderEditVM: FolderEditViewModel
    @EnvironmentObject var memoOrder: MemoOrder
    
    @ObservedObject var folder: Folder
    
    @State var showingDeleteAction = false
    
    var level: Int
//    var numOfSubfolders: String{
//
//        if folder.subfolders.count != 0 {
//            return "\(folder.subfolders.count)"
//        }
//        return ""
//    }
    
    var body: some View {
        NavigationLink(destination: FolderView(currentFolder: folder)
                        .environmentObject(memoEditVM)
                        .environmentObject(folderEditVM)
                        .environmentObject(memoOrder)
        ) {
            TitleWithLevelView(folder: folder, level: level)
        } // end of NavigationLink
    }
}

struct TrashBinCell: View {
    
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    @ObservedObject var folder: Folder
    
    var body: some View {
//        Text("trash Bin")
        NavigationLink(destination: TrashBinView(folder: folder)) {
            
            HStack {
            Text("Trash Bin").foregroundColor(.red)
            Spacer()
                Text("\(folder.memos.count)")
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
        }
    }
}


struct TrashBinView: View {
    @ObservedObject var folder: Folder
    
    var body: some View {
        Text(folder.title)
    }
}
