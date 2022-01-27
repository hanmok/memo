//
//  ContainedMemos.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/20.
//

import Foundation

struct ContainedMemos {
    var folder: Folder
    var memos: [Memo]
    var memosCount: Int
}


extension Folder {
    
    func returnAllMemos() -> ContainedMemos {
        var foldersContainer = [Folder]()
        var memosContainer = [Memo]()
        var memosCount = 0
        
        func getAllFolders(folder: Folder)  {
            let tempFolders = folder.subfolders
            
            if !tempFolders.isEmpty {
                for eachFolder in tempFolders {
                    foldersContainer.append(eachFolder)
                    getAllFolders(folder: eachFolder)
                }
            }
        }

        func appendMemos(folder: Folder) {
            for eachMemo in folder.memos {
                memosContainer.append(eachMemo)
                memosCount += 1
            }
        }
        
        appendMemos(folder: self)
        
        getAllFolders(folder: self)
        
        // get all memos from each of collected Folders
        for eachFolder in foldersContainer {
            
            appendMemos(folder: eachFolder)
        print("memosContainer: \(memosContainer)")
        }
        
        
        return ContainedMemos(folder: self, memos: memosContainer, memosCount: memosCount)
    }
    
    func checkIfHasMemo() -> Bool {
        
        return false
    }
    
}


