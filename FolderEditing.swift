//
//  FolderEditing.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/21.
//

import Foundation

enum FolderEditMode: String {
    case create = "Create"
    case edit = "Edit"
}


class FolderEditVM: ObservableObject {
    var folderEditMode: FolderEditMode? = nil
}

enum MemoEditMode {
    case create
    case pin
    case cut
    case copy
    case changeColor
    case remove
}

class MemoEditVM: ObservableObject {
    var memoEditMode: MemoEditMode? = nil
}
