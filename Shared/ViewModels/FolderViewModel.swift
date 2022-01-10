//
//  FolderViewModel.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/05.
//

import Foundation
import Combine

class FolderViewModel: ObservableObject {
    @Published var currentFolder: Folder
    
    init(folder: Folder) {
        currentFolder = folder
    }
    
}
