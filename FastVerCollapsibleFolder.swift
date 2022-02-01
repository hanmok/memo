//
//  FastVerCollapsibleFolder.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/25.
//

import SwiftUI
import CoreData
struct FastVerCollapsibleFolder: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    @EnvironmentObject var folderEditVM: FolderEditViewModel
    
    //    let siblingSpacing: CGFloat = 3
    //    let parentSpacing: CGFloat = 3
    //    let basicSpacing: CGFloat = 2
//    @State var showSelectingFolderView = false
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
            ) {
                TitleWithLevelView(level: level, folder: folder)
                
            } // end of NavigationLink
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {

                // remove !
                Button {
                    Folder.delete(folder)
                    context.saveCoreData()
                } label: {
                    ChangeableImage(imageSystemName: "trash")
                }
                .tint(.red)

                // change Folder location
                Button {
                    folderEditVM.shouldShowSelectingView = true
                    folderEditVM.folderToCut = folder

                } label: {
                    ChangeableImage(imageSystemName: "arrowshape.turn.up.right.fill")
                }
                .tint(.green)

                // change Folder Name
                Button {
                    folderEditVM.shouldChangeFolderName = true
                    folderEditVM.selectedFolder = folder
                } label: {
                    ChangeableImage(imageSystemName: "pencil")
                }
                .tint(.yellow)
            }

    }
}
