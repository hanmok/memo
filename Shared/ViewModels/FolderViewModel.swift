//
//  FolderViewModel.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/05.
//

import Foundation
import Combine

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
