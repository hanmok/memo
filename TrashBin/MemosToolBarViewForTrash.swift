//
//  MemosToolBarViewForTrash.swift
//  DeeepMemo (iOS)
//
//  Created by Mac mini on 2022/03/02.
//


import SwiftUI
import CoreData

struct MemosToolBarViewForTrash: View {
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var memoEditVM : MemoEditViewModel
    @ObservedObject var currentFolder: Folder

    @Binding var isShowingSelectingFolderView: Bool
    @Binding var isShowingDeleteAlert: Bool

    let spacingBetweenButtons: CGFloat = 16
    
    
    var body: some View {
        HStack(spacing: spacingBetweenButtons) {
            
            
            Button {
                memoEditVM.initSelectedMemos()
            } label: {
                UnchangeableImage(imageSystemName: "arrow.clockwise", width: 20, height: 20)
            }

            Button {
                // select All
                memoEditVM.add(memos: currentFolder.memos.sorted())
                
            } label: {
                UnchangeableImage(imageSystemName: "plus.square.on.square", width: 20, height: 20)
            }

         
            // RELOCATE MEMOS, LOOKING FINE
            Button(action: {
                isShowingSelectingFolderView = true
            }) {
                UnchangeableImage(imageSystemName: "folder")
            }
            
            // REMOVE ACTION, WORKS FINE
            Button(action: {
                isShowingDeleteAlert = true
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
