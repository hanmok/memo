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
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    @ObservedObject var folder: Folder
    
    //    @State var isNotLongSelecting = false
    
    var listType: MemoListType
    //    var selectedMemo: Memo? = nil
    
    var body: some View {
        
        
        var memosToShow = [Memo]()
        
        switch listType {
        case .pinned:
            memosToShow = folder.memos.filter { $0.pinned == true}.sorted()
        case .unpinned:
            memosToShow = folder.memos.filter { $0.pinned != true}.sorted()
        case .all:
            memosToShow = folder.memos.sorted()
        }
        
        //        memoEditVM.navigateToMemo = folder.memos.sorted().first!
        
        
        //        return ZStack(alignment: .topLeading) {
        return ZStack {
            if memoEditVM.navigateToMemo != nil {
                NavigationLink(
                    destination:
                        MemoView(memo: memoEditVM.navigateToMemo!, parent: folder),
                    //                    isActive: $isNotLongSelecting) {}
                    isActive: $memoEditVM.hasNotLongSelected) {}
            }

            
            VStack {
                Section {
                    ForEach(memosToShow, id: \.self) { memo in
                        MemoBoxView(memo: memo)
                            .frame(width: UIScreen.screenWidth - 20, alignment: .center)
                        
                        // MARK: - Tapped
                            .simultaneousGesture(TapGesture().onEnded{
                                // if already long tapped
                                if !memoEditVM.hasNotLongSelected {
                                    
                                    memoEditVM.dealWhenMemoSelected(memo)
                                    
                                } else { // if not long tapped
                                    memoEditVM.navigateToMemo = memo
                                    memoEditVM.hasNotLongSelected = true
                                }
                                
                                if memoEditVM.selectedMemos.isEmpty {
                                    memoEditVM.hasNotLongSelected = true
                                }
                            })
                        // MARK: - LONG PRESSED
                            .simultaneousGesture(LongPressGesture().onEnded{_ in
                                // if already long tapped
                                if !memoEditVM.hasNotLongSelected { // if it has been long pressed
                                    
                                    memoEditVM.dealWhenMemoSelected(memo)
                                    
                                } else { // if not long tapped
                                    memoEditVM.hasNotLongSelected = false
                                    memoEditVM.add(memo: memo)
                                }
                                
                                if memoEditVM.selectedMemos.isEmpty {
                                    memoEditVM.hasNotLongSelected = true
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
            }
        }
    }
}
