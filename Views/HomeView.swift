//
//  HomeView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/06.
//

import SwiftUI
import CoreData

struct HomeView: View { // top folder fetch
    
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    
    @FetchRequest(fetchRequest: Folder.topFolderFetchReq()) var topFolders: FetchedResults<Folder>
    
    
    @State var shouldExecuteOne = true
    
    var body: some View {
        

        //   // MARK: - For Testing, erasing all the datas
        
//                DispatchQueue.main.async {
//                    if true {
//                        if shouldExecuteOne {
////                            UnitTestHelpers.deletesAll2(context: context)
////                            UnitTestHelpers.deletesAllMemos(context: context)
////                            UnitTestHelpers.deletesAllFolders(context: context)
//                            shouldExecuteOne.toggle()
//                            let _ = Folder.returnSampleFolder3(context: context)
//                        }
//                    }
//                }

//        if topFolders.count < 2 {
//            let _ = Folder.returnSampleFolder3(context: context)
//        } else if topFolders.count > 2 {
//            _ = topFolders.map { Folder.delete($0)}
//            let _ = Folder.returnSampleFolder3(context: context)
//        }
        
        return NavigationView {
            MindMapView(
                fastFolderWithLevelGroup:
                    FastFolderWithLevelGroup(
                        homeFolder: topFolders.filter{ $0.title == FolderType.getFolderName(type: .folder)}.first!,
                        archiveFolder: topFolders.filter{$0.title == FolderType.getFolderName(type: .archive)}.first!
                    ), trashBinFolder: topFolders.filter { $0.title == FolderType.getFolderName(type: .trashbin)}.first!
            )
        }
    }
} 




class FastFolderWithLevelGroup: ObservableObject {
    
    @Published var folders: [FolderWithLevel]
    @Published var archives: [FolderWithLevel]

    
    @Published var homeFolder: Folder
    @Published var archive: Folder
    
    init(homeFolder: Folder, archiveFolder: Folder) {
        self.homeFolder = homeFolder
        self.archive = archiveFolder
        
        self.archives = Folder.getHierarchicalFolders(topFolder: archiveFolder)
        self.folders = Folder.getHierarchicalFolders(topFolder: homeFolder)
    }
}
