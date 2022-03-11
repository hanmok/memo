////
////  SwipeableMemoBoxView.swift
////  DeeepMemo (iOS)
////
////  Created by Mac mini on 2022/03/11.
////
//
//import SwiftUI
//
//struct SwipeableMemoBoxView: View {
//
//    @ObservedObject var memo: Memo
//    @EnvironmentObject var memoEditVM: MemoEditViewModel
//    @EnvironmentObject var folderEditVM: FolderEditViewModel
//    @EnvironmentObject var trashBinVM: TrashBinViewModel
//    @Binding var draggingMemo: Memo?
//    @Binding var oneOffset: CGFloat
//    @Binding var isDragging: Bool
//    @Binding var isOnDraggingAction: Bool
////    @Binding var draggingMemo: Memo
//    var onEnd: (DragGesture.Value, Memo) -> Void = { _, _ in }
//    var onChanged: (DragGesture.Value, Memo) -> Void = {_, _ in }
//
//    var body: some View {
//        return NavigationLink(destination:
//                        MemoView(memo: memo, parent: memo.folder!, presentingView:.constant(false))
//                        .environmentObject(memoEditVM)
//                        .environmentObject(folderEditVM)
//                        .environmentObject(trashBinVM)
//        ) {
//            MemoBoxView(memo: memo)
//                .environmentObject(memoEditVM)
//                .frame(width: UIScreen.screenWidth - 20, alignment: .center)
//                .offset(x: draggingMemo == memo ? oneOffset : 0)
//                .background {
//                    ZStack {
//                        Color(isOnDraggingAction ? .memoBoxSwipeBGColor : .white)
//                            .frame(width: UIScreen.screenWidth  - 2 * Sizes.overallPadding - 2)
//                            .cornerRadius(10)
//                        HStack {
//                            Spacer()
//                            SystemImage("checkmark")
//                                .frame(width: 65)
//                                .foregroundColor(.basicColors)
//                                .opacity(isOnDraggingAction ? 1 : 0)
//                        }
//                    }
//                    .padding(.horizontal, Sizes.smallSpacing)
//                    .frame(width: UIScreen.screenWidth  - 2 * Sizes.overallPadding - 2 )
//                }
//
//                .gesture(DragGesture()
//                            .updating($isDragging, body: { value, state, _ in
//                    state = true
//                    onChanged(value: value, memo: memo)
//                }).onEnded({ value in
//                    onEnd(value: value, memo: memo)
//                }))
//        }
//        .padding(.bottom, Sizes.spacingBetweenMemoBox * 2)
//        .disabled(memoEditVM.isSelectionMode)
//        .gesture(DragGesture()
//                    .updating($isDragging, body: { value, state, _ in
//            state = true
//            onChanged(value: value, memo: memo)
//        }).onEnded({ value in
//            onEnd(value: value, memo: memo)
//        }))
//        .simultaneousGesture(TapGesture().onEnded{
//            print("Tap pressed!")
//
//            if memoEditVM.isSelectionMode {
//                print("Tap gesture triggered!")
//                memoEditVM.dealWhenMemoSelected(memo)
//            }
//        })
//    }
//}
