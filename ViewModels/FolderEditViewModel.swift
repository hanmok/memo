//
//  FolderEditing.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/21.
//

import Foundation
import CoreData


class FolderEditViewModel: ObservableObject {
    
    @Published var shouldChangeFolderName = false
    
    @Published var shouldShowSelectingView = false
    
    @Published var folderToPaste: Folder? = nil
    @Published var folderToCut: Folder? = nil
//    @Published var folderToCut: [Folder] = []
    
    var selectedFolder: Folder? = nil


}

