//
//  FastFolderWithLevelGroup.swift
//  DeeepMemo (iOS)
//
//  Created by Mac mini on 2022/03/03.
//

import Foundation


class FastFolderWithLevelGroup: ObservableObject {
    
    @Published var folders: [FolderWithLevel]
    @Published var archives: [FolderWithLevel]

    @Published var homeFolder: Folder
    @Published var archive: Folder
    
    init(homeFolder: Folder, archiveFolder: Folder) {
        self.homeFolder = homeFolder
        self.archive = archiveFolder
        
        self.archives = Folder.getHierarchicalFolders(topFolder: archiveFolder)
        self.folders = Folder.getHierarchicalFolders(topFolder: homeFolder)
    }
}


struct FolderWithLevel: Hashable {
    var folder: Folder
    var level: Int
    var isCollapsed: Bool = false
    var isShowing: Bool = true
}

