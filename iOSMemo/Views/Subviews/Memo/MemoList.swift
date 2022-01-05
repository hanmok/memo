//
//  MemoList.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/30.
//

import SwiftUI

struct MemoList: View {
    
//    var folder: Folder
    
//    var memos: [Memo] {
//        var memos: [Memo] = []
//        for eachMemo in folder!.memos {
//            memos.append(eachMemo)
//        }
//        return memos
//    }
    
//    @FetchRequest(fetchRequest: Memo.fetch(<#T##predicate: NSPredicate##NSPredicate#>))
    
    init(folder: Folder?, selectedMemo: Binding<Memo?>) {
        self._selectedMemo = selectedMemo
        
        var predicate = NSPredicate.none
        
        if let folder = folder {
            predicate = NSPredicate(format: "%K == %@", MemoProperties.folder, folder)
        }
        self._memos = FetchRequest(fetchRequest: Memo.fetch(predicate))
        self.folder = folder
    }
    
    @FetchRequest(fetchRequest: Memo.fetch(NSPredicate.all)) private var memos: FetchedResults<Memo>
    
    let folder: Folder?
    @Binding var selectedMemo: Memo?
    
    var body: some View {
        //        List {
//        ScrollView {
        ScrollViewReader { proxy in
            ScrollView {
            LazyVStack { // moves scroll Bar to the right
                Section {
                    if memos != nil {
                        ForEach(memos) { memo in
                            NavigationLink(
//                                destination: MemoView(
//                                    mvm: MemoViewModel(memo: memo))
                                destination: MemoView(memo: <#T##Memo#>)
                            ) {

                                MemoBoxView(memo: memo)
                            }
                            .padding(.vertical, 6)
                            
//                            NavigationLink(destination: MemoView(mvm: MemoViewModel(memo: memo)), label: MemoBoxView(memo:memo))
//                            NavigationLink(destion)
                        }
                    }
                }
            }
        }
        }
        .frame(maxWidth: .infinity)
        .background(.green)
        //        }
    }
}

//struct MemoList_Previews: PreviewProvider {
//    static var previews: some View {
//        MemoList(folder: deeperFolder)
//    }
//}
