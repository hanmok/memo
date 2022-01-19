//
//  MemoList.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/30.
//

import SwiftUI


class SelectedMemoViewModel: ObservableObject {
    
    @Published var memos = Set<Memo>()
    
    @Published var hasSelected = false
    
    public var count: Int {
        memos.count
    }
    
    func add(memo: Memo) {
        self.memos.update(with: memo)    }
}



struct MemoList: View {
    
    @Environment(\.managedObjectContext) var context
//    @StateObject var selectedViewModel = SelectedMemoViewModel()
    
    @EnvironmentObject var folder: Folder
    //    @ObservedObject var folder: Folder
    @Binding var isAddingMemo: Bool
    
    //    @State var selectedMemos: [Memo] = []
    
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
    
    //    @State var memoSelected: Bool = false
    //    @ObservedObject var memos: [Memo]
    
    var memos: [Memo] {
        let sortedOldMemos = folder.memos.sorted()
        
        return sortedOldMemos
    }
    
    // need to be modified to have plus button when there's no memo
    var body: some View {
        
        //        if memos.count != 0 {
        
//        ZStack {
            if memos.count != 0 {
//                LazyVGrid(columns: memoColumns) {
                VStack {
                    
                    if pinnedMemos.count != 0 {
                        FilteredMemoList(memos: pinnedMemos, title: "pinned", parent: folder)
                    }
                    
                    FilteredMemoList(memos: unpinnedMemos, title: "", parent: folder)
                    
                    
//                .environmentObject(selectedViewModel)
                }
            }
            // end of LazyVGrid
            //            .background(.blue)
            
            // another ZStack Element
            
//        } // end of ZStack
//        .frame(maxHeight: .infinity)
    }
}


//struct MemoList_Previews: PreviewProvider {
//    static var previews: some View {
//        MemoList(folder: deeperFolder)
//    }
//}
