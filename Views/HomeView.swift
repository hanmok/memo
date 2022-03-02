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
//                        homeFolder: topFolders.filter{ $0.title == FolderType.getFolderName(type: .folder)}.first!,
//                        homeFolder: topFolders.filter{ $0.title == "폴더" || $0.title == "Folder"}.first!,
                        homeFolder: topFolders.filter{ FolderType.compareName($0.title, with: .folder)}.first!,
//                        archiveFolder: topFolders.filter{$0.title == FolderType.getFolderName(type: .archive)}.first!
//                        archiveFolder: topFolders.filter{$0.title == "보관함" || $0.title == "Archive"}.first!
                        archiveFolder: topFolders.filter{FolderType.compareName($0.title, with: .archive)}.first!
                    )
            )
//                .environmentObject(TrashBinViewModel(trashBinFolder: topFolders.filter { $0.title == FolderType.getFolderName(type: .trashbin)}.first!))
                .environmentObject(TrashBinViewModel(trashBinFolder: topFolders.filter {
                    FolderType.compareName($0.title, with: .trashbin)}.first!))
//                    $0.title == "삭제된 메모" || $0.title == "Deleted Memos"}.first!))
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
