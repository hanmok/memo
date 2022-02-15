//
//  Folder+helper.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/04.
//

import Foundation
import CoreData


protocol Archive: Folder {
    var isArchive: Bool { get }
}

enum FolderTypeEnum {
    case folder
    case archive
}

struct ContainedMemos {
    var folder: Folder
    var memos: [Memo]
    var memosCount: Int
}


struct FolderType {
    
    static func getFolderName(type: FolderTypeEnum) -> String {
        switch type {
        case .folder: return "Folder"
        case .archive: return "Archive"
        }
    }
    
    static func getfolderImageName(type: FolderTypeEnum) -> String {
        switch type {
        case .folder: return "folder"
        case .archive: return "tray"
        }
    }
}


extension Folder {
    
//    static var order:  = OrderType
//    static var orderType = OrderType.creationDate
    
    convenience init(title: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = title
        self.creationDate = Date()
        
        self.modificationDate = Date()
        
//        self.isFavorite = false
        DispatchQueue.global().async {
            context.saveCoreData()
        }
    }
    
// for test, when createdAt should be specified.
    convenience init(title: String, context: NSManagedObjectContext, createdAt: Date) {

        self.init(title: title, context: context)
        self.modificationDate = createdAt
        self.creationDate = createdAt
        
        DispatchQueue.global().async {
            context.saveCoreData()
        }
    }
    
    public override func awakeFromInsert() {
        setPrimitiveValue(Date(), forKey: FolderProperties.creationDate)
        setPrimitiveValue(UUID(), forKey: FolderProperties.id)
    }
    
    
    var uuid: UUID {
        get { uuid_ ?? UUID() }
        set { uuid_ = newValue }
    }
    
    var creationDate: Date{
        get { return creationDate_ ?? Date() }
        set { creationDate_ = newValue }
    }
    
    var modificationDate: Date {
        get { return modificationDate_ ?? Date() }
        set { modificationDate_ = newValue }
    }
    
    var title: String {
        get { return title_ ?? "" }
        set { title_ = newValue }
    }
    
    var memos: Set<Memo> {
        get { memos_ as? Set<Memo> ?? [] }
    }
    
    var subfolders: Set<Folder> {
        get { subfolders_ as? Set<Folder> ?? [] }
        set { subfolders_ = newValue as NSSet}
    }
    
    var children: [Folder]? {
        get { subfolders.sorted() }
    }
    
//    var id: UUID {
//        get { UUID()}
//    }
//    var isCollased: Bool {
//        get { isCollased}
//    }
    
//    var isFavorite: Bool {
//        get { return isFavorite_ ?? false}
//        set { isFavorite_ = newValue }
//    }
    
//    var modificationDate: Date {
//        get { modificationDate_ ?? Date() }
//        set { modificationDate_ = newValue }
//    }
    
    
    
    // order should be starting from 1, cause user decide.
    // 5 1 3 4 2 , say some memo want order of 3
    func add(memo: Memo, at index: Int64? = nil) {
//        let sortedOldMemos = self.memos.sorted()
//        // old original memos according to 'order'
//
//        // 3
//        if let index = index {
//            memo.order = Int64(index)
//            // set new memo's order to index ( -> 3)
//            // 5 1 3 4 2 -> filter memo order of 3, 4 and 5
//            let changeMemos = sortedOldMemos.filter { $0.order >= index }
//            for memo in changeMemos {
//                memo.order += 1
//            }
//            // 6 1 4 5 2 , and new memo of order 3
//        } else {
//            memo.order = ( sortedOldMemos.last?.order ?? 0 ) + 1
//        }
        memo.folder = self
        memo.modificationDate = Date()
    }
    
//    func add(memo: Memo) {
//        memo.folder = self
//    }
    
    
    
