//
//  File.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/05.
//

import Foundation
import Combine

class NavigationStateManager: ObservableObject {
    @Published var selectedFolder: Folder? = nil
    @Published var selectedMemo: Memo? = nil
}
