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
    
    static let cancel = NSLocalizedString(LocalizedStringKeys.cancel, comment: "a")
    static let delete = NSLocalizedString(LocalizedStringKeys.delete, comment: "a")
    static let newFolder = NSLocalizedString(LocalizedStringKeys.newFolder, comment: "a")
    static let renameFolder = NSLocalizedString(LocalizedStringKeys.renameFolder, comment: "a")
    static let newSubFolder = NSLocalizedString(LocalizedStringKeys.newSubFolder, comment: "a")
    static let folder = NSLocalizedString(LocalizedStringKeys.folder, comment: "a")
    static let archive = NSLocalizedString(LocalizedStringKeys.archive, comment: "a")
    static let selectFolder = NSLocalizedString(LocalizedStringKeys.selectFolder, comment: "a")
}

//LocalizedStringStorage.
struct LocalizedStringKeys {
    static let removeAlertMsgMain = "removeAlertMsgMain"
    static let removeAlertMsgSub = "removeAlertMsgSub"
    static let cancel = "Cancel"
    static let delete = "Delete"
    static let newFolder = "New Folder"
    static let renameFolder = "Rename Folder"
    static let newSubFolder = "New Sub Folder"
    static let folder = "Folder"
    static let archive = "Archive"
    static let selectFolder = "Select Folder"
}
