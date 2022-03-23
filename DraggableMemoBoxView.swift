//
//  DraggableMemoBoxView.swift
//  DeeepMemo (iOS)
//
//  Created by Mac mini on 2022/03/24.
//

import SwiftUI

class DraggableViewModel: ObservableObject {
    @Published var draggingMemo: Memo? = nil
    @Published var oneOffset: CGFloat = 0
}

struct DraggableMemoBoxView: View {

    let memo: Memo
    
    @EnvironmentObject var dragVM: DraggableViewModel
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    
    @GestureState var isDragging = false
    
    @State var isOnDraggingAction = false
    
    var body: some View {
        NavigationLink(destination:
                        MemoView(memo: memo, parent: memo.folder!, presentingView:.constant(false))
        ) {
            MemoBoxView(memo: memo)
                .frame(width: UIScreen.screenWidth - 20, alignment: .center)
                .offset(x: dragVM.draggingMemo == memo ? dragVM.oneOffset : 0)
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
        }
        .padding(.bottom, Sizes.spacingBetweenMemoBox * 2)
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
        
        
    }
    
    func onEnd(value: DragGesture.Value, memo: Memo) {
        withAnimation {
            if value.translation.width <= -65 {
                
                DispatchQueue.main.async {
                    memoEditVM.isSelectionMode = true
                    memoEditVM.dealWhenMemoSelected(memo)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    
//                    oneOffset = 0
                    dragVM.oneOffset = 0
                    
                    isOnDraggingAction = false
                }
                
            } else {
                DispatchQueue.main.async {
//                    oneOffset = 0
                    dragVM.oneOffset = 0
                    isOnDraggingAction = false
                }
            }
        }
//        draggingMemo = nil
        dragVM.draggingMemo = nil
    }
    
    func onChanged(value: DragGesture.Value, memo: Memo) {
        DispatchQueue.main.async {
//            draggingMemo = memo
            dragVM.draggingMemo = memo
            
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
                    
//                    oneOffset = -65
                    dragVM.oneOffset = -65
                }
            default:
                DispatchQueue.main.async {
//                    oneOffset = value.translation.width
                    dragVM.oneOffset = value.translation.width
                }
            }
        }
    }
    
    
}
