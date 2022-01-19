//
//  PinViewModel.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/19.
//

import SwiftUI

class PinViewModel:ObservableObject {
    
    init(memos: Set<Memo>) {
        self.memos = memos.sorted()
    }
    
    @Published var memos: [Memo]
    
    var pinnedMemos : [Memo] {
        return memos.filter { $0.pinned }
    }
    
     var unpinnedMemos : [Memo] {
        return memos.filter { !$0.pinned }
    }
}
