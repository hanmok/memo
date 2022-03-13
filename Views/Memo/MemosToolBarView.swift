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
    
    @ObservedObject var currentFolder: Folder
    
    @Binding var showSelectingFolderView: Bool
    
    @Binding var msgToShow: String?
    
    var body: some View {
        HStack(spacing: Sizes.spacingBetweenButtons) {
            
            
            Button {
                memoEditVM.initSelectedMemos()
            } label: {
//                UnchangeableImage(imageSystemName: "arrow.clockwise", width: 20, height: 20)
                UnchangeableImage(imageSystemName: "multiply", width: 18, height: 18)
            }

            Button {
                // select All
                memoEditVM.add(memos: currentFolder.memos.sorted())
                
            } label: {
                Text("All")
                    .font(.headline)
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
                    _ = memoEditVM.selectedMemos.map { $0.isBookMarked = true}
                    msgToShow = Messages.showBookmarkedMsg(memoEditVM.count)
                } else {
                    _ = memoEditVM.selectedMemos.map { $0.isBookMarked = false}
                    msgToShow = Messages.showUnbookmarkedMsg(memoEditVM.count)
                }
                
                context.saveCoreData()
                print("pinned button pressed")
                
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
                    _ = memoEditVM.selectedMemos.map { $0.isPinned = true}
                    msgToShow = Messages.showPinnedMsg(memoEditVM.count)
                } else {
                    _ = memoEditVM.selectedMemos.map { $0.isPinned = false}
                    msgToShow = Messages.showUnpinnedMsg(memoEditVM.count)
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
                _ = memoEditVM.selectedMemos.map { Memo.makeNotBelongToFolder($0, trashBinVM.trashBinFolder)}
                msgToShow = Messages.showMemoMovedToTrash(memoEditVM.count)
                memoEditVM.initSelectedMemos()
//                Folder.updateTopFolders(context: context)
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
