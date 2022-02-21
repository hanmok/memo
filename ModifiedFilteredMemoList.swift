//
//  ModifiedFilteredMemoList.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/02/21.
//

import SwiftUI

struct ModifiedFilteredMemolist: View {
    
    var listType: MemoListType
    @EnvironmentObject var memosVM: MemosViewModel
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    @EnvironmentObject var folderEditVM: FolderEditViewModel
    @State var hasNotLongSelected = false
    
//    var memos: [Memo]
    var memos:[Memo] {
        switch listType {
        case .pinned: return memosVM.pinnedMemos
        case .unpinned: return memosVM.unpinnedMemos
        case .all: return memosVM.allMemos
        }
    }
    
   
    var body: some View {
        DispatchQueue.main.async {
            print("ModifiedFilteredMemoList triggered")
            for each in memosVM.allMemos {
                print(each.contents)
            }
//            print("MemosVm.pinnedMemos: \(memosVM.pinnedMemos)")
        }
        return ZStack {
            
            VStack { // without this, views stack on other memos
                Section {
                    ForEach(memos, id: \.self) { memo in
                        
                        NavigationLink(destination:
                                        MemoView(memo: memo, parent: memo.folder!, presentingView: .constant(false))
                                        .environmentObject(memoEditVM)
                                        .environmentObject(folderEditVM)
                        
                        ) {
                            MemoBoxView(memo: memo)
//                            BookmarkedMemoBoxView(memo: memo)
                            
                                .frame(width: UIScreen.screenWidth - 20, alignment: .center)
                        }
                        .disabled(!memoEditVM.hasNotLongSelected)

//                        // MARK: - Tapped
                        .simultaneousGesture(TapGesture().onEnded{
                            
                                if !memoEditVM.hasNotLongSelected {
                                    memoEditVM.dealWhenMemoSelected(memo)
                                }

                            else { // if not long tapped
                                    memoEditVM.navigateToMemo = memo
                                    memoEditVM.hasNotLongSelected = true
                                }

                            hasNotLongSelected.toggle()
                            memoEditVM.someBool.toggle()

                            if memoEditVM.selectedMemos.isEmpty {
                                    memoEditVM.hasNotLongSelected = true
                                }
                            })

//                        // MARK: - LONG PRESSED
                            .simultaneousGesture(LongPressGesture().onEnded{_ in
                                // if already long tapped
                                if !memoEditVM.hasNotLongSelected { // if it has been long pressed

                                    memoEditVM.dealWhenMemoSelected(memo)

                                } else { // if not long tapped already
                                    memoEditVM.hasNotLongSelected = false
                                    memoEditVM.add(memo: memo)

                                }

                                if memoEditVM.selectedMemos.isEmpty {
                                    memoEditVM.hasNotLongSelected = true
// initialized.
                                }
                            })
                    } // end of ForEach
                } header: {
                    VStack {
                        HStack {
                            if listType == .pinned {
                                ChangeableImage(imageSystemName: "pin.fill", width: 16, height: 16)
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


