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

class MemosViewModel: ObservableObject {
    @Published var memos: [Memo]
    @Published var offsets: [CGFloat]
    var listType: MemoListType
    init(folder: Folder, type: MemoListType) {
        self.listType = type
        var sortedMemos = [Memo]()
        switch type {
        case .pinned:
             sortedMemos = Memo.sortMemos(memos: folder.memos.filter { $0.pinned || $0.isBookMarked })
        case .unpinned:
            sortedMemos = Memo.sortMemos(memos: folder.memos.filter {$0.pinned == false && $0.isBookMarked == false})
        case .all:
            sortedMemos = Memo.sortMemos(memos: folder.memos.sorted())
        }
        self.memos = sortedMemos
        
        var emptyOffsets: [CGFloat] = []
        
        for _ in 0 ..< sortedMemos.count {
            emptyOffsets.append(0)
        }
        offsets = emptyOffsets
    }

}

struct FilteredMemoList: View {
    
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    @EnvironmentObject var folderEditVM: FolderEditViewModel
//    @ObservedObject var folder: Folder
    @State var hasNotLongSelected = false
    @ObservedObject var memosViewModel: MemosViewModel
//    var listType: MemoListType
    @GestureState var isDragging = false
    
//    init(listType: MemoListType, folder: Folder) {
//        memosViewModel = MemosViewModel(folder: folder, type: listType)
//        self.listType = listType
//    }
//    @State var myoffset: [CGFloat] = []
//    @State var offsets: [CGFloat] = []
    
//    @State var offsets: [CGFloat] = (0 ... 100).map { _ in CGFloat(0)}
    @State var offsets: [CGFloat] = []
    
    init() {
        self.offsets = memosViewModel.memos.map { _ in CGFloat(0)}
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
        
//        DispatchQueue.main.async {
//            var emptyOffset: [CGFloat] = []
//            for _ in 0 ..< memosToShow.count {
////                myoffset.append(0)
//                emptyOffset.append(0)
//            }
//            myoffset = emptyOffset
//        }

        
        return ZStack {
            
            VStack { // without this, views stack on other memos
                Section {
//                    ForEach(memosToShow.indices, id: \.self) { index in
                    ForEach(memosViewModel.memos.indices, id: \.self) { index in
                        
                            
                            
                            NavigationLink(destination:
                                            MemoView(memo: memosViewModel.memos[index], parent: memosViewModel.memos[index].folder!, presentingView: .constant(false))
                                            .environmentObject(memoEditVM)
                                            .environmentObject(folderEditVM)
                            ) {
                                MemoBoxView(memo: memosViewModel.memos[index])
                                    .frame(width: UIScreen.screenWidth - 20, alignment: .center)
                                    .offset(x: offsets[index])
                                    .background {
                                        ZStack {
                                            Color(.subColor)
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
                                onEnd(value: value, index: index, memo: memosViewModel.memos[index])
                            }))
                        } // end of ZStack
                            .disabled(memoEditVM.isSelectionMode)
                            .gesture(DragGesture()
                                        .updating($isDragging, body: { value, state, _ in
                                state = true
                                onChanged(value: value, index: index)
                            }).onEnded({ value in
                                onEnd(value: value, index: index, memo: memosViewModel.memos[index])
                            }))
                        
                        .simultaneousGesture(TapGesture().onEnded{
                            print("Tap pressed!")
                            // if long selected ( mode on)
                            //                            if !memoEditVM.hasNotLongSelected {
                            
                            if memoEditVM.isSelectionMode {
                                print("Tap gesture triggered!")
                                memoEditVM.dealWhenMemoSelected(memosViewModel.memos[index])
                            }
                            
                        })
                        
                    } // end of ForEach
                } header: {
                    VStack {
                        HStack {
                            if memosViewModel.listType == .pinned {
                                //                                ChangeableImage(imageSystemName: "pin.fill", width: 16, height: 16)
                                HStack {
                                    SystemImage("bookmark.fill", size: 16)
                                        .tint(Color.navBtnColor)
                                        .frame(alignment: .topLeading)
                                        .padding(.leading, Sizes.overallPadding + 4)
                                
                                    SystemImage("pin.fill", size: 16)
                                        .tint(Color.navBtnColor)
                                        .frame(alignment: .topLeading)
                                        .rotationEffect(.degrees(45))
                                    //                                    .padding(.leading, Sizes.overallPadding + 4)
                                    //                                    .padding(.leading, Sizes.minimalSpacing)
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
        if value.translation.width < 0 && isDragging {
            DispatchQueue.main.async {
//                myoffset[index] = value.translation.width
                offsets[index] = value.translation.width
            }
        }
    }
    
    func onEnd(value: DragGesture.Value, index: Int, memo: Memo) {
        withAnimation {
            if -value.translation.width >= 70 {
                memoEditVM.isSelectionMode = true
                memoEditVM.dealWhenMemoSelected(memo)

                offsets[index] = -65

                print("turn offset Index to -65 : \(index)")
                print(offsets[index])
            } else {
                offsets[index] = 0
            }
            if offsets[index] == -65 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    print("back to 0 ")
                    offsets[index] = 0
                }
            }
        }
    }
}

