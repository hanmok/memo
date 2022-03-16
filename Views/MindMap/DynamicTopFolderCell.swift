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
    
//    @EnvironmentObject var memoEditVM: MemoEditViewModel
//    @EnvironmentObject var folderEditVM: FolderEditViewModel
//    @EnvironmentObject var memoOrder: MemoOrder
    @EnvironmentObject var trashBinVM: TrashBinViewModel
    
    @ObservedObject var folder: Folder
    
    var level: Int
    
    var body: some View {
        NavigationLink(destination: FolderView(currentFolder: folder)
//                        .environmentObject(memoEditVM)
//                        .environmentObject(folderEditVM)
//                        .environmentObject(memoOrder)
                        .environmentObject(trashBinVM)
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