    // not modified like above to check which one is correct.
    func add(subfolder: Folder, at index: Int64? = nil) {
//        let oldFolders = self.subfolders.sorted()
        
//        if let index = index {
//            subfolder.order = index + 1
//            let changeFolders = oldFolders.filter { $0.order > index }
//            for folder in changeFolders {
//                folder.order += 1
//            }
//        } else {
//            subfolder.order = (oldFolders.last?.order ?? 0) + 1
//        }
        
        subfolder.parent = self
        self.modificationDate = Date() // update
        
        if let context = subfolder.managedObjectContext {
            context.saveCoreData()
        }
    }
    
    
    static func fetch(_ predicate: NSPredicate)-> NSFetchRequest<Folder> {
        let request = NSFetchRequest<Folder>(entityName: "Folder")
//        request.sortDescriptors = [NSSortDescriptor(key: FolderProperties.order, ascending: true)]
        request.sortDescriptors = [NSSortDescriptor(key: FolderProperties.modificationDate, ascending: true)]
        // temp
//        request.sortDescriptors = [NSSortDescriptor(key: FolderProperties.title, ascending: true)]
        request.predicate = predicate
        return request
    }
    
    static func topFolderFetchReq() -> NSFetchRequest<Folder> {
        let request = NSFetchRequest<Folder>(entityName: "Folder")
//        request.sortDescriptors = [NSSortDescriptor(key: FolderProperties.order, ascending: true)]
        request.sortDescriptors = [NSSortDescriptor(key: FolderProperties.modificationDate, ascending: true)]
        // temp
//        request.sortDescriptors = [NSSortDescriptor(key: FolderProperties.title, ascending: true)]
        
        let format = FolderProperties.parent + " = nil"
        request.predicate = NSPredicate(format: format)
        
        return request
    }
    
    static func fetchHomeFolder(context: NSManagedObjectContext, fetchingHome: Bool = true) -> Folder? {
        
        let folderType: FolderTypeEnum = fetchingHome ? .folder : .archive
        
        let req = Folder.topFolderFetchReq()
        
        // MARK: - recommend using guard
        
        if let result = try? context.fetch(req) {
            
//            result.map {
//                print($0.title)
//            }
//            result.removeFirst()
//            return result.last!
            switch folderType {
////                // Found Nil !
            case .folder: return result.filter { $0.title == FolderType.getFolderName(type: .folder)}.first!
//            case .folder: return result.first(where: title == FolderType.getFolderName(type: .folder))
            case .archive: return result.filter { $0.title == FolderType.getFolderName(type: .archive)}.first!
            }
            
        } else {
            print("error fetching top Folders !!")
            return nil
        }
    }
    
//    static func fetchArchiveFolder(context: NSManagedObjectContext) -> Folder? {
//        let req = Folder.topFolderFetchReq()
//        // MARK: - recommend using guard
//        if let result = try? context.fetch(req) {
//            return result.filter { $0.title == FolderType.getFolderName(type: .folder)}.first!
//        } else {
//            print("error fetching top Folders !!")
//            return nil
//        }
//    }
    
    static func delete(_ folder: Folder) {
        if let context = folder.managedObjectContext {
            context.delete(folder)
            
//            try? context.save()
            context.saveCoreData()
            Folder.updateTopFolders(context: context)
        }
    }
    
    static func updateTopFolders(context: NSManagedObjectContext) {
                let request = Folder.topFolderFetchReq()
                let result = try? context.fetch(request)
        
        _ = result!.map { $0.title += "" }

        //        for eachFolder in result! {
//            eachFolder.title += ""
//        }
        
        context.saveCoreData()
    }
    
//    static func nestedFolder(context: NSManagedObjectContext) -> Folder {
//        let parent = Folder(title: "parent", context: context)
//        let child1 = Folder(title: "child1", context: context)
//        let child2 = Folder(title: "child2", context: context)
//        let child3 = Folder(title: "child3", context: context)
//
//        parent.add(subfolder: child1)
//        parent.add(subfolder: child2)
//        child2.add(subfolder: child3)
//
//        context.saveCoreData()
//        return parent
//    }
    
//    static func getHierarchicalFolders(topFolder: Folder) -> [FolderWithLevel] {
    
