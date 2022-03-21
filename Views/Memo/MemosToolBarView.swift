//
//  MemosToolBarView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/28.
//

import SwiftUI
import CoreData

struct MemosToolBarView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var context
    
    @EnvironmentObject var memoEditVM : MemoEditViewModel
    @EnvironmentObject var trashBinVM: TrashBinViewModel
    
    @EnvironmentObject var messageVM: MessageViewModel
    
    @ObservedObject var currentFolder: Folder
    
    @Binding var showSelectingFolderView: Bool
        
    var calledFromSecondView = false
    
    var body: some View {
        HStack(spacing: Sizes.spacingBetweenButtons) {
            
            Button {
                memoEditVM.initSelectedMemos()
            } label: {
                UnchangeableImage(imageSystemName: "multiply", width: 18, height: 18)
            }
            
            
            if !calledFromSecondView {
            Button {
                // select All
                memoEditVM.add(memos: currentFolder.memos.sorted())
                // secondView 에서는, 모든 memo 를 선택해야함. how ?
            } label: {
                Text("All")
                    .font(.headline)
            }
            }
            
            
            // BOOKMARK BUTTON, WORKS FINE
            Button(action: {
                // default: pin all.
                // 만약 모든게 pin 되어있는 경우에만 모두 bookmark
                var allBookmarked = true
                
                for each in memoEditVM.selectedMemos {
                    if each.isBookMarked == false {
                        allBookmarked = false
                        break
                    }
                }

                if !allBookmarked {
                    memoEditVM.selectedMemos.forEach { $0.isBookMarked = true}
                    messageVM.message = Messages.showBookmarkedMsg(memoEditVM.count)
                } else {
                    memoEditVM.selectedMemos.forEach { $0.isBookMarked = false}
                    messageVM.message = Messages.showUnbookmarkedMsg(memoEditVM.count)
                }
                
                context.saveCoreData()
                
                memoEditVM.initSelectedMemos()
                
            }) {
                UnchangeableImage(imageSystemName: "bookmark", width: 20, height: 20)
            }
            .cornerRadius(5)
            
            // PIN BUTTON, WORKS FINE
            Button(action: {
                // default: pin all.
                // 만약 모든게 pin 되어있는 경우에만 모두 unpin
                var allPinned = true
                
                for each in memoEditVM.selectedMemos {
                    if each.isPinned == false {
                        allPinned = false
                        break
                    }
                }

                if !allPinned {
                    memoEditVM.selectedMemos.forEach { $0.isPinned = true}
                    messageVM.message = Messages.showPinnedMsg(memoEditVM.count)
                } else {
                   memoEditVM.selectedMemos.forEach { $0.isPinned = false}
                    messageVM.message = Messages.showUnpinnedMsg(memoEditVM.count)
                }
                
                context.saveCoreData()
                print("pinned button pressed")
                
                memoEditVM.initSelectedMemos()
            }) {
                UnchangeableImage(imageSystemName: "pin", width: 20, height: 20)
            }
            .cornerRadius(5)
            
            // RELOCATE MEMOS, LOOKING FINE
            Button(action: {
                showSelectingFolderView = true
            }) {
                UnchangeableImage(imageSystemName: "folder")
            }
            
            // REMOVE ACTION, WORKS FINE
            Button(action: {
                
                memoEditVM.selectedMemos.forEach { Memo.makeNotBelongToFolder($0, trashBinVM.trashBinFolder)}
                
                messageVM.message = Messages.showMemoMovedToTrash(memoEditVM.count)
                
                memoEditVM.initSelectedMemos()
            }) {
                UnchangeableImage(imageSystemName: "trash", width: 20, height: 20)
            }
            .cornerRadius(5)
        } // end of HStack
        .tint(.black)
        .padding(.horizontal, Sizes.overallPadding)
        .padding(.vertical, 10)
        .background(Color.subColor)
        .cornerRadius(10)
    }
}
