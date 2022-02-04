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


//class FolderViewModel: ObservableObject {
//
////    @Published
////    var navigationTargetFolder: Folder? = nil
//
//    @Published var cuttedFolders: [Folder] = []
//    @Published var copiedFolders: [Folder] = []
//
//    // how can i make it a published ?
//     var savedFolders: [Folder] {
//        var returnedFolders : [Folder] = []
//
//            if !cuttedFolders.isEmpty {
//                for each in cuttedFolders {
//                    returnedFolders.append(each)
//                }
//            }
//
//            if !copiedFolders.isEmpty {
//                for each in copiedFolders {
//                    returnedFolders.append(each)
//                }
//            }
//        return returnedFolders
//    }
//
//
//}

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



