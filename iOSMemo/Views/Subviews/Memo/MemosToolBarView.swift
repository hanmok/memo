//
//  MemosToolBarView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/28.
//

import SwiftUI
// need connection to FolderView.
// maybe.. onReive necessary.
struct MemosToolBarView: View {
    
    @EnvironmentObject var selMemos: SelectedMemoViewModel
    var sortedMemos: [Memo] {
        selMemos.memos.sorted()
    }
    let spacingBetweenButtons: CGFloat = 12
    
    var pinnedAction: ([Memo]) -> Void = { _ in }
    var cutAction: ([Memo]) -> Void = { _ in }
    var copyAction: ([Memo]) -> Void = { _ in }
    var changeColorAcion: ([Memo]) -> Void = { _ in }
    var removeAction: ([Memo]) -> Void = { _ in }

    
    var body: some View {
        HStack(spacing: spacingBetweenButtons) {
            
            Button(action: {pinnedAction(sortedMemos)}) {
                    ChangeableImage(imageSystemName: "pin",width: 20, height: 20)
                }
                .padding([.leading], 25)
                .padding([.vertical, .trailing], 5)
                
                .cornerRadius(5)
                
            
            Menu {
                Button(action: {copyAction(sortedMemos)}) {
                    Text("copy and paste")
                }
                Button(action: {cutAction(sortedMemos)}) {
                    Text("cut and paste")
                }
            } label: {
                Button(action: {copyAction(sortedMemos)}) {
                        ChangeableImage(imageSystemName: "doc.on.doc",width: 20, height: 20)
                    }
                .padding(5)
            }
            
            Button(action: {changeColorAcion(sortedMemos)}) {
                    ChangeableImage(imageSystemName: "eyedropper.halffull",width: 20, height: 20)
                }
                .padding(5)
                .cornerRadius(5)

            Button(action: {removeAction(sortedMemos)}) {
                    ChangeableImage(imageSystemName: "trash", width: 20, height: 20)
                }
                .padding(.trailing, 25)
                .padding([.leading, .vertical], 5)
                .cornerRadius(5)
        }
//        .padding([.leading, .trailing], 30)
        .frame(width: 170, height: 30, alignment: .center)
        .padding(5)
        .background(.green)
        .cornerRadius(10)

    }
}

struct MemosToolBarView_Previews: PreviewProvider {
    static var previews: some View {
        MemosToolBarView()
            .previewLayout(.sizeThatFits)
    }
}
