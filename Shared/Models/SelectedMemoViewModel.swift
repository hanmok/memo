//
//  SelectedMemoViewModel.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/19.
//

import Foundation
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



