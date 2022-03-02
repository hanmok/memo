//
//  FilteredMemoList.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/18.
//

import SwiftUI


enum MemoListType: String {
    case pinned
    case unpinned
    case all
}

//class MemosViewModel : ObservableObject {
//    @Published var memos: [Memo]
//    @Published var folder: Folder
//    @Published var offsets: [CGFloat]
//
//    init(folder : Folder, type: MemoListType) {
//        self.folder = folder
//        var sortedMemos = [Memo]()
//        switch type {
//        case .pinned:
//            sortedMemos = Memo.sortMemos(memos: folder.memos.filter { $0.pinned == true || $0.isBookMarked == true })
//
//        case .unpinned:
//            sortedMemos = Memo.sortMemos(memos: folder.memos.filter { $0.pinned == false && $0.isBookMarked == false })
//
//        case .all:
//            sortedMemos = Memo.sortMemos(memos: folder.memos.sorted())
//        }
//        self.memos = sortedMemos
//
//        self.offsets = [CGFloat].init(repeating: 0, count: sortedMemos.count)
//    }
//}

struct FilteredMemoList: View {
    
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    @EnvironmentObject var folderEditVM: FolderEditViewModel
    @EnvironmentObject var trashBinVM: TrashBinViewModel
    
//    @ObservedObject var trashBinFolder: Folder
    @ObservedObject var folder: Folder
//    @ObservedObject var memosVM: MemosViewModel
    var listType: MemoListType
    @GestureState var isDragging = false
    /// dragging flag end a little later than isDragging, to complete onEnd Action (for Better UX)
    @State var isDraggingAction = false
    @State var draggingIndex = -1
    @State var oneOffset: CGFloat = 0
    
