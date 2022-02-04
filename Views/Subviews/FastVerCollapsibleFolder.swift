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
                TitleWithLevelView(folder: folder, level: level)
                
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
//            .swipeActions(edge: .leading, allowsFullSwipe: true) {
//                Button {
//                    let counts = folder.subfolders.count
//                    let newFolder = Folder(title: "under level\(counts + 1)", context: context)
//                    
//                    folder.add(subfolder: newFolder)
//                    context.saveCoreData()
//                    folder.title += ""
//                    Folder.updateTopFolders(context: context)
//                        
//                } label: {
//                    Text("under")
//                }
//                
//                Button {
//                    var counts = 0
//                    if folder.parent != nil { // has parent -> get subFolders' count
//                        counts = folder.parent!.subfolders.count
//                    } else { // has no parent -> get topFolders' count
//                        if let topFolders = try? context.fetch(Folder.topFolderFetch()) {
//                            counts = topFolders.count
//                            
//                        } else {
//                            counts = 100
//                        }
//                        print("topFolder counts: \(counts)")
//                        
//                        
//                    }
//                    
//                    let newFolder = Folder(title: "same level\(counts)", context: context)
//                    
//                    if folder.parent != nil { // has parent
//                        folder.parent!.add(subfolder: newFolder)
//                    }
//                    
//                    context.saveCoreData()
//                    folder.title += ""
//                    
//                } label: {
//                    Text("same")
//                }
//
//            }

    }
}
