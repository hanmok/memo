//
//  NavigationStateManager.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/10.
//


import Foundation
import Combine
import CoreData

// give this class' selectedFolder default Folder of "Home"
class NavigationStateManager: ObservableObject {
    @Published var selectedFolder: Folder? = nil
    @Published var selectedMemo: Memo? = nil
}
