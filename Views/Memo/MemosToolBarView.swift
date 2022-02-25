//
//  MemosToolBarView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/28.
//

import SwiftUI
import CoreData

struct MemosToolBarView: View {
    
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var memoEditVM : MemoEditViewModel
    @Environment(\.colorScheme) var colorScheme
    @Binding var showSelectingFolderView: Bool
    
    let spacingBetweenButtons: CGFloat = 16
    @Binding var showDeleteAlert: Bool
    @Binding var showColorPalette: Bool
    
    var body: some View {
        HStack(spacing: spacingBetweenButtons) {
            
            
            Button {
                memoEditVM.initSelectedMemos()
            } label: {
                UnchangeableImage(imageSystemName: "arrow.clockwise", width: 20, height: 20)
            }

            
            // PIN BUTTON, WORKS FINE
            Button(action: {
                // default: pin all.
                // 만약 모든게 pin 되어있는 경우에만 모두 unpin
                var allPinned = true
                
                for each in memoEditVM.selectedMemos {
                    if each.pinned == false {
                        allPinned = false
                        break
                    }
                }

                if !allPinned {
                    _ = memoEditVM.selectedMemos.map { $0.pinned = true}
                    
                } else {
                    _ = memoEditVM.selectedMemos.map { $0.pinned = false}
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
