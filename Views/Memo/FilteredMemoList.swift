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

    @AppStorage("mOrderType") var mOrderType = OrderType.modificationDate
    @AppStorage("mOrderAsc") var mOrderAsc = false

//    let sortingMethod = Memo.getSortingMethod(type: mOrderType, isAsc: mOrderAsc)
    @State var sortingMethod: (Memo, Memo) -> Bool = { _, _ in true }
    var body: some View {
        DispatchQueue.main.async {
            sortingMethod = Memo.getSortingMethod(type: mOrderType, isAsc: mOrderAsc)
            print("Memo sortedMethod: \(mOrderType)") // 미친거야?
        }

        
        var memosToShow = [Memo]()
        
        switch listType {
        case .pinned:
            memosToShow = folder.memos.filter { $0.pinned == true}.sorted(by: sortingMethod)
        case .unpinned:
            memosToShow = folder.memos.filter { $0.pinned != true}.sorted(by: sortingMethod)
        case .all:
            memosToShow = folder.memos.sorted(by: sortingMethod)
        }
        
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
