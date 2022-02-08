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
    
    @Binding var showSelectingFolderView: Bool
//    let spacingBetweenButtons: CGFloat = 12
    let spacingBetweenButtons: CGFloat = 16
    
    var body: some View {
        HStack(spacing: spacingBetweenButtons) {
            
            

            // PIN BUTTON, WORKS FINE
            Button(action: {
// 로직이 좀 이상한데 ? 기본적으로 pin 시킴.
                // 만약 모든게 pin 되어있는 경우에만 모두 unpin
                var allPinned = true
                for each in memoEditVM.selectedMemos {
                    if each.pinned == false {
                        allPinned = false
                        break
                    }
                }

                if !allPinned {
                    for each in memoEditVM.selectedMemos {
                        each.pinned = true
                    }
                } else {
                    for each in memoEditVM.selectedMemos {
                        each.pinned = false
                    }
                }
                
                context.saveCoreData()
                print("pinned button pressed")
                
                memoEditVM.initSelectedMemos()
            }) {
                ChangeableImage(imageSystemName: "pin", width: 20, height: 20)
            }
            .cornerRadius(5)
            
            
            
            // RELOCATE MEMOS, LOOKING FINE
            Button(action: {
                showSelectingFolderView = true
//                for each in memoEditVM.selectedMemos {
//                    memoEditVM.didCutMemos.append(each)
                    // show up mindmapView !
//                }
//                memoEditVM.initSelectedMemos()
            }) {
                ChangeableImage(imageSystemName: "folder")
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
//            // CHANGE COLOR
////            Button(action: {changeColorAction(sortedMemos)}) {
//            Button(action: {
//                memoEditVM.initSelectedMemos()
//            }) {
//                ChangeableImage(imageSystemName: "eyedropper.halffull",width: 20, height: 20)
//            }
//            .padding(5)
//            .cornerRadius(5)
            
            
            
            // REMOVE ACTION, WORKS FINE
//            Button(action: {removeAction(sortedMemos)}) {
            
            Button(action: {
                for each in memoEditVM.selectedMemos {
                    Memo.delete(each)
                }
                context.saveCoreData()
                memoEditVM.initSelectedMemos()
            }) {
                ChangeableImage(imageSystemName: "trash", width: 20, height: 20)
            }
            .cornerRadius(5)
        } // end of HStack
        .padding(.horizontal, Sizes.overallPadding)
        .padding(.vertical, 10)
        .background(Color.subColor)
        .cornerRadius(10)
    }
}

//struct MemosToolBarView_Previews: PreviewProvider {
//    static var previews: some View {
//        MemosToolBarView()
//            .previewLayout(.sizeThatFits)
//    }
//}
