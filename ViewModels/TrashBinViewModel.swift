//
//  TrashBinViewModel.swift
//  DeeepMemo (iOS)
//
//  Created by Mac mini on 2022/03/03.
//

import SwiftUI

class TrashBinViewModel: ObservableObject {
    
    @Published var trashBinFolder: Folder
    
    init(trashBinFolder: Folder) {
        self.trashBinFolder = trashBinFolder
    }
}
