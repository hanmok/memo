//
//  MemoList.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/30.
//

import SwiftUI

struct MemoListTest: View {
    
//    init(folder: Folder?, selectedMemo: Binding<Memo?>) {
//    init(folder: Folder?) {
////        self._selectedMemo = selectedMemo
//
//        var predicate = NSPredicate.none
//
//        if let folder = folder {
//            predicate = NSPredicate(format: "%K == %@", MemoProperties.folder, folder)
//        }
//        self._memos = FetchRequest(fetchRequest: Memo.fetch(predicate))
//        self.folder = folder!
//    }
    
    // need to specify predicate condition . (currentFolder)
//    @FetchRequest(fetchRequest: Memo.fetch(NSPredicate.all)) private var memos: FetchedResults<Memo>
    
//    let memosFromFolderView: [Memo]
//    let folder: Folder
    
    @ObservedObject var folder: Folder
    @State private var something = false
//    @Binding var selectedMemo: Memo?
    
    var memos: [Memo] {
        let sortedOldMemos = folder.memos.sorted()
        
        return sortedOldMemos
    }
    
    var body: some View {
                        
                        if memos.count != 0 {
//                            NavigationView {
                            ForEach(memos, id: \.self) { eachMemo in
                                
                                NavigationLink(
                                    destination: MemoView(memo: eachMemo, parent: folder)
                                ) {
                                    MemoBoxView(memo: eachMemo)
                                        .onAppear {
                                            print("TQmemo: \(eachMemo.title)")
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
