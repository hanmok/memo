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
    //    @EnvironmentObject var selMemos: SelectedMemoViewModel
    @EnvironmentObject var editMemoVM : MemoEditViewModel
    var sortedMemos: [Memo] {
        //        selMemos.memos.sorted()
        editMemoVM.selectedMemos.sorted()
    }
    
    let spacingBetweenButtons: CGFloat = 12
    
    //    var pinnedAction: ([Memo]) -> Void = { _ in }
    //    var cutAction: ([Memo]) -> Void = { _ in }
    //    var copyAction: ([Memo]) -> Void = { _ in }
    //    var changeColorAcion: ([Memo]) -> Void = { _ in }
    //    var removeAction: ([Memo]) -> Void = { _ in }
    
    
    var body: some View {
        HStack(spacing: spacingBetweenButtons) {
            
            
            // PRESS PIN AFTER SELECTING MEMOS
            //            Button(action: {pinnedAction(sortedMemos)}) {
            Button(action: {
                var allPinned = true
                for each in editMemoVM.selectedMemos {
                    if each.pinned == false {
                        allPinned = false
                        break
                    }
                }

                if !allPinned {
                    for each in editMemoVM.selectedMemos {
                        each.pinned = true
                    }
                }
                context.saveCoreData()
            }) {
                ChangeableImage(imageSystemName: "pin",width: 20, height: 20)
            }
            .padding(.leading, 25)
            .padding([.vertical, .trailing], 5)
            .cornerRadius(5)
            
            
            Menu {
                // COPY MEMOS
//                Button(action: {copyAction(sortedMemos)}) {
                Button(action: {
                    for each in editMemoVM.selectedMemos {
                        editMemoVM.didCopyMemos.append(each)
                    }
                }) {
                    Text("copy and paste")
                }
                // CUT MEMOS
//                Button(action: {cutAction(sortedMemos)}) {
                Button(action: {
                    for each in editMemoVM.selectedMemos {
                        editMemoVM.didCutMemos.append(each)
                    }
                }) {
                    Text("cut")
                }
            } label: {
//                Button(action: {copyAction(sortedMemos)}) {
                Button(action: {
                    // should it has some actions.. ??
                }) {
                    ChangeableImage(imageSystemName: "doc.on.doc",width: 20, height: 20)
                }
                .padding(5)
            }
            
            // CHANGE COLOR
//            Button(action: {changeColorAction(sortedMemos)}) {
            Button(action: {}) {
                ChangeableImage(imageSystemName: "eyedropper.halffull",width: 20, height: 20)
            }
            .padding(5)
            .cornerRadius(5)
            
            // REMOVE ACTION
//            Button(action: {removeAction(sortedMemos)}) {
            Button(action: {
                for each in editMemoVM.selectedMemos {
                    Memo.delete(each)
                }
                context.saveCoreData()
            }) {
                ChangeableImage(imageSystemName: "trash", width: 20, height: 20)
            }
            .padding(.trailing, 25)
            .padding([.leading, .vertical], 5)
            .cornerRadius(5)
        }
        .frame(width: 170, height: 30, alignment: .center)
        .padding(5)
        .cornerRadius(10)
        
    }
}

struct MemosToolBarView_Previews: PreviewProvider {
    static var previews: some View {
        MemosToolBarView()
            .previewLayout(.sizeThatFits)
    }
}
