//
//  MemoList.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/30.
//

import SwiftUI

struct MemoList: View {
    
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
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack { // moves scroll Bar to the right
                    Section {
                        
                        if memos.count != 0 {
                            ForEach(memos) { memo in
                                NavigationLink(
                                    destination: MemoView(memo: memo)
                                ) {
                                    MemoBoxView(memo: memo)
                                }
                                .padding(.vertical, 6)
                                
                            }
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(.green)
    }
}

//struct MemoList_Previews: PreviewProvider {
//    static var previews: some View {
//        MemoList(folder: deeperFolder)
//    }
//}
