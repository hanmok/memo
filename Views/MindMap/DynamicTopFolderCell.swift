//
//  FastVerCollapsibleFolder.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/25.
//

import SwiftUI
import CoreData

struct DynamicTopFolderCell: View {
    
    @Environment(\.managedObjectContext) var context
    
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    @EnvironmentObject var folderEditVM: FolderEditViewModel
    @EnvironmentObject var memoOrder: MemoOrder
    @ObservedObject var trashBinFolder: Folder
    @ObservedObject var folder: Folder
    
    var level: Int
    var numOfSubfolders: String{
        
        if folder.subfolders.count != 0 {
            return "\(folder.subfolders.count)"
        }
        return ""
    }
    
    var body: some View {
        NavigationLink(destination: FolderView(trashBin: trashBinFolder, currentFolder: folder)
                        .environmentObject(memoEditVM)
                        .environmentObject(folderEditVM)
                        .environmentObject(memoOrder)
        ) {
            TitleWithLevelView(folder: folder, level: level)
        } // end of NavigationLink
        
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            
            Button {
                // DO NOTHING
            } label: {
                ChangeableImage(imageSystemName: "multiply")
            }
            .tint(.gray)
        }
    }
}
