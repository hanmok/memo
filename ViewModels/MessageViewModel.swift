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

    @Published var message: String = "" {
        didSet {
            print("messages has changed to \(self.message)")
            DispatchQueue.main.async {
                withAnimation(.spring().speed(2)) {
                    self.shouldShow = true
                }

                print("shouldShow: \(self.shouldShow)")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.spring()) {
                    
                    self.shouldShow = false
                }
                print("shouldShow: \(self.shouldShow)")
            }
        }
    }

    @Published var shouldShow = false
}
