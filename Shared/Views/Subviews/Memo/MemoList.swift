//
//  MemoList.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/30.
//

import SwiftUI

struct MemoList: View {
    
    var folder: Folder
    var memos: [Memo]? {
        return folder.memos
    }
    var body: some View {
        //        List {
//        ScrollView {
        ScrollViewReader { proxy in
            ScrollView {
            LazyVStack { // moves scroll Bar to the right
                Section {
                    if memos != nil {
                        ForEach(memos!) { memo in
                            NavigationLink(destination: MemoView(mvm: MemoViewModel(memo: memo))) {
                                
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
        //        }
    }
}

struct MemoList_Previews: PreviewProvider {
    static var previews: some View {
        MemoList(folder: deeperFolder)
    }
}