    var body: some View {
        
        var memosToShow = [Memo]()
        
        
        switch listType {
        case .pinned:
            memosToShow = Memo.sortMemos(memos: folder.memos.filter { $0.pinned || $0.isBookMarked })
        case .unpinned:
                memosToShow = Memo.sortMemos(memos: folder.memos.filter {$0.pinned == false && $0.isBookMarked == false})
        case .all:
            memosToShow = Memo.sortMemos(memos: folder.memos.sorted())
        }
        
        return ZStack {
            
            VStack { // without this, views stack on other memos
                Section {
                    
//                    ForEach(memosVM.memos, id: \.self) { memo in
//                    ForEach(memosVM.memos.indices, id: \.self) { index in
                    ForEach(memosToShow.indices, id: \.self) { index in
                    
                            
                        
                        NavigationLink(destination:
//                                        MemoView(memo: memo, parent: memo.folder!, presentingView:
//                                       MemoView(memo: memosVM.memos[index], parent: memosVM.memos[index].folder!, presentingView:.constant(false))
                                       MemoView(memo: memosToShow[index], parent: memosToShow[index].folder!, presentingView:.constant(false))
                                        .environmentObject(memoEditVM)
                                        .environmentObject(folderEditVM)
                        ) {
                            MemoBoxView(memo: memosToShow[index])
                                .frame(width: UIScreen.screenWidth - 20, alignment: .center)
//                                .offset(x: memosVM.offsets[index])
                                .offset(x: index == draggingIndex ? oneOffset : 0)
//                                .animation(.spring(), value: isDraggingAction)
                                .background {
                                    ZStack {
//                                        Color(isDraggingAction ? .memoBoxSwipeBGColor : .blackAndWhite)
                                        Color(isDraggingAction ? .memoBoxSwipeBGColor : .white)
                                            .frame(width: UIScreen.screenWidth  - 2 * Sizes.overallPadding - 2)
                                            .cornerRadius(10)
                                        HStack {
                                            Spacer()
                                            SystemImage("checkmark")
                                                .frame(width: 65)
                                                .foregroundColor(.basicColors)
                                                .opacity(isDraggingAction ? 1 : 0)
                                        }
                                    }
                                    .padding(.horizontal, Sizes.smallSpacing)
                                    .frame(width: UIScreen.screenWidth  - 2 * Sizes.overallPadding - 2 )
                                }

                                .gesture(DragGesture()
                                            .updating($isDragging, body: { value, state, _ in
                                    state = true
//                                    onChanged(value: value, memo: memo)
                                    onChanged(value: value, index: index)
                                }).onEnded({ value in
//                                    onEnd(value: value, memo: memo)
                                    onEnd(value: value, index: index, memo: memosToShow[index])
                                }))
                        } // end of ZStack
                            .disabled(memoEditVM.isSelectionMode)

                            .gesture(DragGesture()
                                        .updating($isDragging, body: { value, state, _ in
                                state = true
                                onChanged(value: value, index: index)
//                                onChanged(value: value, memo: memo)
                            }).onEnded({ value in
//                                onEnd(value: value, memo: memo)
                                onEnd(value: value, index: index, memo: memosToShow[index])
                            }))
                        
                        .simultaneousGesture(TapGesture().onEnded{
                            print("Tap pressed!")

                            if memoEditVM.isSelectionMode {
                                print("Tap gesture triggered!")
//                                memoEditVM.dealWhenMemoSelected(memo)
                                memoEditVM.dealWhenMemoSelected(memosToShow[index])
                            }

                        })
                        
                    } // end of ForEach
                } header: {
                    VStack {
                        HStack {
                            if listType == .pinned {
                                HStack {
                                    SystemImage("bookmark.fill", size: 16)
                                        .tint(Color.navBtnColor)
                                        .frame(alignment: .topLeading)
                                        .padding(.leading, Sizes.overallPadding + 4)
                                
                                    SystemImage("pin.fill", size: 16)
                                        .tint(Color.navBtnColor)
                                        .frame(alignment: .topLeading)
                                        .rotationEffect(.degrees(45))
                                }
                            }
                            Spacer()
                        }
                    }
                }
            } // end of VStack
        } // end of ZStack
    }
    
//    func onChanged(value: DragGesture.Value, memo: Memo) {
    func onChanged(value: DragGesture.Value, index: Int) {
//        withAnimation {
        DispatchQueue.main.async {
            draggingIndex = index
            
        }
            print("onChanged triggered")
            
            if isDragging && value.translation.width < -5 {

                DispatchQueue.main.async {
                    isDraggingAction = true
                }
            }
            
            
            if isDragging && value.translation.width < 0 {
                
                print("dragged value: \(value.translation.width)")
                switch value.translation.width {
                case let width where width <= -65:
                    DispatchQueue.main.async {

//                        memo.offset = -65
//                        memosVM.offsets[index] = -65
                        oneOffset = -65
                    }
                default:
                    DispatchQueue.main.async {
//                        memo.offset = value.translation.width
//                        memosVM.offsets[index] = value.translation.width
                        oneOffset = value.translation.width
//                        print("memo.offset: \(memo.offset)")
                    }
                }
            }
        print("isDraggingAction: \(isDraggingAction)")
        }
//    }
    
    func onEnd(value: DragGesture.Value, index: Int, memo: Memo) {
//    func onEnd(value: DragGesture.Value, memo: Memo) {
        withAnimation {
            print("onEnd triggered")
            if value.translation.width <= -65 {
                
                DispatchQueue.main.async {
                    memoEditVM.isSelectionMode = true
//                    memoEditVM.dealWhenMemoSelected(memo)
                    memoEditVM.dealWhenMemoSelected(memo)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    
//                    memosVM.offsets[index] = 0
                    
                    oneOffset = 0
                    
                    isDraggingAction = false
                }
                
            } else {
                DispatchQueue.main.async {

                    
//                    memosVM.offsets[index] = 0
                    oneOffset = 0
                    isDraggingAction = false
                }
            }
        }
        
        draggingIndex = -1
    }
}

