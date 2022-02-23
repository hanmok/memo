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
    @ObservedObject var folder: Folder
    @State var hasNotLongSelected = false
    @EnvironmentObject var folderEditVM: FolderEditViewModel
    var listType: MemoListType
//    @State var isDragged = false
//    @GestureState var draggedState = false
    var body: some View {
        
        var memosToShow = [Memo]()
        
        
        switch listType {
        case .pinned:
            memosToShow = Memo.sortMemos(memos: folder.memos.filter { $0.pinned})
        case .unpinned:
            memosToShow = Memo.sortMemos(memos: folder.memos.filter {$0.pinned == false})
        case .all:
            memosToShow = Memo.sortMemos(memos: folder.memos.sorted())
        }
        
//        let drag = DragGesture()
//            .onChanged({ draggedState in
//                print("draggedState: \(draggedState)")
//                print("translation: \(draggedState.translation)")
//
//                switch draggedState.translation.height {
//                case let height where height < -10 || height > 10:
//                    self.isDragged = true
//                    print("isDraaged!")
//                default:
//                    self.isDragged = false
//                    print("is not dragged!")
//                }
//            })
//            .onEnded {_ in
//                self.isDragged = false
//            }
        
        
        return ZStack {
            
            VStack { // without this, views stack on other memos
                Section {
                    ForEach(memosToShow, id: \.self) { memo in
                        NavigationLink(destination:
                                        MemoView(memo: memo, parent: memo.folder!, presentingView: .constant(false))
                                        .environmentObject(memoEditVM)
                                        .environmentObject(folderEditVM)
                        ) {
                            MemoBoxView(memo: memo)
                                .frame(width: UIScreen.screenWidth - 20, alignment: .center)
                        }
//                        .disabled(!memoEditVM.hasNotLongSelected)
                        .disabled(memoEditVM.isSelectionMode)
                         // selecting Mode on / off
                        .simultaneousGesture(TapGesture().onEnded{
                            print("Tap pressed!")
                            // if long selected ( mode on)
//                            if !memoEditVM.hasNotLongSelected {
                            
                            if memoEditVM.isSelectionMode {
                                print("Tap gesture triggered!")
                                memoEditVM.dealWhenMemoSelected(memo)
                            }
                            // mode off
//                            else { // if not long tapped
//                                memoEditVM.navigateToMemo = memo
//                                memoEditVM.hasNotLongSelected = true
//                            }

//                            hasNotLongSelected.toggle()
//                            memoEditVM.someBool.toggle()

//                            if memoEditVM.selectedMemos.isEmpty {
//                                memoEditVM.hasNotLongSelected = true
//                            }
                            
                        })
//                        .simultaneousGesture(
//
//                            LongPressGesture(minimumDuration: 0.5).onEnded{_ in
//
//                                // if already long tapped
//                                print("long pressed!")
//                                if !memoEditVM.hasNotLongSelected { // if it has been long pressed
//
//                                    memoEditVM.dealWhenMemoSelected(memo)
//
//                                } else { // if not long tapped already
//                                    memoEditVM.hasNotLongSelected = false
//                                    memoEditVM.add(memo: memo)
//
//                                }
//
//                                if memoEditVM.selectedMemos.isEmpty {
//                                    memoEditVM.hasNotLongSelected = true
//                                }
//                            }
//                        )
                    } // end of ForEach
                } header: {
                    VStack {
                        HStack {
                            if listType == .pinned {
//                                ChangeableImage(imageSystemName: "pin.fill", width: 16, height: 16)
                                SystemImage("pin.fill", size: 16)
                                    .tint(Color.navBtnColor)
                                    .frame(alignment: .topLeading)
                                    .rotationEffect(.degrees(45))
                                    .padding(.leading, Sizes.overallPadding + 4)
                            }
                            Spacer()
                        }
                    }
                }
            } // end of VStack
        } // end of ZStack
    }
}
