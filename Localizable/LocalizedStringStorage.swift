//
//  LocalizedStringStorage.swift
//  DeeepMemo (iOS)
//
//  Created by Mac mini on 2022/03/01.
//

import Foundation

struct LocalizedStringStorage {
    
    static let removeAlertMsgMain = NSLocalizedString(LocalizedStringKeys.removeAlertMsgMain, comment: "Remove Main Message")
    
    static let removeAlertMsgSub = NSLocalizedString(LocalizedStringKeys.removeAlertMsgSub, comment: "remove sub message")
    static let cancelInSearch = NSLocalizedString(LocalizedStringKeys.cancelInSearch, comment: "Cancel")
    static let cancel = NSLocalizedString(LocalizedStringKeys.cancel, comment: "a")
    static let delete = NSLocalizedString(LocalizedStringKeys.delete, comment: "a")
    
    static let newFolder = NSLocalizedString(LocalizedStringKeys.newFolder, comment: "a")
    static let renameFolder = NSLocalizedString(LocalizedStringKeys.renameFolder, comment: "a")
    static let newSubFolder = NSLocalizedString(LocalizedStringKeys.newSubFolder, comment: "a")
    
    static let folder = NSLocalizedString(LocalizedStringKeys.folder, comment: "a")
    static let archive = NSLocalizedString(LocalizedStringKeys.archive, comment: "a")
    static let trashbin = NSLocalizedString(LocalizedStringKeys.trashbin, comment: "a")
    
    static let selectFolder = NSLocalizedString(LocalizedStringKeys.selectFolder, comment: "a")
    static let newArchive = NSLocalizedString(LocalizedStringKeys.newArchive, comment: "A")
    
    static let category1 = NSLocalizedString(LocalizedStringKeys.category1, comment: "a")
    static let category2 = NSLocalizedString(LocalizedStringKeys.category2, comment: "a")
    static let category3 = NSLocalizedString(LocalizedStringKeys.category3, comment: "a")
    
    //    static let subCategory1 = NSLocalizedString(LocalizedStringKeys.subCategory1, comment: "a")
    
    static let done = NSLocalizedString(LocalizedStringKeys.done, comment: "done")
    static let keyboardDone = NSLocalizedString(LocalizedStringKeys.keyboardDone, comment: "done For keyBoard")
    
//    static let nth = NSLocalizedString(LocalizedStringKeys.nth, comment: "nth")
//    static let possessive = NSLocalizedString(LocalizedStringKeys.possessive, comment: "possessive")
    
    static let emptySearchResult = NSLocalizedString(LocalizedStringKeys.emptySearchResult, comment: "a")
    
    static let all = NSLocalizedString(LocalizedStringKeys.all, comment: "a")
    static let current = NSLocalizedString(LocalizedStringKeys.current, comment: "a")
    
    static let folderOrdering = NSLocalizedString(LocalizedStringKeys.folderOrdering, comment: "a")
    static let memoOrdering = NSLocalizedString(LocalizedStringKeys.memoOrdering, comment: "a")
    
    static let modificationDate = NSLocalizedString(LocalizedStringKeys.modificationDate, comment: "a")
    static let CreationDate = NSLocalizedString(LocalizedStringKeys.CreationDate, comment: "A")
    static let Alphabetical = NSLocalizedString(LocalizedStringKeys.Alphabetical, comment: "a")
    
    static let AscendingOrder = NSLocalizedString(LocalizedStringKeys.AscendingOrder, comment: "a")
    static let DecendingOrder = NSLocalizedString(LocalizedStringKeys.DecendingOrder, comment: "a")
    
    static let searchPlaceholder = NSLocalizedString(LocalizedStringKeys.searchPlaceholder, comment: "a")
    
    static func convertTypeToStorage(type: TextFieldAlertType) -> String {
        switch type {
        case .newSubFolder: return LocalizedStringStorage.newSubFolder
        case .newTopArchive: return LocalizedStringStorage.newArchive
        case .newTopFolder: return LocalizedStringStorage.newFolder
        case .rename: return LocalizedStringStorage.renameFolder
        }
    }
    
    static func convertSearchTypeToText(type: SearchType) -> String {
        switch type {
        case .all:
            return LocalizedStringStorage.all
        case .current:
            return LocalizedStringStorage.current
        }
    }
    
    static func convertOrderTypeToStorage(type: OrderType) -> String {
        switch type {
        case .modificationDate:
            return LocalizedStringStorage.modificationDate
        case .creationDate:
            return LocalizedStringStorage.CreationDate
        case .alphabetical:
            return LocalizedStringStorage.Alphabetical
        }
    }
}




//LocalizedStringStorage.
struct LocalizedStringKeys {
    
    static let done = "done"
    static let keyboardDone = "keyboardDone"
    
    static let removeAlertMsgMain = "removeAlertMsgMain"
    static let removeAlertMsgSub = "removeAlertMsgSub"
    
    static let cancelInSearch = "CancelInSearch"
    static let cancel = "Cancel"
    static let delete = "Delete"
    
    static let newFolder = "New Folder"
    static let renameFolder = "Rename Folder"
    static let newSubFolder = "New Sub Folder"
    static let newArchive = "New Archive"
    
    static let folder = "Folder"
    static let archive = "Archive"
    static let trashbin = "Trash Bin"
    
    static let selectFolder = "Select Folder"
    
    static let category1 = "category1"
    static let category2 = "category2"
    static let category3 = "category3"
    
    //    static let subCategory1 = "Sub Category 1"
    
//    static let nth = "th"
//    static let possessive = "'s"
    
    static let emptySearchResult = "Empty Search Result"
    
    static let all = "All"
    static let current = "Current"
    
    static let folderOrdering = "Folder Ordering"
    static let memoOrdering = "Memo Ordering"
    
    static let modificationDate = "Modification Date"
    static let CreationDate = "Creation Date"
    static let Alphabetical = "Alphabetical"
    
    static let AscendingOrder = "Ascending Order"
    static let DecendingOrder = "Decending Order"
 
    static let searchPlaceholder = "Search Placeholder"
}
