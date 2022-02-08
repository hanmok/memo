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
                    print("flag 1")
                    // Select Target Folder to be pasted First.
                    folderEditVM.folderToPaste = folderWithLevel.folder
                    
    // move only when cutted folder and paste target folder are different.
    
                    if folderEditVM.folderToCut != folderEditVM.folderToPaste {
                        print("flag 2")
                        
                        if folderEditVM.folderToCut != nil {
                            folderEditVM.folderToPaste!.add(subfolder: folderEditVM.folderToCut!)
                            folderEditVM.folderToCut = nil
                            print("flag 3")
            // No Folder to Cut Selected. Memo Cut and Paste!
                        } else {
                            print("flag 4")

                            for memo in memoEditVM.selectedMemos.sorted() {
                                folderEditVM.folderToPaste?.add(memo: memo)
                                print("memo to be cut : \(memo.title)")
                            }
                            memoEditVM.initSelectedMemos()
                        }
// if Folder to Cut and Paste are the same, do nothing but set both to nil
                    } else {
                        folderEditVM.folderToCut = nil
                    }
                    print("flag 5")
                    context.saveCoreData()
                    
                    folderEditVM.folderToPaste = nil
                     // do we need it ..?? unnecessary.
//                    Folder.updateTopFolders(context: context)
                    
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