    static func getHierarchicalFolders(topFolders: [Folder]) -> [FolderWithLevel] {
        
        //        var folderWithLevelContainer = [FolderWithLevel(folder: currentFolder!, level: level)]
        //        var folderContainer = [currentFolder]
        var folderWithLevelContainer: [FolderWithLevel] = []
        var folderContainer: [Folder?] = []
        
        for eachTop in topFolders.sorted() {
            
            
            
            //        var currentFolder: Folder? = topFolder
            var currentFolder: Folder? = eachTop
            var level = 0
            var trashSet = Set<Folder>()
            //        var folderWithLevelContainer = [FolderWithLevel(folder: currentFolder!, level: level)]
            //        var folderContainer = [currentFolder]
            folderWithLevelContainer.append(FolderWithLevel(folder: currentFolder!, level: level))
            folderContainer.append(currentFolder)
            
        whileLoop: while (currentFolder != nil) {
            print("currentFolder: \(String(describing: currentFolder!.id))")
            print(#line)
            if currentFolder!.subfolders.count != 0 {
                
                // check if trashSet has contained Folder of arrayContainer2
                for folder in currentFolder!.subfolders.sorted() {
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
        } // end of whileLoop
            
        } // end of for in loop
        
        return folderWithLevelContainer
    }
    
        static func getHierarchicalFolders(topFolder: Folder) -> [FolderWithLevel] {
    //        print("getHierarchicalFolders triggered, sortingMemod : \(sortingMethod)")
            print(#function)
            print(#line)
            print("func in VM has called")
                var currentFolder: Folder? = topFolder
                var level = 0
                var trashSet = Set<Folder>()
                var folderWithLevelContainer = [FolderWithLevel(folder: currentFolder!, level: level)]
                var folderContainer = [currentFolder]
    
            whileLoop: while (currentFolder != nil) {
                print(#line)
                if currentFolder!.subfolders.count != 0 {
    
                    // check if trashSet has contained Folder of arrayContainer2
                    for folder in currentFolder!.subfolders.sorted() {
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
    
    static func getHierarchicalFolders(topFolder: Folder?) -> [FolderWithLevel] {
//        print("getHierarchicalFolders triggered, sortingMemod : \(sortingMethod)")
        if topFolder == nil { return [] }
        print(#function)
        print(#line)
        print("func in VM has called")
            var currentFolder: Folder? = topFolder
            var level = 0
            var trashSet = Set<Folder>()
            var folderWithLevelContainer = [FolderWithLevel(folder: currentFolder!, level: level)]
            var folderContainer = [currentFolder]

        whileLoop: while (currentFolder != nil) {
            print(#line)
            if currentFolder!.subfolders.count != 0 {

                // check if trashSet has contained Folder of arrayContainer2
                for folder in currentFolder!.subfolders.sorted() {
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
    
    
    static func getSubFolders(topFolder: Folder) -> [Folder] {
        print(#function)
        print(#line)
        print("func in VM has called")
        var currentFolder: Folder? = topFolder
        
        var trashSet = Set<Folder>()
        
        var folderContainer1 = [currentFolder!]
        var folderContainer = [currentFolder]
        
    whileLoop: while (currentFolder != nil) {
        print(#line)
        if currentFolder!.subfolders.count != 0 {
            
            // check if trashSet has contained Folder of arrayContainer2
            for folder in currentFolder!.subfolders.sorted() {
                if !trashSet.contains(folder) && !folderContainer.contains(folder) {
                    currentFolder = folder
                    folderContainer.append(currentFolder!)
                    folderContainer1.append(currentFolder!)
                    continue whileLoop // this one..
                }
            }
            // subFolders 가 모두 이미 고려된 경우.
            trashSet.update(with: currentFolder!)
        } else { // subfolder 가 Nil 인 경우
            trashSet.update(with: currentFolder!)
        }
        
        for i in 0 ..< folderContainer1.count {
            if !trashSet.contains(folderContainer1[folderContainer1.count - i - 1]) {
                currentFolder = folderContainer1[folderContainer1.count - i - 1]
                break
            }
        }
        
        if folderContainer1.count == trashSet.count {
            break whileLoop
        }
    }
        return folderContainer1
    }
    
    static func returnContainedMemos(folder: Folder, onlyMarked: Bool = false ) -> [Memo] {
        
        var foldersContainer = [Folder]()
        var memosContainer = [Memo]()
        
        func getAllFolders(folder: Folder)  {
            let tempFolders = folder.subfolders
            
            if !tempFolders.isEmpty {
//                for eachFolder in tempFolders {
//                    foldersContainer.append(eachFolder)
//                    getAllFolders(folder: eachFolder)
//                }
                
                _ = tempFolders.map {
                    foldersContainer.append($0)
                    getAllFolders(folder: $0)
                }
                
            }
        }
        
        func appendMemos(folder: Folder) {
            _ = folder.memos.map { memosContainer.append($0)}
//            for eachMemo in folder.memos {
//                memosContainer.append(eachMemo)
//            }
        }
        
        appendMemos(folder: folder)
        
        getAllFolders(folder: folder)
        
        // get all memos from each of collected Folders
//        for eachFolder in foldersContainer {
//
//            appendMemos(folder: eachFolder)
//            print("memosContainer: \(memosContainer)")
//        }
        
        _ = foldersContainer.map { appendMemos(folder: $0)}
        
        if onlyMarked {
            return memosContainer.filter { $0.isBookMarked == true}.sorted()
        }
        
        return memosContainer
    }
    
//    static func returnContainedMemosWithFolder(folder: Folder, onlyMarked: Bool = false ) -> [ContainedMemos] {
//
//        var foldersContainer = [Folder]()
//        var memosContainer = [Memo]()
//
//        func getAllFolders(folder: Folder)  {
//            let tempFolders = folder.subfolders
//
//            if !tempFolders.isEmpty {
//                for eachFolder in tempFolders {
//                    foldersContainer.append(eachFolder)
//                    getAllFolders(folder: eachFolder)
//                }
//            }
//        }
//
//        func appendMemos(folder: Folder) {
//            for eachMemo in folder.memos {
//                memosContainer.append(eachMemo)
////                memosCount += 1
//            }
//        }
//
//        appendMemos(folder: folder)
//
//        getAllFolders(folder: folder)
//
//        // get all memos from each of collected Folders
//        for eachFolder in foldersContainer {
//
//            appendMemos(folder: eachFolder)
//            print("memosContainer: \(memosContainer)")
//        }
//
//        if onlyMarked {
//            return memosContainer.filter { $0.isBookMarked == true}.sorted()
//        }
//
//        return memosContainer
//    }
    
    func checkIfHasMemo() -> Bool {
        return false
    }
    
    
    static func convertLevelIntoFolder(_ withLevels: [FolderWithLevel]) -> [Folder] {
        var folders: [Folder] = []

//        for eachLevel in withLevels {
//            folders.append(eachLevel.folder)
//        }
        
        _ = withLevels.map { folders.append($0.folder)}
        return folders
    }
}

struct FolderProperties {
    static let id = "id"
    static let creationDate = "creationDate_"
    static let modificationDate = "modificationDate_"
    static let title = "title_"
    static let order = "order"
    
    static let memos = "memos_"
    static let parent = "parent"
    static let subfolders = "subfolders_"
    
}

extension Folder {
    
    static var isAscending: Bool = true
    static var orderType: OrderType = .creationDate
    
    static func sortModifiedDate(_ lhs: Folder, _ rhs: Folder) -> Bool {
        if Folder.isAscending {
            return lhs.modificationDate < rhs.modificationDate
        } else {
            return lhs.modificationDate >= rhs.modificationDate
        }
    }
    
    static func sortCreatedDate(_ lhs: Folder, _ rhs: Folder) -> Bool {
        if Folder.isAscending {
            return lhs.creationDate < rhs.creationDate
        } else {
            return lhs.creationDate >= rhs.creationDate
        }
    }
    
    static func sortAlphabetOrder(_ lhs: Folder, _ rhs: Folder) -> Bool {
        if Folder.isAscending {
            return lhs.title < rhs.title
        } else {
            return lhs.title >= rhs.title
        }
    }
}

extension Folder : Comparable {
    
    public static func < (lhs: Folder, rhs: Folder) -> Bool {
        
        switch Folder.orderType {
        case .modificationDate : return sortModifiedDate(lhs, rhs)
        case .creationDate:
            return sortCreatedDate(lhs, rhs)
        case .alphabetical:
            return sortAlphabetOrder(lhs, rhs)
        }
    }
}

//extension Folder {
//
//    static var isAscending: Bool = true
//    static var orderType: OrderType = .creationDate
//
//    static func sortModifiedDate(_ lhs: Folder, _ rhs: Folder) -> Bool {
//        if Folder.isAscending {
//            return lhs.modificationDate! < rhs.modificationDate!
//        } else {
//            return lhs.modificationDate! >= rhs.modificationDate!
//        }
//    }
//
//    static func sortCreatedDate(_ lhs: Folder, _ rhs: Folder) -> Bool {
//        if Folder.isAscending {
//            return lhs.creationDate < rhs.creationDate
//        } else {
//            return lhs.creationDate >= rhs.creationDate
//        }
//    }
//
//    static func sortAlphabetOrder(_ lhs: Folder, _ rhs: Folder) -> Bool {
//        if Folder.isAscending {
//            return lhs.title < rhs.title
//        } else {
//            return lhs.title >= rhs.title
//        }
//    }
//
//
//}

//extension Folder : Comparable {
//
//    public static func < (lhs: Folder, rhs: Folder) -> Bool {
//
//        lhs.creationDate > rhs.creationDate
//
////        switch Folder.orderType {
////        case .modificationDate:
////            return sortModifiedDate(lhs, rhs)
////        case .creationDate:
////            return sortCreatedDate(lhs, rhs)
////        case .alphabetical:
////            return sortAlphabetOrder(lhs, rhs)
////        }
//
////        return true
//    }
//}

extension Folder {
    
//    static func createHomeFolder(context: NSManagedObjectContext) -> Folder {
//        let home = Folder(title: "Home Folder", context: context)
//        context.saveCoreData()
//
//        return home
//    }
    
    
    
//    static func returnSampleFolder(context: NSManagedObjectContext) -> Folder {
//
//        let homeFolder = Folder(title: "Home Folder", context: context,createdAt: Date(timeIntervalSinceNow: 1))
//        let firstChildFolder = Folder(title: "child1", context: context,createdAt: Date(timeIntervalSinceNow: 2))
//        let secondChildFolder = Folder(title: "child2", context: context,createdAt: Date(timeIntervalSinceNow: 3))
//        let thirdChildFolder = Folder(title: "child3", context: context,createdAt: Date(timeIntervalSinceNow: 4))
//        let fourthChildFolder = Folder(title: "child4", context: context,createdAt: Date(timeIntervalSinceNow: 5))
//
//        homeFolder.add(subfolder: firstChildFolder)
//        homeFolder.add(subfolder: secondChildFolder)
//        homeFolder.add(subfolder: thirdChildFolder)
//        homeFolder.add(subfolder: fourthChildFolder)
//
//        let memo1 = Memo(title: "First Memo", contents: "Memo Contents1", context: context,modifiedAt: Date(timeIntervalSinceNow: 1))
//        let memo2 = Memo(title: "Second Memo", contents: "Memo Contents2", context: context,modifiedAt: Date(timeIntervalSinceNow: 2))
//        let memo3 = Memo(title: "Third Memo", contents: "Memo Contents3", context: context,modifiedAt: Date(timeIntervalSinceNow: 3))
//        let memo4 = Memo(title: "Fourth Memo", contents: "Memo Contents4", context: context,modifiedAt: Date(timeIntervalSinceNow: 4))
//        let memo5 = Memo(title: "Fifth Memo", contents: "Memo Contents5", context: context,modifiedAt: Date(timeIntervalSinceNow: 5))
//        let memo6 = Memo(title: "Sixth Memo", contents: "Memo Contents6", context: context,modifiedAt: Date(timeIntervalSinceNow: 6))
//        let memo7 = Memo(title: "Seventh Memo", contents: "Memo Contents7", context: context,modifiedAt: Date(timeIntervalSinceNow: 7))
//        let memo8 = Memo(title: "Eighth Memo", contents: "Memo Contents8", context: context,modifiedAt: Date(timeIntervalSinceNow: 8))
//        let memo9 = Memo(title: "Ninth Memo", contents: "Memo Contents9", context: context,modifiedAt: Date(timeIntervalSinceNow: 9))
//
//        let hmemo1 = Memo(title: "First Memo", contents: "Memo Contents1", context: context,modifiedAt: Date(timeIntervalSinceNow: 1))
//        let hmemo2 = Memo(title: "Second Memo", contents: "Memo Contents2", context: context,modifiedAt: Date(timeIntervalSinceNow: 2))
//        let hmemo3 = Memo(title: "Third Memo", contents: "Memo Contents3", context: context,modifiedAt: Date(timeIntervalSinceNow: 3))
//        let hmemo4 = Memo(title: "Fourth Memo", contents: "Memo Contents4", context: context,modifiedAt: Date(timeIntervalSinceNow: 4))
//        let hmemo5 = Memo(title: "Fifth Memo", contents: "Memo Contents5", context: context,modifiedAt: Date(timeIntervalSinceNow: 5))
//        let hmemo6 = Memo(title: "Sixth Memo", contents: "Memo Contents6", context: context,modifiedAt: Date(timeIntervalSinceNow: 6))
//        let hmemo7 = Memo(title: "Seventh Memo", contents: "Memo Contents7", context: context,modifiedAt: Date(timeIntervalSinceNow: 7))
//        let hmemo8 = Memo(title: "Eighth Memo", contents: "Memo Contents8", context: context,modifiedAt: Date(timeIntervalSinceNow: 8))
//        let hmemo9 = Memo(title: "Ninth Memo", contents: "Memo Contents9", context: context,modifiedAt: Date(timeIntervalSinceNow: 9))
//
//        firstChildFolder.add(memo: memo1)
//        firstChildFolder.add(memo: memo2)
//        firstChildFolder.add(memo: memo3)
//        firstChildFolder.add(memo: memo4)
//        firstChildFolder.add(memo: memo5)
//        firstChildFolder.add(memo: memo6)
//        firstChildFolder.add(memo: memo7)
//        firstChildFolder.add(memo: memo8)
//        firstChildFolder.add(memo: memo9)
//
//        homeFolder.add(memo: hmemo1)
//        homeFolder.add(memo: hmemo2)
//        homeFolder.add(memo: hmemo3)
//        homeFolder.add(memo: hmemo4)
//        homeFolder.add(memo: hmemo5)
//        homeFolder.add(memo: hmemo6)
//        homeFolder.add(memo: hmemo7)
//        homeFolder.add(memo: hmemo8)
//        homeFolder.add(memo: hmemo9)
//
//        context.saveCoreData()
//
//        return homeFolder
//    }
    
//    static func returnSampleFolder2(context: NSManagedObjectContext)  {
//
//        let newFolder1 = Folder(title: "Category 1", context: context)
//
//        newFolder1.creationDate = Date().advanced(by: 2)
//
//        let subFolder1 = Folder(title: "SubCategory 1", context: context)
//        let subFolder2 = Folder(title: "SubCategory 2", context: context)
//        let subFolder3 = Folder(title: "SubCategory 3", context: context)
//
//        subFolder1.creationDate = Date().advanced(by: 2)
//        subFolder2.creationDate = Date().advanced(by: 1)
//        subFolder3.creationDate = Date().advanced(by: 3)
//
//        subFolder1.modificationDate = Date().advanced(by: 2)
//        subFolder2.modificationDate = Date().advanced(by: 3)
//        subFolder3.modificationDate = Date().advanced(by: 1)
//
//        let newFolder2 = Folder(title: "Category 2", context: context)
//
//        newFolder1.add(subfolder: subFolder1)
//        newFolder1.add(subfolder: subFolder2)
//        newFolder1.add(subfolder: subFolder3)
//
//        newFolder2.creationDate = Date().advanced(by: 1)
//        // return TopFolders
//        // order
//        // 1. Alphabetical : SubCategory 1 > 2 > 3
//        // 1. Creation : SubCategory 2 > 1 > 3
//        // 1. Modification : SubCategory 3 > 1 > 2
//
////        return [newFolder1, newFolder2]
//    }
    
    static func returnSampleFolder3(context: NSManagedObjectContext)  {
        
//        let homeFolder = Folder(title: "Home Folder", context: context, createdAt: Date(timeIntervalSince1970: 0))
        let homeFolder = Folder(title: FolderType.getFolderName(type: .folder), context: context, createdAt: Date(timeIntervalSince1970: 0))
//        homeFolder.folderType = .home
        
        let subFolder1 = Folder(title: "Category 1", context: context)
        let subFolder2 = Folder(title: "Category 2", context: context)
        let subFolder3 = Folder(title: "Category 3", context: context)
        
        subFolder1.creationDate = Date().advanced(by: 200)
        subFolder2.creationDate = Date().advanced(by: 100)
        subFolder3.creationDate = Date().advanced(by: 300)
        

        
        

        homeFolder.add(subfolder: subFolder1)
        homeFolder.add(subfolder: subFolder2)
        homeFolder.add(subfolder: subFolder3)
        
        let newFolder2 = Folder(title: "Sub Category 2", context: context)
        subFolder1.add(subfolder: newFolder2)
        
        newFolder2.creationDate = Date().advanced(by: 1)
        
        
        subFolder1.modificationDate = Date().advanced(by: 200)
        subFolder2.modificationDate = Date().advanced(by: 300)
        subFolder3.modificationDate = Date().advanced(by: 100)
        
        
//        let archive = Folder(title: "Archive", context: context, createdAt: Date(timeIntervalSince1970: 1))
        let archive = Folder(title: FolderType.getFolderName(type: .archive), context: context, createdAt: Date(timeIntervalSince1970: 1))
        archive.title += ""
//        archive.folderType = .archive
        context.saveCoreData()
        // return TopFolders
        // order
        // In Asc Order
        // 1. Alphabetical : SubCategory 1 > 2 > 3
        // 1. Creation : SubCategory 2 > 1 > 3
        // 1. Modification : SubCategory 3 > 1 > 2
        
//        return [newFolder1, newFolder2]
    }
}

extension Folder {
    func getFolderInfo() {
        print("folderInfo triggered")
        print("myFolderFlag")
        print("Folder.uuid: \(self.uuid)")
        print("Folder.title: \(self.title)")
        print("Folder.creationDate: \(self.creationDate)")
        
//        for eachFolder in self.subfolders {
//            print(eachFolder.title)
//        }
        _ = self.subfolders.map { print($0.title)}
        print("number of subfolders: \(self.subfolders.count)")
        print("parent: \(String(describing: self.parent?.title))")
        
        print("number of memos: \(self.memos.count)")
//        for eachMemo in self.memos {
//            print("memo info: ")
//            eachMemo.getMemoInfo()
//        }
        _ = self.memos.map { $0.getMemoInfo()}
    }
    
    static func isBelongToArchive(currentfolder: Folder) -> Bool {
        var folder: Folder? = currentfolder
        
        while (folder!.parent != nil ) {
            folder = folder!.parent
        }
        
        if folder!.title == FolderType.getFolderName(type: .folder) {
            return false
        }
        return true
    }
}


extension NSManagedObjectContext {
    func saveCoreData() { // save to coreData
        DispatchQueue.main.async {
            do {
                try self.save()
            } catch {
                print("error occurred druing saving to CoreData \(error)")
            }
        }
    }
}
