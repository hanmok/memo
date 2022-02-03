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


class FolderViewModel: ObservableObject {

//    @Published
//    var navigationTargetFolder: Folder? = nil

    @Published var cuttedFolders: [Folder] = []
    @Published var copiedFolders: [Folder] = []

    // how can i make it a published ?
     var savedFolders: [Folder] {
        var returnedFolders : [Folder] = []

            if !cuttedFolders.isEmpty {
                for each in cuttedFolders {
                    returnedFolders.append(each)
                }
            }

            if !copiedFolders.isEmpty {
                for each in copiedFolders {
                    returnedFolders.append(each)
                }
            }
        return returnedFolders
    }
    
    
}

class FolderEditViewModel: ObservableObject {
    //    @Published var folderEditMode: FolderEditMode? = nil
    
//    var navigationTargetFolder: Folder? = nil
    
    @Published var shouldChangeFolderName = false
    
//    @Published var shouldAddFolder = false
    
    @Published var shouldShowSelectingView = false
    
    var selectedFolder: Folder? = nil
    
//    var targetFolder: Folder? = nil { // target for what ?
//        didSet {
//            for eachFolder in didCutFolders {
//                targetFolder?.subfolders.update(with: eachFolder)
//            }
//            didCutFolders = []
//        }
//    }
    
    
    @Published var folderToPaste: Folder? = nil
    @Published var folderToCut: Folder? = nil
    
//    @Published var selectedFolders: [Folder] = []
    // make one folder movable. not plural.
//    @Published var didCutFolders: [Folder] = []
    
    
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
