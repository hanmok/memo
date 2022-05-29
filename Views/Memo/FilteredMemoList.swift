//
//  FilteredMemoList.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/18.
//

import SwiftUI


enum MemoListType: String {
    case pinned
    case plain
    case all
}

struct FilteredMemoList: View {
    
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    
    @EnvironmentObject var trashBinVM: TrashBinViewModel
    
    @ObservedObject var folder: Folder
    @StateObject var dragVM = DraggableViewModel()
    var listType: MemoListType
    @GestureState var isDragging = false
    /// dragging flag end a little later than isDragging, to complete onEnd Action (for Better UX)
    @State var isOnDraggingAction = false
    
    @State var draggingMemo: Memo? = nil
    
    @State var oneOffset: CGFloat = 0
    
    var body: some View {
        
        var memosToShow = [Memo]()
        
        switch listType {
        case .pinned:
//            memosToShow = Memo.sortMemos(memos: folder.memos.filter { $0.isPinned || $0.isBookMarked })
            memosToShow = Memo.sortMemos(memos: folder.memos.filter { $0.isPinned })
        case .plain:
//            memosToShow = Memo.sortMemos(memos: folder.memos.filter {$0.isPinned == false && $0.isBookMarked == false})
            memosToShow = Memo.sortMemos(memos: folder.memos.filter {$0.isPinned == false })
        case .all:
            memosToShow = Memo.sortMemos(memos: folder.memos.sorted())
        }
        
        return ZStack {
            
            VStack { // without this, views stack on other memos
                Section {
                    
                    ForEach(memosToShow, id: \.self) { memo in
                        
                        
                        if memo.folder != nil {
                        DraggableMemoBoxView(memo: memo)
                            .environmentObject(memoEditVM)
                            .environmentObject(dragVM)
                            .environmentObject(trashBinVM)
                        }
                        
                    } // end of ForEach
                } header: {
                    VStack {
                        HStack {
                            if listType == .pinned {
                                SystemImage(.Icon.filledPin, size: 16)
                                        .tint(Color.navBtnColor)
                                        .frame(alignment: .topLeading)
                                        .rotationEffect(.degrees(45))
                                        .padding(.leading, Sizes.overallPadding + 4)
//                                }
                            }
                            Spacer()
                        }
                    }
                }
            } // end of VStack
        } // end of ZStack
    }
    
    func onChanged(value: DragGesture.Value, memo: Memo) {
        DispatchQueue.main.async {
            draggingMemo = memo
        }
        
        if isDragging && value.translation.width < -5 {
            DispatchQueue.main.async {
                isOnDraggingAction = true
            }
        }
        
        if isDragging && value.translation.width < 0 {
            
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
