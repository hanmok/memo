//
//  MessageViewModel.swift
//  DeeepMemo (iOS)
//
//  Created by Mac mini on 2022/03/13.
//

import SwiftUI

//class MessageViewModel: ObservableObject {
//    @Published var hasMemoRemovedForever: Bool?
//    // if true, it removed permanently.
//    // if false, it moved to trashBin
//}


class MessageViewModel: ObservableObject {
    @Published var message: String? = nil
    @Published var shouldShow = false
    
}
