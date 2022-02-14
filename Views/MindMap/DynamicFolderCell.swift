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
    
    var level: Int
    var numOfSubfolders: String{
        
        if folder.subfolders.count != 0 {
            return "\(folder.subfolders.count)"
        }
        return ""
    }
    
    var body: some View {
        NavigationLink(destination: FolderView(currentFolder: folder)
                        .environmentObject(memoEditVM)
                        .environmentObject(folderEditVM)
                        .environmentObject(memoOrder)
        ) {
            TitleWithLevelView(folder: folder, level: level)
        } // end of NavigationLink
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            
            // REMOVE
            Button {
                Folder.delete(folder)
                context.saveCoreData()
            } label: {
                ChangeableImage(imageSystemName: "trash")
            }
            .tint(.red)
            
            // RELOCATE FOLDER
            Button {
                UIView.setAnimationsEnabled(false)
                folderEditVM.shouldShowSelectingView = true
                folderEditVM.folderToCut = folder
            } label: {
                ChangeableImage(imageSystemName: "arrowshape.turn.up.right.fill")
            }
            .tint(.green)
        }
    }
}
