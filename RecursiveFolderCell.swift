//
//  FastVerCollapsibleFolder.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/25.
//

import SwiftUI
import CoreData
struct RecursiveFolderCell: View {
    
    //    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    @EnvironmentObject var folderEditVM: FolderEditViewModel
    @EnvironmentObject var memoOrder: MemoOrder
    //    let siblingSpacing: CGFloat = 3
    //    let parentSpacing: CGFloat = 3
    //    let basicSpacing: CGFloat = 2
    //    @State var showSelectingFolderView = false
    @ObservedObject var folder: Folder
    @EnvironmentObject var allMemosVM: AllMemosViewModel
    var numOfSubfolders: String{
        
        if folder.subfolders.count != 0 {
            return "\(folder.subfolders.count)"
        }
        return ""
    }
    
    var body: some View {
        return ZStack(alignment: .leading) {
            NavigationLink(destination: FolderView(currentFolder: folder)
                            .environmentObject(memoEditVM)
                            .environmentObject(folderEditVM)
                            .environmentObject(memoOrder)
                            .environmentObject(allMemosVM)
            ) {
                EmptyView()
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {

                        // remove !
                        Button {
                            context.saveCoreData()
                        } label: {
                            ChangeableImage(imageSystemName: "trash")
                        }
                        .tint(.red)
                    }

            } // end of NavigationLink
//            .opacity(0)
            FolderTitleWithStar(folder: folder)
        }
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                
                // remove !
                Button {
                    context.saveCoreData()
                } label: {
                    ChangeableImage(imageSystemName: "trash")
                }
                .tint(.red)
                
                // change Folder location
            }
            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                
                // remove !
                Button {
                    context.saveCoreData()
                } label: {
                    ChangeableImage(imageSystemName: "pencil")
                }
                .tint(.red)
                
                // change Folder location
            }
        
    }
}
