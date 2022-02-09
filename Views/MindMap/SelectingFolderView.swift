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
    
//    @ObservedObject var fastFolderWithLevelGroup: FastFolderWithLevelGroup
    @ObservedObject var folderGroup: FolderGroup
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    @EnvironmentObject var folderEditVM: FolderEditViewModel
    @Environment(\.colorScheme) var colorScheme
    @State var invalidFolderWithLevels: [FolderWithLevel]? = nil
    var isFullScreen: Bool = false
    var body: some View {
        
//        if let invalidFolders = folderEditVM.folderToCut {
//            let some = Folder.getHierarchicalFolders(topFolders: [invalidFolders])
//        }
//        if folderEditVM.folderToCut != nil {
//            invalidFolderWithLevels = Folder.getHierarchicalFolders(topFolders: [folderEditVM.folderToCut!])
//        }
        
        return VStack(spacing: 0) {
            HStack {
                Spacer()
                Text("Select Folder ")
                    .frame(maxWidth: .infinity, alignment: .center)
                //                .padding(.leading, Sizes.overallPadding)
                    .padding(.vertical)
                
                
            }.overlay {
                if isFullScreen {
                    HStack {
                        Spacer()
                        Button {
                            // DISMISS
                            presentationMode.wrappedValue.dismiss()
                            UIView.setAnimationsEnabled(true)
                        } label: {
                            ChangeableImage(imageSystemName: "multiply")
                        }
                        .padding(.trailing, Sizes.overallPadding)
                    }
                }
            }
            
            List(folderGroup.realFolders, id: \.self) { folder in
                //                if folderWithLevel != fastFolderWithLevelGroup.allFolders.last {
                
                Button {
                    print("flag 1")
                    // Select Target Folder to be pasted First.
                    folderEditVM.folderToPaste = folder
                    
                    if folderEditVM.folderToCut != nil {
                        
                            invalidFolderWithLevels = Folder.getHierarchicalFolders(topFolders: [folderEditVM.folderToCut!])
                        
                        if Folder.convertLevelIntoFolder(invalidFolderWithLevels!).contains(where: { $0 == folderEditVM.folderToPaste}) == true {
                            // INVALIDATE ACTION WHEN PASTED FOLDER IS UNDER CUTTED FOLDER, invalidate action !
                            folderEditVM.folderToCut = nil
                        }
                    }
                    
                    
                    // move only when cutted folder and paste target folder are different.
                    
                    if folderEditVM.folderToCut == folderEditVM.folderToPaste {
                        print("flag 2")
                        folderEditVM.folderToCut = nil
                    } else {
                        
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
                    }
                    print("flag 5")
                    context.saveCoreData()
                    
                    folderEditVM.folderToPaste = nil
                    // do we need it ..?? unnecessary.
                    //                    Folder.updateTopFolders(context: context)
                    
                    presentationMode.wrappedValue.dismiss()
                    
                } label: {
                    if folder == folderEditVM.folderToCut || folder == memoEditVM.parentFolder{
//                        TitleWithLevelView(
//                            folder: folderWithLevel.folder,
//                            level: folderWithLevel.level,
//                            shouldHideArrow: true)
                        FolderTitleWithStar(folder: folder)
                            .tint(colorScheme == .dark ? Color(white: 0.2) : Color(white: 0.8))
                            .background(colorScheme.adjustSubColors())
                        
                    } else {
//                    TitleWithLevelView(
//                        folder: folderWithLevel.folder,
//                        level: folderWithLevel.level,
//                        shouldHideArrow: true)
                        FolderTitleWithStar(folder: folder)
                            
                    }
                }
            } // end of List
        }
        .onDisappear {
            UIView.setAnimationsEnabled(true)
        }
    }
}
