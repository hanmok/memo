//
//  Messages.swift
//  DeeepMemo (iOS)
//
//  Created by 이한목 on 2022/03/09.
//

import Foundation

struct Messages {
    
    static let hasAddedToFolder = "memo has been added to Folder"
    static let folderHasMade = LocalizedStringStorage.folderCreated
    static let memoSaved = LocalizedStringStorage.memoSaved
    
    /// memo deleted
    static func showMemosDeletedMsg(_ n: Int) -> String {
        return n == 1 ? LocalizedStringStorage.oneMemoHasDeleted : "\(n)\(LocalizedStringStorage.memosHasDeleted)"
    }
    /// folder deleted
    static func showFolderDeleted(targetFolder: Folder) -> String {
        return "\(targetFolder.title) \(LocalizedStringStorage.folderHasDeleted)"
    }
    
    static func showMemoMovedToTrash(_ n: Int) -> String {
        return n == 1 ? LocalizedStringStorage.oneMemoHasMovedToTrash : "\(n)\(LocalizedStringStorage.memosHasMovedToTrash)"
    }
    
    
    /// pinned
    static func showPinnedMsg(_ n: Int) -> String {
        return n == 1 ? LocalizedStringStorage.oneMemoHasPinned : "\(n)\(LocalizedStringStorage.memosHasPinned)"
       
    }
    
    /// unpinned
    static func showUnpinnedMsg(_ n: Int) -> String {
        return n == 1 ? LocalizedStringStorage.oneMemoHasUnpinned : "\(n)\(LocalizedStringStorage.memosHasUnpinned)"
    }
    
    /// bookmarked
//    static func showBookmarkedMsg(_ n: Int) -> String {
//        return n == 1 ? LocalizedStringStorage.oneMemoHasBookmarked : "\(n)\(LocalizedStringStorage.memosHasBookmarked)"
//    }
    
    /// unbookmarked
//    static func showUnbookmarkedMsg(_ n: Int) -> String {
//        return n == 1 ? LocalizedStringStorage.oneMemoHasUnbookmarked : "\(n)\(LocalizedStringStorage.memosHasUnbookmarked)"
//    }
    
    /// memo moved
    static func showMemoMovedMsg(_ n: Int, to folder: Folder) -> String {
        let msgForKor1 = "메모가 \(folder.title) 폴더로 이동하였습니다."
        let msgForOther1 = "memo has moved to \(folder.title)"
        
        let msgForKor = "\(n)개의 메모가 \(folder.title) 폴더로 이동하였습니다."
        let msgForOther = "\(n) memos has moved to \(folder.title)"
        
        return n == 1 ? self.showMsgTo(kor: msgForKor1, other: msgForOther1) : self.showMsgTo(kor: msgForKor, other: msgForOther)
    }
    
    
    /// folder moved
    static func showFolderMovedMsg(targetFolder: Folder, to desFolder : Folder) -> String {
        
        let msgForKor = "\(targetFolder.title) 폴더가 \(desFolder.title) 폴더로 이동하였습니다. "
        let msgForOther = "\(targetFolder.title) has moved to \(desFolder.title) "
        
        return self.showMsgTo(kor: msgForKor, other: msgForOther)
    }
    
    static func showMsgTo(kor: String, other: String) -> String{
        if let lanCode = Locale.current.languageCode {
            if lanCode.contains("ko") {
                return kor
            } else {
                return other
            }
        } else {
            return other
        }
    }
}


//extension Locale {
//    static func showMsgTo(kor: String, other: String) -> String{
//        if let lanCode = self.current.languageCode {
//            if lanCode.contains("ko") {
//                return kor
//            } else {
//                return other
//            }
//        } else {
//            return other
//        }
//    }
//}

