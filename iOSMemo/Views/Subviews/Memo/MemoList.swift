//
//  MemoList.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/30.
//

import SwiftUI


struct FilteredMemoList: View {
    
    var memos: [Memo]
    var title: String
    let parent: Folder
    
    var body: some View {
        Section {
            ForEach(memos, id: \.self) { memo in
                NavigationLink(destination: MemoView(memo: memo, parent: parent)) {
                    MemoBoxView(memo: memo)
                        .frame(width: 170, alignment: .topLeading)
                }
            }
        } header: {
            HStack {
            Text(title)
                .foregroundColor(.gray)
                .font(.body)
                .frame(alignment: .topLeading)
                .padding(.leading, Sizes.overallPadding)
                Spacer()
            }
        }
    }
}

struct MemoList: View {
    
    @ObservedObject var folder: Folder
    @Binding var isAddingMemo: Bool
    
    //    @Binding var selectedMemo: Memo?
    
    //    var memoColumns: [GridItem] {
    //        [GridItem(.adaptive(minimum: 100, maximum: 150))]
    //    }
    var memoColumns: [GridItem] {
        [GridItem(.flexible(minimum: 150, maximum: 200)),
         GridItem(.flexible(minimum: 150, maximum: 200))
        ]
    }
    
    var pinnedMemos: [Memo] {
        //        memos.filter {$0.pinned}
        let sortedOldMemos = folder.memos.sorted()
        return sortedOldMemos.filter {$0.pinned}
    }
    
    var unpinnedMemos: [Memo] {
        //        memos.filter { !$0.pinned}
        let sortedOldMemos = folder.memos.sorted()
        return sortedOldMemos.filter {!$0.pinned}
    }
    
    @State var memoSelected: Bool = false
    //    @ObservedObject var memos: [Memo]
    
    var memos: [Memo] {
        let sortedOldMemos = folder.memos.sorted()
        
        return sortedOldMemos
    }
    
    var body: some View {
        
        if memos.count != 0 {
            
            ZStack {
                LazyVGrid(columns: memoColumns) {
                    //                LazyVGrid
                    //                    ForEach(memos, id: \.self) { eachMemo in
                    //
                    //                        NavigationLink(
                    //                            destination: MemoView(memo: eachMemo, parent: folder)
                    //                        ) {
                    //                            MemoBoxView(memo: eachMemo)
                    //                                .frame(width: 170, alignment: .topLeading)
                    //                        }
                    //                    }
                    FilteredMemoList(memos: pinnedMemos, title: "pinned", parent: folder)
                    FilteredMemoList(memos: unpinnedMemos, title: "unpinned", parent: folder)
                } // end of LazyVGrid
                //            .background(.blue)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        if !memoSelected {
                            // show plus button
                            Button(action: {
                                isAddingMemo = true
                                // navigate to MemoView
                            }) {
                                PlusImage()
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: Sizes.overallPadding, trailing: Sizes.overallPadding * 1.5))
                            }
                        } else {
                            MemosToolBarView()
                                .padding([.trailing], Sizes.largePadding)
                                .padding(.bottom,Sizes.overallPadding )
                        }
                    } // end of HStack
                } // end of VStack
                //                .background(.green)
            }
        }
    }
}

//struct MemoList_Previews: PreviewProvider {
//    static var previews: some View {
//        MemoList(folder: deeperFolder)
//    }
//}
