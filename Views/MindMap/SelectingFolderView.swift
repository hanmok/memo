//
//  SelectingFolderView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/28.
//

import SwiftUI
import CoreData

struct SelectingFolderView: View {
    
    @ObservedObject var fastFolderWithLevelGroup: FastFolderWithLevelGroup
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    @EnvironmentObject var folderEditVM: FolderEditViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        return VStack {
            
            Text("Select Folder ")
                .padding(.leading, Sizes.overallPadding)
                .padding(.vertical)
            
            List(fastFolderWithLevelGroup.allFolders) { folderWithLevel in
                //                if folderWithLevel != fastFolderWithLevelGroup.allFolders.last {
                
                Button {
                    
                    folderEditVM.folderToPaste = folderWithLevel.folder
                    
                    // move only when cutted folder and paste target folder are different.
                    // if same, do nothing but set both to nil
                    if folderEditVM.folderToCut != folderEditVM.folderToPaste {
                        
                        if folderEditVM.folderToCut != nil {
                            folderEditVM.folderToPaste!.add(subfolder: folderEditVM.folderToCut!)
                            folderEditVM.folderToCut = nil
                        } else {
//                            memoEditVM.selectedMemos
                            for memo in memoEditVM.selectedMemos.sorted() {
                                folderEditVM.folderToPaste?.add(memo: memo)
                            }
                            memoEditVM.initSelectedMemos()
                        }
                    }
                    
                    context.saveCoreData()
                    
                    folderEditVM.folderToPaste = nil
                    
                    Folder.updateTopFolders(context: context)
                    
                    presentationMode.wrappedValue.dismiss()
                    
                } label: {
                    SelectingCollapsibleFolder(folder: folderWithLevel.folder, level: folderWithLevel.level)
                }
            } // end of List
        }
    }
}



struct SelectingCollapsibleFolder: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @ObservedObject var folder: Folder
    
    var level: Int
    var numOfSubfolders: String{
        if folder.subfolders.count != 0 {
            return "\(folder.subfolders.count)"
        }
        return ""
    }
    
    var body: some View {
        HStack {
            ForEach(0 ..< level + 1) { _ in
                Text("  ")
            }
            
            Text(folder.title)
                .foregroundColor(colorScheme.adjustTint())
            
            if folder.isFavorite {
                Text(Image(systemName: "star.fill"))
                    .tint(.yellow) // why not working ?
            }
            
            EmptyView()
                .background(.white)
        }
    }
    
}
