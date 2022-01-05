//
//  MemoViewModel.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/29.
//

import Foundation
import SwiftUI
import Combine

class MemoViewModel: ObservableObject {
    @Published var currentMemo: Memo?
    
    init(memo: Memo) {
        currentMemo = memo
    }
    
}



//extension MemoViewModel
// ManagedObjects conform to ObservableObjects.

