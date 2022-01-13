//
//  MemoList.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/30.
//

import SwiftUI

struct MemoList: View {
    
    @ObservedObject var folder: Folder
    @State private var something = false
    //    @Binding var selectedMemo: Memo?
    
//    var memoColumns: [GridItem] {
//        [GridItem(.adaptive(minimum: 100, maximum: 150))]
//    }
    var memoColumns: [GridItem] {
        [GridItem(.flexible(minimum: 150, maximum: 200)),
         GridItem(.flexible(minimum: 150, maximum: 200))
        ]
    }
    
    var memos: [Memo] {
        let sortedOldMemos = folder.memos.sorted()
        
        return sortedOldMemos
    }
    
    var body: some View {
        
        if memos.count != 0 {
            
            
            
//            ForEach(memos, id: \.self) { eachMemo in
//
//                NavigationLink(
//                    destination: MemoView(memo: eachMemo, parent: folder)
//                ) {
//                    MemoBoxView(memo: eachMemo)
//                        .onAppear {
//                            print("TQmemo: \(eachMemo.title)")
//                        }
//                }
//            }
            
            LazyVGrid(columns: memoColumns) {
                ForEach(memos, id: \.self) { eachMemo in
                    
                    NavigationLink(
                        destination: MemoView(memo: eachMemo, parent: folder)
                    ) {
                        MemoBoxView(memo: eachMemo)
                            .frame(width: 170, alignment: .topLeading)
//                            .background(.green)
                            .onAppear {
                                print("showed Memo: \(eachMemo.title)")
                            }
                    }
                }
            }
            .onAppear {
                print("\(memos.count) number of memos has appeared")
            }
        }
    }
}

//struct MemoList_Previews: PreviewProvider {
//    static var previews: some View {
//        MemoList(folder: deeperFolder)
//    }
//}
