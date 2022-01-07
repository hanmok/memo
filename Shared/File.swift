//
//  File.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/05.
//

import Foundation
import Combine
import CoreData

// give this class' selectedFolder default Folder of "Home"
class NavigationStateManager: ObservableObject {
    @Published var selectedFolder: Folder? = nil
    @Published var selectedMemo: Memo? = nil
    
//    이게.. 이렇게 작동하는게 아닐텐데 ?
//
//    init(_ selectedF: Folder? = nil) {
//        // if folder provided to navigationStateManager,
//        if selectedF != nil {
//            selectedFolder = selectedF!
//        } else {
//
//            let controller: PersistenceController!
//            let context = controller.container.viewContext
//            //
//            //        let request = NSFetchRequest<Folder>(entityName: "Folder")
//            //        request.sortDescriptors = [NSSortDescriptor(key: FolderProperties.order, ascending: true)]
//            //
//            //        let format = FolderProperties.parent + " = nil"
//            //        request.predicate = NSPredicate(format: format)
//
//            let parentFetch = Folder.topFolderFetch()
//            let parent = try? context.fetch(parentFetch)
//
//            if let validParents = parent {
//                if validParents.count != 0 {
//                    selectedFolder = validParents.first!
//                }
//            }
//            // no folder exist
//            let newHomeFolder = Folder(title:"Home Folder", context: context)
//            selectedFolder = newHomeFolder
//        }
//
//    }
}
