//
//  MemosToolBarView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/28.
//

import SwiftUI
import CoreData
// need connection to FolderView.
// maybe.. onReive necessary.
struct MemosToolBarView: View {
    
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var memoEditVM : MemoEditViewModel
    @Environment(\.colorScheme) var colorScheme
    @Binding var showSelectingFolderView: Bool
//    let spacingBetweenButtons: CGFloat = 12
    let spacingBetweenButtons: CGFloat = 16
    @Binding var showDeleteAlert: Bool
    @Binding var showColorPalette: Bool
    
    var body: some View {
        HStack(spacing: spacingBetweenButtons) {
            

            Button {
                // DESELECT ALL
//                memoEditVM.selectedMemos.removeAll()
                memoEditVM.initSelectedMemos()
            } label: {
//                ChangeableImage(imageSystemName: "arrow.clockwise", width: 20, height: 20)
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
//                ChangeableImage(imageSystemName: "pin", width: 20, height: 20)
                UnchangeableImage(imageSystemName: "pin", width: 20, height: 20)
            }
            .cornerRadius(5)
            
            
            
            // RELOCATE MEMOS, LOOKING FINE
            Button(action: {
                showSelectingFolderView = true
                
            }) {
//                ChangeableImage(imageSystemName: "folder")
                UnchangeableImage(imageSystemName: "folder")
            }
//            .padding(5)
            
            
            // MARK: - 보류 : Combine , Change Color
//            Button {
//                // combine memos
//                memoEditVM.initSelectedMemos()
//            } label: {
//                ChangeableImage(imageSystemName: "text.badge.plus")
//            }
//
//
//
            // CHANGE COLOR
//            Button(action: {changeColorAction(sortedMemos)}) {
            
//            Button(action: {
//                showColorPalette = true
////                memoEditVM.initSelectedMemos()
//            }) {
////                ChangeableImage(imageSystemName: "eyedropper.halffull",width: 20, height: 20)
//                ColorPickerView()
//            }
//            .padding(5)
//            .cornerRadius(5)
            
            
            
            // REMOVE ACTION, WORKS FINE
            Button(action: {

                showDeleteAlert = true
            }) {
//                ChangeableImage(imageSystemName: "trash", width: 20, height: 20)
                UnchangeableImage(imageSystemName: "trash", width: 20, height: 20)
            }
            .cornerRadius(5)
        } // end of HStack
        .tint(.black)
        .padding(.horizontal, Sizes.overallPadding)
        .padding(.vertical, 10)
//        .background(colorScheme.adjustSubColors())
//        .background(Color(UIColor(named: "mainColor")!))
//        .background(colorScheme.adjustMainColors())
        .background(colorScheme.adjustSubColors())
        .cornerRadius(10)
    }
}

//struct MemosToolBarView_Previews: PreviewProvider {
//    static var previews: some View {
//        MemosToolBarView()
//            .previewLayout(.sizeThatFits)
//    }
//}
