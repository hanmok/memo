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
    
    @FetchRequest(fetchRequest: Memo.bookMarkedFetchReq()) var memos: FetchedResults<Memo>
    
    var body: some View {
        
        // MARK: - FOR TESTING

        
//                UnitTestHelpers.deletesAllFolders(context: context)

        if topFolders.isEmpty {
//            Folder.returnSampleFolder2(context: context)
            Folder.returnSampleFolder3(context: context)
        }
        
        
//        return NavigationView {
//            MindMapView(
//                fastFolderWithLevelGroup:
//                    FastFolderWithLevelGroup(
//                        targetFolders: topFolders.sorted())

                //                , bookMarkedMemos: BookMarkedMemos(memos: memos.sorted())
            
        return NavigationView {
            MindMapView(
                 folderGroup: FolderGroup(targetFolders: topFolders.sorted()))
        }
        
        
        
    }
}



class FastFolderWithLevelGroup: ObservableObject {
    @Published var allFolders: [FolderWithLevel]
    
    init(targetFolders: [Folder]) {
        self.allFolders = Folder.getHierarchicalFolders(topFolders: targetFolders)
    }
}

class BookMarkedMemos: ObservableObject {
    @Published var markedMemos: [Memo]
    
    init(memos: [Memo]) {
        self.markedMemos = memos.filter { $0.isBookMarked == true }
    }
}
