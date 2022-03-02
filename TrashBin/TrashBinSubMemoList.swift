//
//  FilteredMemoList.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/18.
//

import SwiftUI

struct TrashBinSubMemoList: View {
    
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    @EnvironmentObject var folderEditVM: FolderEditViewModel
    @EnvironmentObject var trashBinVM: TrashBinViewModel
    
    @ObservedObject var folder: Folder
    
    @GestureState var isDragging = false

    @State var isOnDraggingAction = false

    @State var draggingMemo: Memo? = nil
    
    @State var oneOffset: CGFloat = 0
    
    var body: some View {
        
        let memosToShow = Memo.sortMemos(memos: folder.memos.sorted())
        
        return ZStack {
            
            VStack { // without this, views stack on other memos
                Section {
                    
                    ForEach(memosToShow, id: \.self) { memo in
                        NavigationLink(destination:
                                       TrashMemoView(memo: memo, parent: memo.folder!)
                                        .environmentObject(memoEditVM)
                                        .environmentObject(folderEditVM)
                        ) {
                            MemoBoxView(memo: memo)
                                .frame(width: UIScreen.screenWidth - 20, alignment: .center)
                                .offset(x: draggingMemo == memo ? oneOffset : 0)
                                .background {
                                    ZStack {
                                        Color(isOnDraggingAction ? .memoBoxSwipeBGColor : .white)
                                            .frame(width: UIScreen.screenWidth  - 2 * Sizes.overallPadding - 2)
                                            .cornerRadius(10)
                                        HStack {
                                            Spacer()
                                            SystemImage("checkmark")
                                                .frame(width: 65)
                                                .foregroundColor(.basicColors)
                                                .opacity(isOnDraggingAction ? 1 : 0)
                                        }
                                    }
                                    .padding(.horizontal, Sizes.smallSpacing)
                                    .frame(width: UIScreen.screenWidth  - 2 * Sizes.overallPadding - 2 )
                                }

                                .gesture(DragGesture()
                                            .updating($isDragging, body: { value, state, _ in
                                    state = true
                                    onChanged(value: value, memo: memo)
                                }).onEnded({ value in
                                    onEnd(value: value, memo: memo)
                                }))
                        } // end of ZStack
                            .disabled(memoEditVM.isSelectionMode)

                            .gesture(DragGesture()
                                        .updating($isDragging, body: { value, state, _ in
                                state = true
                                onChanged(value: value, memo: memo)
                            }).onEnded({ value in
                                onEnd(value: value, memo: memo)
                            }))
                        
                        .simultaneousGesture(TapGesture().onEnded{
                            print("Tap pressed!")

                            if memoEditVM.isSelectionMode {
                                print("Tap gesture triggered!")
                                memoEditVM.dealWhenMemoSelected(memo)
                            }
                        })
                    } // end of ForEach
                }
            } // end of VStack
        } // end of ZStack
    }
    
    func onChanged(value: DragGesture.Value, memo: Memo) {
        
        DispatchQueue.main.async {
            
            draggingMemo = memo
            
        }
            print("onChanged triggered")
            
            if isDragging && value.translation.width < -5 {

                DispatchQueue.main.async {
                    isOnDraggingAction = true
                }
            }
            
            
            if isDragging && value.translation.width < 0 {
                
                print("dragged value: \(value.translation.width)")
                switch value.translation.width {
                case let width where width <= -65:
                    DispatchQueue.main.async {
                        oneOffset = -65
                    }
                default:
                    DispatchQueue.main.async {
                        oneOffset = value.translation.width
                    }
                }
            }
        print("isDraggingAction: \(isOnDraggingAction)")
        }
    
    func onEnd(value: DragGesture.Value, memo: Memo) {
        withAnimation {
            print("onEnd triggered")
            if value.translation.width <= -65 {
                
                DispatchQueue.main.async {
                    memoEditVM.isSelectionMode = true
                    memoEditVM.dealWhenMemoSelected(memo)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    
                    oneOffset = 0
                    
                    isOnDraggingAction = false
                }
                
            } else {
                DispatchQueue.main.async {
                    oneOffset = 0
                    isOnDraggingAction = false
                }
            }
        }
        draggingMemo = nil
    }
}
