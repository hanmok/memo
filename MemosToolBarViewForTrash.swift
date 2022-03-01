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
    @EnvironmentObject var memoEditVM : MemoEditViewModel
    @ObservedObject var currentFolder: Folder
    @Environment(\.colorScheme) var colorScheme
    @Binding var showSelectingFolderView: Bool
    
    let spacingBetweenButtons: CGFloat = 16
    @Binding var showDeleteAlert: Bool

    
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
                showSelectingFolderView = true
            }) {
                UnchangeableImage(imageSystemName: "folder")
            }
            
            // REMOVE ACTION, WORKS FINE
            Button(action: {
                showDeleteAlert = true
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
