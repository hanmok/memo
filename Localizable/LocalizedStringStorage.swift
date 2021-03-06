//
//  LocalizedStringStorage.swift
//  DeeepMemo (iOS)
//
//  Created by Mac mini on 2022/03/01.
//

import Foundation


enum LocalizedStringStorage {
    
    static let removeAlertMsgMain = StringEnum.removeAlertMsgMain.convertIntoStr()
    static let removeAlertMsgSub = StringEnum.removeAlertMsgSub.convertIntoStr()

    static let cancelInSearch = StringEnum.cancelInSearch.convertIntoStr()
    
    static let cancel = StringEnum.cancel.convertIntoStr()
    static let delete = StringEnum.delete.convertIntoStr()
    
    static let newFolder = StringEnum.newFolder.convertIntoStr()
    static let renameFolder = StringEnum.renameFolder.convertIntoStr()
    static let newSubFolder = StringEnum.newSubFolder.convertIntoStr()

    static let folder = StringEnum.folder.convertIntoStr()
    static let archive = StringEnum.archive.convertIntoStr()
    static let trashbin = StringEnum.trashbin.convertIntoStr()
    
    static let selectFolder = StringEnum.selectFolder.convertIntoStr()
    static let newArchive = StringEnum.newArchive.convertIntoStr()
    
    static let done = StringEnum.done.convertIntoStr()
    static let keyboardDone = StringEnum.keyboardDone.convertIntoStr()
    
    
    static let emptySearchResult = StringEnum.emptySearchResult.convertIntoStr()
    
    static let all = StringEnum.all.convertIntoStr()
    static let current = StringEnum.current.convertIntoStr()
    
    static let folderOrdering = StringEnum.folderOrdering.convertIntoStr()
    static let memoOrdering = StringEnum.memoOrdering.convertIntoStr()
    
    static let modificationDate = StringEnum.modificationDate.convertIntoStr()
    static let CreationDate = StringEnum.CreationDate.convertIntoStr()
    static let Alphabetical = StringEnum.Alphabetical.convertIntoStr()
    
    static let AscendingOrder = StringEnum.AscendingOrder.convertIntoStr()
    static let DecendingOrder = StringEnum.DecendingOrder.convertIntoStr()
    
    static let AlphabeticalOrder = StringEnum.AlphabeticalOrder.convertIntoStr()
    static let InverseOrder = StringEnum.InverseOrder.convertIntoStr()
    
    static let searchPlaceholder = StringEnum.searchPlaceholder.convertIntoStr()
    
    static let newFolderPlaceHolder = StringEnum.newFolderPlaceHolder.convertIntoStr()
    static let newArchivePlaceHolder = StringEnum.newArchivePlaceHolder.convertIntoStr()
    
    
    
    static let hasAddedToFolder = StringEnum.hasAddedToFolder.convertIntoStr()
    
    static let memosHasDeleted = StringEnum.memosHasDeleted.convertIntoStr()
    
    static let folderHasDeleted = StringEnum.folderHasDeleted.convertIntoStr()
    
    static let memosHasMovedToTrash = StringEnum.memosHasMovedToTrash.convertIntoStr()
    
    static let memosHasPinned = StringEnum.memosHasPinned.convertIntoStr()
    
    static let memosHasUnpinned = StringEnum.memosHasUnpinned.convertIntoStr()
    
//    static let memosHasBookmarked = StringEnum.memosHasBookmarked.convertIntoStr()
    static let oneMemoHasDeleted = StringEnum.oneMemoHasDeleted.convertIntoStr()
    static let oneMemoHasMovedToTrash = StringEnum.oneMemoHasMovedToTrash.convertIntoStr()
    static let oneMemoHasPinned = StringEnum.oneMemoHasPinned.convertIntoStr()
    static let oneMemoHasUnpinned = StringEnum.oneMemoHasUnpinned.convertIntoStr()
    
    static let bookmarkRemovingUpdateAlert = StringEnum.bookmarkRemovingUpdateAlert.convertIntoStr()
    
    static let completed = StringEnum.completed.convertIntoStr()
    
    
    static let pinOnTheTop = StringEnum.pinOnTheTop.convertIntoStr()
    static let inFolderOrder = StringEnum.inFolderOrder.convertIntoStr()
    static let hideArchive = StringEnum.hideArchive.convertIntoStr()
    
    static let memoSaved = StringEnum.memoSaved.convertIntoStr()
    
    static let folderCreated = StringEnum.folderCreated.convertIntoStr()
    
    static let createFolder = StringEnum.createFolder.convertIntoStr()
    static let moveToSubfolder = StringEnum.moveToSubfolder.convertIntoStr()
    
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



enum StringEnum: String {
    
    func convertIntoStr() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
    case done = "done"
    case keyboardDone = "keyboardDone"
    
    case removeAlertMsgMain = "removeAlertMsgMain"
    case removeAlertMsgSub = "removeAlertMsgSub"
    
    case cancelInSearch = "CancelInSearch"
    case cancel = "Cancel"
    case delete = "Delete"
    
    case newFolder = "New Folder"
    case renameFolder = "Rename Folder"
    case newSubFolder = "New Sub Folder"
    case newArchive = "New Archive"
    
    case folder = "Folder"
    case archive = "Archive"
    case trashbin = "Trash Bin"
    
    case selectFolder = "Select Folder"
    
    case emptySearchResult = "Empty Search Result"
    
    case all = "All location"
    case current = "Current location"
    
    case folderOrdering = "Folder Ordering"
    case memoOrdering = "Memo Ordering"
    
    case modificationDate = "Modification Date"
    case CreationDate = "Creation Date"
    case Alphabetical = "Alphabetical"
    
    case AscendingOrder = "Ascending Order"
    case DecendingOrder = "Decending Order"
 
    case AlphabeticalOrder = "Alphabetical Order"
    case InverseOrder = "Inverse Order"
    
    case searchPlaceholder = "Search Placeholder"
    
    case newFolderPlaceHolder = "New Folder PlaceHolder"
    case newArchivePlaceHolder = "New Archive PlaceHolder"
    
    
    
    // MARK: - MESSAGES
    
    case hasAddedToFolder = "hasAddedToFolder"
    
    case memosHasDeleted = "memosHasDeleted"
    case oneMemoHasDeleted = "oneMemoHasDeleted"
    
    case folderHasDeleted = "folderHasDeleted"
    
    case memosHasMovedToTrash = "memosHasMovedToTrash"
    case oneMemoHasMovedToTrash = "oneMemoHasMovedToTrash"
    
    case memosHasPinned = "memosHasPinned"
    case oneMemoHasPinned = "oneMemoHasPinned"
    
    case memosHasUnpinned = "memosHasUnpinned"
    case oneMemoHasUnpinned = "oneMemoHasUnpinned"
    
    case bookmarkRemovingUpdateAlert = "bookmarkRemovingUpdateAlert"
    
    case completed = "completed"
    
    case memoSaved = "memoSaved"
    
    case pinOnTheTop = "pinOnTheTop"
    case inFolderOrder = "inFolderOrder"
    case hideArchive = "hideArchive"
    
    case folderCreated = "folderCreated"
    case createFolder = "createFolder"
    
    case moveToSubfolder = "moveToSubfolder"
}
