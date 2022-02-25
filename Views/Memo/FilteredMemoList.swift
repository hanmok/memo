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


struct FilteredMemoList: View {
    
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    @EnvironmentObject var folderEditVM: FolderEditViewModel
    @ObservedObject var folder: Folder

    @State var offsets: [CGFloat]
    var listType: MemoListType
    @GestureState var isDragging = false
    /// dragging flag end a little later than isDragging, to complete onEnd Action (for Better UX)
    @State var isDraggingAction = false
    var memosToShow: [Memo]
    
    init(folder: Folder, listType: MemoListType){
        self.folder = folder
        self.listType = listType
        

        
        switch listType {
        case .pinned:
            self.memosToShow = Memo.sortMemos(memos: folder.memos.filter { $0.pinned || $0.isBookMarked })
        case .unpinned:
            self.memosToShow = Memo.sortMemos(memos: folder.memos.filter {$0.pinned == false && $0.isBookMarked == false})
        case .all:
            self.memosToShow = Memo.sortMemos(memos: folder.memos.sorted())
        }
        
        var empty: [CGFloat] = []
        
        for _ in 0 ..< self.memosToShow.count {
            empty.append(0)
        }
        
        self.offsets = empty
        
    }
    var body: some View {
        
//        var memosToShow = [Memo]()
        
        
//        switch listType {
//        case .pinned:
//            memosToShow = Memo.sortMemos(memos: folder.memos.filter { $0.pinned || $0.isBookMarked })
//        case .unpinned:
//            memosToShow = Memo.sortMemos(memos: folder.memos.filter {$0.pinned == false && $0.isBookMarked == false})
//        case .all:
//            memosToShow = Memo.sortMemos(memos: folder.memos.sorted())
//        }
        

        
        return ZStack {
            
            VStack { // without this, views stack on other memos
                Section {
//                    ForEach(memosToShow.indices, id: \.self) { index in
                    ForEach(memosToShow.indices, id: \.self) { index in
                        
                            
                        
                        NavigationLink(destination:
                                        MemoView(memo: memosToShow[index], parent: memosToShow[index].folder!, presentingView: .constant(false))
                                        .environmentObject(memoEditVM)
                                        .environmentObject(folderEditVM)
                        ) {
                            MemoBoxView(memo: memosToShow[index])
                                .frame(width: UIScreen.screenWidth - 20, alignment: .center)
                                .offset(x: offsets[index])
//                                .animation(.spring(), value: isDragging)
                                .background {
                                    ZStack {
                                        Color(isDraggingAction ? .subColor : .black)
//                                        Color(.subColor)
                                            .frame(width: UIScreen.screenWidth  - 2 * Sizes.overallPadding)
                                            .cornerRadius(10)
                                        HStack {
                                            Spacer()
                                            SystemImage("checkmark")
                                                .frame(width: 65)
                                                .foregroundColor(.black)
                                        }
                                    }
                                    .padding(.horizontal, Sizes.smallSpacing)
                                    .frame(width: UIScreen.screenWidth  - 2 * Sizes.overallPadding)
                                }
                            
                                .gesture(DragGesture()
                                            .updating($isDragging, body: { value, state, _ in
                                    state = true
                                    onChanged(value: value, index: index)
                                }).onEnded({ value in
                                    onEnd(value: value, index: index, memo: memosToShow[index])
                                }))
                        } // end of ZStack
                            .disabled(memoEditVM.isSelectionMode)
                            .gesture(DragGesture()
                                        .updating($isDragging, body: { value, state, _ in
                                state = true
                                onChanged(value: value, index: index)
                            }).onEnded({ value in
                                onEnd(value: value, index: index, memo: memosToShow[index])
                            }))
                        
                        .simultaneousGesture(TapGesture().onEnded{
                            print("Tap pressed!")

                            if memoEditVM.isSelectionMode {
                                print("Tap gesture triggered!")
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
    
    func onChanged(value: DragGesture.Value, index: Int) {
        
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
                    offsets[index] = -65
                }
            default:
                DispatchQueue.main.async {
                    offsets[index] = value.translation.width
                }
            }
        }
        
    }
    
    func onEnd(value: DragGesture.Value, index: Int, memo: Memo) {
        withAnimation {
            print("onEnd triggered")
            if value.translation.width <= -65 {
                
                DispatchQueue.main.async {
                    memoEditVM.isSelectionMode = true
                    memoEditVM.dealWhenMemoSelected(memo)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    offsets[index] = 0
                    isDraggingAction = false
                }
                
            } else {
                DispatchQueue.main.async {
                    offsets[index] = 0
                    isDraggingAction = false
                }
            }
        }
    }
}

