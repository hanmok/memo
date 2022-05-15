//
//  PreventingAnimationViewModel.swift
//  DeeepMemo (iOS)
//
//  Created by Mac mini on 2022/05/14.
//

import Foundation
import SwiftUI

class PreventingAnimationViewModel: ObservableObject {
    @Published var viewAppear = false
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewAppear = true
        }
    }
}

