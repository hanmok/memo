//
//  Messages.swift
//  DeeepMemo (iOS)
//
//  Created by 이한목 on 2022/03/09.
//

import Foundation

struct Messages {
    
    static let hasAddedToFolder = "memo has saved to Folder"
    
    
    /// memo deleted
    static func showMemosDeletedMsg(_ n: Int) -> String {
        return "\(n) memos has deleted"
    }
    /// folder deleted
    static func showFolderDeleted(targetFolder: Folder) -> String {
        return "\(targetFolder.title) folder has deleted"
    }
    
    static func showMemoMovedToTrash(_ n: Int) -> String {
        return "\(n) memos has moved to trash bin "
    }
    
    
    /// pinned
    static func showPinnedMsg(_ n: Int) -> String {
        return "\(n) memos has pinned"
    }
    
    /// unpinned
    static func showUnpinnedMsg(_ n: Int) -> String {
        return "\(n) memos has unpinned"
    }
    
    /// bookmarked
    static func showBookmarkedMsg(_ n: Int) -> String {
        return "\(n) memos has bookmarked"
    }
    
    /// unbookmarked
    static func showUnbookmarkedMsg(_ n: Int) -> String {
        return "\(n) memos has Unbookmarked"
    }
    
    /// memo moved
    static func showMemoMovedMsg(_ n: Int, to folder: Folder) -> String {
        if Locale.current.identifier == "kr" {
            return "\(n) 개의 메모가 \(folder.title) 로 이동하였습니다."
        } else {
            return "\(n) memos has moved to \(folder.title)"
        }
    }
    

    /// folder moved
    static func showFolderMovedMsg(targetFolder: Folder, to desFolder : Folder) -> String {
        
        if Locale.current.identifier == "kr" {
            return "\(targetFolder.title) 폴더가 \(desFolder.title) 로 이동하였습니다. "
        } else {
            return "\(targetFolder.title) has moved to \(desFolder.title) "
        }
    }
    
}
