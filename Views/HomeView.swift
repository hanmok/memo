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
    
    //    @AppStorage("ordering") private(set) var order: Ordering = Ordering(folderType: "Modification Date", memoType: "Creation Date", folderAsc: true, memoAsc: false)
    
    @FetchRequest(fetchRequest: Folder.topFolderFetchReq()) var topFolders: FetchedResults<Folder>
    
//        @FetchRequest(fetchRequest: Memo.bookMarkedFetchReq()) var memos: FetchedResults<Memo>
    
    @State var shouldExecuteOne = true
    
    var body: some View {
        
        // MARK: - FOR TESTING
        
        
        //   // MARK: - For Testing
//                DispatchQueue.main.async {
//                    if true {
//                        if shouldExecuteOne {
////                            UnitTestHelpers.deletesAll2(context: context)
////                            UnitTestHelpers.deletesAllMemos(context: context)
////                            UnitTestHelpers.deletesAllFolders(context: context)
//                            shouldExecuteOne.toggle()
//                            Folder.returnSampleFolder3(context: context)
//                        }
//                    }
//                }
//
//                return EmptyView()
    
        // 음 .. 처음부터,, FolderView 와 Archive 는 주어야하는데,, 어떻게 주지 ?
        
        return NavigationView {
            MindMapView(
                fastFolderWithLevelGroup:
                    FastFolderWithLevelGroup(
                        homeFolder: topFolders.filter{ $0.title == FolderType.getFolderName(type: .folder)}.first!,
                        archiveFolder: topFolders.filter{$0.title == FolderType.getFolderName(type: .archive)}.first!
                    )
            )
        }
        
        
        
//        return SearchView(fastFolderWithLevelGroup:
//                            FastFolderWithLevelGroup(
//                                homeFolder: topFolders.filter{ $0.title == FolderType.getFolderName(type: .folder)}.first!,
//                                archiveFolder: topFolders.filter{$0.title == FolderType.getFolderName(type: .archive)}.first!
//                            ), currentFolder: topFolders.filter{$0.title == FolderType.getFolderName(type: .archive)}.first!, showingSearchView: .constant(true))
         
//        return CustomSearchView(fastFolderWithLevelGroup:
//                            FastFolderWithLevelGroup(
//                                homeFolder: topFolders.filter{ $0.title == FolderType.getFolderName(type: .folder)}.first!,
//                                archiveFolder: topFolders.filter{$0.title == FolderType.getFolderName(type: .archive)}.first!
//                            ), currentFolder: topFolders.filter{$0.title == FolderType.getFolderName(type: .archive)}.first!, showingSearchView: .constant(true))
        
    }
} 




class FastFolderWithLevelGroup: ObservableObject {
    
    @Published var folders: [FolderWithLevel]
    @Published var archives: [FolderWithLevel]
//    @Published var allFolders: [FolderWithLevel]
    
    @Published var homeFolder: Folder
    @Published var archive: Folder
    
    init(homeFolder: Folder, archiveFolder: Folder) {
        self.homeFolder = homeFolder
        self.archive = archiveFolder
        
        self.archives = Folder.getHierarchicalFolders(topFolder: archiveFolder)
        self.folders = Folder.getHierarchicalFolders(topFolder: homeFolder)
//        self.allFolders = self.archives
    }
}
