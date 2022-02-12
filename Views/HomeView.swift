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
//    @FetchRequest(fetchRequest: Folder.top)
    
    @FetchRequest(fetchRequest: Memo.bookMarkedFetchReq()) var memos: FetchedResults<Memo>
//    @StateObject var folderOrderVM = FolderOrderVM()
//    let shouldInitialize = true
    @State var shouldExecuteOne = true
    var body: some View {
        
        // MARK: - FOR TESTING

        
//                UnitTestHelpers.deletesAllFolders(context: context)

//  //      For Testing
//        DispatchQueue.main.async {
//            if true {
//                if shouldExecuteOne {
//                UnitTestHelpers.deletesAllFolders(context: context)
//                    shouldExecuteOne.toggle()
//                    Folder.returnSampleFolder3(context: context)
//                }
//
//            }
//        }
        
        
        if topFolders.isEmpty {
//            Folder.returnSampleFolder2(context: context)
            Folder.returnSampleFolder3(context: context)
                }
        
        
//        return NavigationView {
//            MindMapView(
//                fastFolderWithLevelGroup:
//                    FastFolderWithLevelGroup(
//                        homeFolder: Folder.fetchHomeFolder(context: context)!,
//                        archiveFolder: Folder.fetchHomeFolder(context: context, fetchingHome: false)!,
//                        sortingMethod: folderOrderVM.sortingMethod),
//                bookMarkedMemos: BookMarkedMemos(memos: memos.sorted()))
//                .environmentObject(folderOrderVM)
//        }
        
        return NavigationView {
            MindMapView(
                fastFolderWithLevelGroup:
                    FastFolderWithLevelGroup(
                        homeFolder: Folder.fetchHomeFolder(context: context)!,
                        archiveFolder: Folder.fetchHomeFolder(context: context, fetchingHome: false)!
                        ),
                bookMarkedMemos: BookMarkedMemos(memos: memos.sorted()))
//                .environmentObject(folderOrderVM)
        }
        
        
//        .onAppear {
//            switch order.folderOrderType {
//            case OrderType.modificationDate.rawValue:
//                Folder.orderType = .modificationDate
//
//            case OrderType.creationDate.rawValue:
//                Folder.orderType = .creationDate
//            case OrderType.alphabetical.rawValue:
//                Folder.orderType = .alphabetical
//            default:
//                Folder.orderType = .modificationDate
//            }
//            switch order.folderAsc {
//            case true :
//                Folder.isAscending = true
//            case false:
//                Folder.isAscending = false
//            }
//        }
        
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
    
    var homeFolder: Folder
    var archive: Folder
    
    init(homeFolder: Folder, archiveFolder: Folder) {
        self.homeFolder = homeFolder
        self.archive = archiveFolder
        
        self.archives = Folder.getHierarchicalFolders(topFolder: archiveFolder)
        self.folders = Folder.getHierarchicalFolders(topFolder: homeFolder)
//        self.archives = returnFolders()
//        self.folders = returnFolders()
    }
    
    func returnFolders() -> [FolderWithLevel]{
       return [FolderWithLevel]()
    }
    
    @Published var isAscending = true
    {
        didSet {
            print("type has changed to \(isAscending)")
            switch orderType {
            case .creationDate:
                self.sortingMethod = oldValue ? {$0.creationDate < $1.creationDate} : {$0.creationDate >= $1.creationDate}
            case .modificationDate:
                self.sortingMethod = oldValue ? {$0.modificationDate! < $1.modificationDate!} : {$0.modificationDate! >= $1.modificationDate!}
            case .alphabetical:
                self.sortingMethod = oldValue ? {$0.title < $1.title} : {$0.title >= $1.title}
            }
        }
    }

    @Published var orderType: OrderType = .creationDate
    {
        willSet {
            print("type has changed to : \(newValue)")
            switch newValue {
            case .creationDate:
                self.sortingMethod = isAscending ? {$0.creationDate < $1.creationDate} : {$0.creationDate >= $1.creationDate}
            case .modificationDate:
                self.sortingMethod = isAscending ? {$0.modificationDate! < $1.modificationDate!} : {$0.modificationDate! >= $1.modificationDate!}
            case .alphabetical:
                self.sortingMethod = isAscending ? {$0.title < $1.title} : {$0.title >= $1.title}
            }
        }
    }
    
    // Default value is .. creation, by ascending order !
//    @Published var sortingMethod: (Folder, Folder) -> Bool = { _, _ in true}
    @Published var sortingMethod: (Folder, Folder) -> Bool = { $0.creationDate < $1.creationDate} {
        didSet {
            print("sortingMethod has changed")
            print(orderType.rawValue)
            print(isAscending)
            self.archives = getHierarchicalFolders(topFolder: archive)
            self.folders = getHierarchicalFolders(topFolder: homeFolder)
        }
    }
    
    func getHierarchicalFolders(topFolder: Folder) -> [FolderWithLevel] {
        print(#function)
        print(#line)
        print("func in VM has called")
//        print("getHierarchicalFolders triggered, sortingMemod : \(sortingMethod)")
        
            var currentFolder: Folder? = topFolder
            var level = 0
            var trashSet = Set<Folder>()
            var folderWithLevelContainer = [FolderWithLevel(folder: currentFolder!, level: level)]
            var folderContainer = [currentFolder]

        whileLoop: while (currentFolder != nil) {
            print("currentFolder: \(currentFolder!.id)")
            print(#line)
            if currentFolder!.subfolders.count != 0 {

                // check if trashSet has contained Folder of arrayContainer2
//                for folder in currentFolder!.subfolders.sorted(by: sortingMethod) {
                for folder in currentFolder!.subfolders.sorted(by: sortingMethod) {
                    if !trashSet.contains(folder) && !folderContainer.contains(folder) {
        //            if !trashSet.contains(folder) && !arrayContainer2 {
                        currentFolder = folder
                        level += 1
                        folderContainer.append(currentFolder!)
                        folderWithLevelContainer.append(FolderWithLevel(folder: currentFolder!, level: level))
                        continue whileLoop // this one..
                    }
                }
                // subFolders 가 모두 이미 고려된 경우.
                trashSet.update(with: currentFolder!)
            } else { // subfolder 가 Nil 인 경우
                trashSet.update(with: currentFolder!)
            }

            for i in 0 ..< folderWithLevelContainer.count {
                if !trashSet.contains(folderWithLevelContainer[folderWithLevelContainer.count - i - 1].folder) {

                    currentFolder = folderWithLevelContainer[folderWithLevelContainer.count - i - 1].folder
                    level = folderWithLevelContainer[folderWithLevelContainer.count - i - 1].level
                    break
                }
            }

            if folderWithLevelContainer.count == trashSet.count {
                break whileLoop
            }
        }
            return folderWithLevelContainer
        }
}

class BookMarkedMemos: ObservableObject {
    @Published var markedMemos: [Memo]
    
    init(memos: [Memo]) {
        self.markedMemos = memos.filter { $0.isBookMarked == true }
    }
}
