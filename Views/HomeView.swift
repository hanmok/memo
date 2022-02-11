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
    
    @AppStorage("ordering") private(set) var order: Ordering = Ordering(folderType: "Modification Date", memoType: "Creation Date", folderAsc: true, memoAsc: false)
    
    @FetchRequest(fetchRequest: Folder.topFolderFetchReq()) var topFolders: FetchedResults<Folder>
//    @FetchRequest(fetchRequest: Folder.top)
    
    @FetchRequest(fetchRequest: Memo.bookMarkedFetchReq()) var memos: FetchedResults<Memo>
    
//    let shouldInitialize = true
    @State var shouldExecuteOne = true
    var body: some View {
        
        // MARK: - FOR TESTING

        
//                UnitTestHelpers.deletesAllFolders(context: context)

        // For Testing
//        DispatchQueue.main.async {
//            if true {
//                if shouldExecuteOne {
//                UnitTestHelpers.deletesAllFolders(context: context)
//                    shouldExecuteOne.toggle()
//                }
//                Folder.returnSampleFolder3(context: context)
//            }
//        }
        
        
        if topFolders.isEmpty {
//            Folder.returnSampleFolder2(context: context)
            Folder.returnSampleFolder3(context: context)
                }
        
        
        return NavigationView {
            MindMapView(
                fastFolderWithLevelGroup:
                    FastFolderWithLevelGroup(
                        homeFolder: Folder.fetchHomeFolder(context: context)!,
                        archiveFolder: Folder.fetchHomeFolder(context: context, fetchingHome: false)!),
                bookMarkedMemos: BookMarkedMemos(memos: memos.sorted()))
        }
        .onAppear {
            switch order.folderOrderType {
            case OrderType.modificationDate.rawValue:
                Folder.orderType = .modificationDate
            case OrderType.creationDate.rawValue:
                Folder.orderType = .creationDate
            case OrderType.alphabetical.rawValue:
                Folder.orderType = .alphabetical
            default:
                Folder.orderType = .modificationDate
            }
            switch order.folderAsc {
            case true :
                Folder.isAscending = true
            case false:
                Folder.isAscending = false
            }
        }
        
        //        return EmptyView()
        
//        return NavigationView {
//            MindMapView(
//                //                folderGroup: FolderGroup(targetFolders: topFolders.sorted()),
//                folderGroup: FolderGroup(targetFolders: Folder.fetchHomeFolder(context: context)),
//                bookMarkedMemos: BookMarkedMemos(memos: memos.sorted()))
//        }
    }
}




class FastFolderWithLevelGroup: ObservableObject {
    @Published var folders: [FolderWithLevel]
    @Published var archives: [FolderWithLevel]
    
    init(homeFolder: Folder, archiveFolder: Folder) {
        self.folders = Folder.getHierarchicalFolders(topFolder: homeFolder)
        self.archives = Folder.getHierarchicalFolders(topFolder: archiveFolder)
    }
}

class BookMarkedMemos: ObservableObject {
    @Published var markedMemos: [Memo]
    
    init(memos: [Memo]) {
        self.markedMemos = memos.filter { $0.isBookMarked == true }
    }
}
