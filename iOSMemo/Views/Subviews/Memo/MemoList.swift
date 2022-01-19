//
//  MemoList.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/30.
//

import SwiftUI


struct MemoList: View {
    
//    @Environment(\.managedObjectContext) var context
//    @StateObject var selectedViewModel = SelectedMemoViewModel()
    
    @EnvironmentObject var folder: Folder
    //    @ObservedObject var folder: Folder
    @Binding var isAddingMemo: Bool
    
    @ObservedObject var pinViewModel : PinViewModel

    
    var memoColumns: [GridItem] {
        [GridItem(.flexible(minimum: 150, maximum: 200)),
         GridItem(.flexible(minimum: 150, maximum: 200))
        ]
    }
    
//    var pinnedMemos: [Memo] {
//        //        memos.filter {$0.pinned}
//        let sortedOldMemos = folder.memos.sorted()
//        return sortedOldMemos.filter {$0.pinned}
//    }
    
//    var unpinnedMemos: [Memo] {
//        //        memos.filter { !$0.pinned}
//        let sortedOldMemos = folder.memos.sorted()
//        return sortedOldMemos.filter {!$0.pinned}
//    }
    
    //    @State var memoSelected: Bool = false
    //    @ObservedObject var memos: [Memo]
    
    var memos: [Memo] {
        let sortedOldMemos = folder.memos.sorted()
        
        return sortedOldMemos
    }
    
    // need to be modified to have plus button when there's no memo
    var body: some View {
        
            if memos.count != 0 {
                VStack {
//                    if pinnedMemos.count != 0 {
                    if pinViewModel.pinnedMemos.count != 0 {
//                        FilteredMemoList(memos: pinnedMemos, title: "pinned", parent: folder)
                        
                        Section {
                            ForEach(pinViewModel.pinnedMemos, id: \.self) { pinnedmemo in
                                    NavigationLink(destination: MemoView(memo: pinnedmemo, parent: folder)) {
                                        MemoBoxView(memo: pinnedmemo)
                                            .frame(width: 170, alignment: .topLeading)
                                    }
                            }
                        }
                        
                        
                    Rectangle()
                            .frame(height: 1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color(.sRGB, white: 0.5, opacity: 0.5))
                    }
//                    FilteredMemoList(memos: unpinnedMemos, title: "unpinned", parent: folder)
                    
                    Section {
                        ForEach(pinViewModel.unpinnedMemos, id: \.self) { unpinnedmemo in
                                NavigationLink(destination: MemoView(memo: unpinnedmemo, parent: folder)) {
                                    MemoBoxView(memo: unpinnedmemo)
                                        .frame(width: 170, alignment: .topLeading)
                                }
                        }
                    }
                }
            }
    }
}


//struct MemoList_Previews: PreviewProvider {
//    static var previews: some View {
//        MemoList(folder: deeperFolder)
//    }
//}
