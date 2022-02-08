//
//  SelectingFolderView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/28.
//

import SwiftUI
import CoreData

struct SelectingFolderView: View {
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var fastFolderWithLevelGroup: FastFolderWithLevelGroup
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    @EnvironmentObject var folderEditVM: FolderEditViewModel
    
    
    var body: some View {
        return VStack {
            
            Text("Select Folder ")
                .padding(.leading, Sizes.overallPadding)
                .padding(.vertical)
            
            List(fastFolderWithLevelGroup.allFolders, id: \.self) { folderWithLevel in
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
                    TitleWithLevelView(
                        folder: folderWithLevel.folder,
                        level: folderWithLevel.level,
                        shouldHideArrow: true)
                }
            } // end of List
        }
    }
}
