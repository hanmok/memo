//
//  FolderEditing.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/21.
//

import Foundation
import CoreData

//enum FolderEditMode: String {
//    case create = "Create"
//    case edit = "Edit"
//}


class FolderEditViewModel: ObservableObject {
    //    @Published var folderEditMode: FolderEditMode? = nil
    
    var navigationTargetFolder: Folder? = nil
    
    @Published var shouldChangeFolderName = false
    
    var selectedFolder: Folder? = nil
    
    var targetFolder: Folder? = nil {
        didSet {
            for eachFolder in didCutFolders {
                targetFolder?.subfolders.update(with: eachFolder)
            }
            didCutFolders = []
        }
    }
    
    @Published var shouldAddFolder = false
    
    @Published var selectedFolders: [Folder] = []
    
    @Published var didCutFolders: [Folder] = []
    
    
}


class MemoEditViewModel: ObservableObject {
    
    //    var context: NSManagedObjectContext
    
    var testMemos: Memo? = nil
    
    @Published var hasSelected = false
    
//    @Published var shouldAddMemo = false
    @Published var shouldChangeColor = false
    
    @Published var selectedMemos = Set<Memo>()
    
    @Published var didCutMemos: [Memo] = []
    
    public var count: Int {
        selectedMemos.count
    }
    
    
    // after selecting several memos
    
    //    @Published var pinPressed = false {
    //        didSet {
    //            if oldValue == true {
    //                var allPinned = true
    //                for each in selectedMemos {
    //                    if each.pinned == false {
    //                        allPinned = false
    //                        break
    //                    }
    //                }
    //
    //                if !allPinned {
    //                    for each in selectedMemos {
    //                        each.pinned = true
    //                    }
    //                }
    //                context.saveCoreData()
    //            }
    //        }
    //    }
    
    //    init(context: NSManagedObjectContext) {
    //        self.context = context
    //    }
    
    
    func add(memo: Memo) {
        self.selectedMemos.update(with: memo)
    }
    
    //    var pinnedAction: ([Memo]) -> Void
    //    var cutAction: ([Memo]) -> Void
    //    var copyAction: ([Memo]) -> Void
    //    var changeColorAcion: ([Memo]) -> Void
    //    var removeAction: ([Memo]) -> Void
    
    // initializer 를 먼저 공부하는게 맞다.
    
    
    //    init(
    //        pinnedAction: @escaping ([Memo]) -> Void = { _ in },
    //        cutAction: @escaping ([Memo]) -> Void = { _ in
    ////            self.didCutMemos
    //        },
    //        copyAction: @escaping ([Memo]) -> Void = { _ in },
    //        changeColorAcion: @escaping ([Memo]) -> Void = { _ in },
    //        removeAction: @escaping ([Memo]) -> Void = { _ in }
    //    ) {
    //        self.pinnedAction = pinnedAction
    //        self.cutAction = cutAction
    //        self.copyAction = copyAction
    //        self.changeColorAcion = changeColorAcion
    //        self.removeAction = removeAction
    //    }
    
    
    
    
    
}
