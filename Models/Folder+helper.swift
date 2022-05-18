//
//  Folder+helper.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/04.
//

import Foundation
import CoreData
import SwiftUI


protocol Archive: Folder {
    var isArchive: Bool { get }
}

enum FolderTypeEnum: CaseIterable {
    case folder
    case archive
    case trashbin
}

struct FolderNames {
    var korName: String
    var engName: String
    
    init(type: FolderTypeEnum) {
        switch type {
        case .folder:
            self.korName = "폴더"
            self.engName = "Folder"
          
        case .archive:
            self.korName = "보관함"
            self.engName = "Archive"
        case .trashbin:
            self.korName = "삭제된 메모"
            self.engName = "Deleted Memos"
        }
    }
}

struct ContainedMemos {
    var folder: Folder
    var memos: [Memo]
    var memosCount: Int
}


struct FolderType {
    
    static func getFolderName(type: FolderTypeEnum) -> String {
        switch type {
        case .folder: return LocalizedStringStorage.folder
        case .archive: return LocalizedStringStorage.archive
        case .trashbin: return LocalizedStringStorage.trashbin
        }
    }
    
    static func getfolderImageName(type: FolderTypeEnum) -> String {
        switch type {
        case .folder: return "folder"
        case .archive: return "tray"
        case .trashbin: return "trash"
        }
    }
    
    
    static func compareName(_ target: String, with type: FolderTypeEnum) -> Bool {
        switch type {
            
        case .folder:
//            if target == "Folder" || target == "폴더" {
            if target == FolderNames(type: .folder).engName || target == FolderNames(type: .folder).korName {
                return true
            }
            
        case .archive:
//            if target == "Archive" || target == "보관함" {
            if target == FolderNames(type: .archive).engName || target == FolderNames(type: .archive).korName {
                return true
            }
            
        case .trashbin:
//            if target == "Deleted Memos" || target == "삭제된 메모"{
            if target == FolderNames(type: .trashbin).engName || target == FolderNames(type: .trashbin).korName {
                return true
            }
        }
        
        return false
    }
}


extension Folder {
    
    convenience init(title: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = title
        self.creationDate = Date()
        
        self.modificationDate = Date()
        
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
        get { modificationDate_ ?? Date() }
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
    
    
    
    // order should be starting from 1, cause user decide.
    // 5 1 3 4 2 , say some memo want order of 3
//    func add(memo: Memo, at index: Int64? = nil) {
    func add(memo: Memo) {
        memo.folder = self
        memo.modificationDate = Date()
    }
    
//    func add(memo: Memo) {
//        memo.folder = self
//    }
    
    
    
    // not modified like above to check which one is correct.
//    func add(subfolder: Folder, at index: Int64? = nil) {
    
    func add(subfolder: Folder) {
        
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
        // the same as     parent = nil
        let format = FolderProperties.parent + " = nil"
        request.predicate = NSPredicate(format: format)
        
        return request
    }
    
    static func fetchHomeFolder(context: NSManagedObjectContext, fetchingHome: Bool = true) -> Folder? {
        
        let folderType: FolderTypeEnum = fetchingHome ? .folder : .archive
        
        let req = Folder.topFolderFetchReq()
        
        // MARK: - recommend using guard
        
        if let result = try? context.fetch(req) {
            
            switch folderType {
            case .folder: return result.filter { FolderType.compareName($0.title, with: .folder)}.first!
            case .archive: return result.filter { FolderType.compareName($0.title, with: .archive)}.first!
            case .trashbin: return result.filter { FolderType.compareName($0.title, with: .trashbin)}.first!
            }
            
        } else {
            print("error fetching top Folders !!")
            return nil
        }
    }
    
    // 이거부터 수정해야겠는데.. ???
    // Use bottom func instead of this.
    static func delete(_ folder: Folder) {
        
        if let context = folder.managedObjectContext {
            context.delete(folder)
            
            context.saveCoreData()
            Folder.updateTopFolders(context: context)
        }
    }
    
    static func deleteWithoutUpdate(_ folder: Folder) {
        
        if let context = folder.managedObjectContext {
            context.delete(folder)
            context.saveCoreData()
        }
    }
    
    
    
    
    static func moveMemosToTrashAndDelete(from folder: Folder, to trash: Folder) {
        folder.memos.forEach { $0.folder = trash }
        if let context = folder.managedObjectContext {
            context.delete(folder)
            context.saveCoreData()
            
        }
    }
    
    static func updateTopFolders(context: NSManagedObjectContext) {
        let request = Folder.topFolderFetchReq()
        DispatchQueue.main.async {
            let result = try? context.fetch(request)
            result!.forEach { $0.title += "" }
        }

        context.saveCoreData()
    }
    
    static func relocateAll(from source: Folder, to target: Folder ) {
        source.subfolders.forEach {
            $0.parent = target
        }
        source.memos.forEach {
            $0.folder = target
        }
    }
    
    
    static func getSortedSubFolders(folder: Folder) -> [Folder] {
        @AppStorage(AppStorageKeys.fOrderType) var fOrderType = OrderType.creationDate
        @AppStorage(AppStorageKeys.fOrderAsc) var fOrderAsc = false
        
        let sortingMethod = Folder.getSortingMethod(type: fOrderType, isAsc: fOrderAsc)
        
        return folder.subfolders.sorted(by: sortingMethod)
    }
    
//    static func getHierarchicalFolders(topFolder: Folder) -> [FolderWithLevel] {
    
    static func getHierarchicalFolders(topFolders: [Folder]) -> [FolderWithLevel] {
        
        @AppStorage(AppStorageKeys.fOrderType) var fOrderType = OrderType.creationDate
        @AppStorage(AppStorageKeys.fOrderAsc) var fOrderAsc = false
        
        let sortingMethod = Folder.getSortingMethod(type: fOrderType, isAsc: fOrderAsc)
        
        var folderWithLevelContainer: [FolderWithLevel] = []
        var folderContainer: [Folder?] = []
        
        for eachTop in topFolders.sorted(by: sortingMethod) {
            
            var currentFolder: Folder? = eachTop
            var level = 0
            var trashSet = Set<Folder>()
            
            folderWithLevelContainer.append(FolderWithLevel(folder: currentFolder!, level: level))
            folderContainer.append(currentFolder)
            
        whileLoop: while (currentFolder != nil) {
            print("currentFolder: \(String(describing: currentFolder!.id))")
            print(#line)
            if currentFolder!.subfolders.count != 0 {
                
                // check if trashSet has contained Folder of arrayContainer2
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
        } // end of whileLoop
            
        } // end of for in loop
        
        return folderWithLevelContainer
    }
    
    static func getSortingMethod(type: OrderType, isAsc: Bool) -> (Folder, Folder) -> Bool {
        switch type {
        case .creationDate:
            return isAsc ? {$0.creationDate < $1.creationDate} : {$0.creationDate >= $1.creationDate}
        case .modificationDate:
            return isAsc ? {$0.modificationDate < $1.modificationDate} : {$0.modificationDate >= $1.modificationDate}
        case .alphabetical:
            return isAsc ? {$0.title < $1.title} : {$0.title >= $1.title}
        }
    }
    
        static func getHierarchicalFolders(topFolder: Folder) -> [FolderWithLevel] {
            
            @AppStorage(AppStorageKeys.fOrderType) var fOrderType = OrderType.creationDate
            @AppStorage(AppStorageKeys.fOrderAsc) var fOrderAsc = false
            
            let sortingMethod = Folder.getSortingMethod(type: fOrderType, isAsc: fOrderAsc)
            
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
                    for folder in currentFolder!.subfolders.sorted(by: sortingMethod) {
                        if !trashSet.contains(folder) && !folderContainer.contains(folder) {
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
        
        @AppStorage(AppStorageKeys.fOrderType) var fOrderType = OrderType.creationDate
        @AppStorage(AppStorageKeys.fOrderAsc) var fOrderAsc = false
        
        let sortingMethod = Folder.getSortingMethod(type: fOrderType, isAsc: fOrderAsc)
        
        
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
    
    static func returnContainedMemos(folder: Folder, onlyPinned: Bool = false ) -> [Memo] {
        
        @AppStorage(AppStorageKeys.mOrderType) var mOrderType = OrderType.modificationDate
        @AppStorage(AppStorageKeys.mOrderAsc) var mOrderAsc = false
        
        let sortingMethod = Memo.getSortingMethod(type: mOrderType, isAsc: mOrderAsc)
        
        var foldersContainer = [Folder]()
        var memosContainer = [Memo]()
        
        func getAllFolders(folder: Folder)  {
            let tempFolders = folder.subfolders
            
            if !tempFolders.isEmpty {
                 tempFolders.forEach {
                    foldersContainer.append($0)
                    getAllFolders(folder: $0)
                }
            }
        }
        
        func appendMemos(folder: Folder) {
            folder.memos.forEach { memosContainer.append($0)}
        }
        
        appendMemos(folder: folder)
        
        getAllFolders(folder: folder)
        
        foldersContainer.forEach { appendMemos(folder: $0)}
        
        if onlyPinned {
//            return memosContainer.filter { $0.isBookMarked == true}.sorted(by: sortingMethod)
            return memosContainer.filter { $0.isPinned == true}.sorted(by: sortingMethod)
        }
        
        return memosContainer
    }
    
    static func convertLevelIntoFolder(_ withLevels: [FolderWithLevel]) -> [Folder] {
        var folders: [Folder] = []
        
        withLevels.forEach { folders.append($0.folder)}
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
        case .modificationDate:
            return sortModifiedDate(lhs, rhs)
        case .creationDate:
            return sortCreatedDate(lhs, rhs)
        case .alphabetical:
            return sortAlphabetOrder(lhs, rhs)
        }
    }
}


extension Folder {
    
    static func provideInitialFolders(context: NSManagedObjectContext) -> [Folder] {
        print("provideInitialFolder triggered!!!!!!!!")
        let homeFolder = Folder(title: FolderType.getFolderName(type: .folder), context: context)
        
//        context.saveCoreData()
        
//        let subFolder1 = Folder(title: LocalizedStringStorage.category1, context: context)
//        let subFolder2 = Folder(title: LocalizedStringStorage.category2, context: context)
//        let subFolder3 = Folder(title: LocalizedStringStorage.category3, context: context)
//
//        subFolder1.creationDate = Date().advanced(by: 100)
//        subFolder2.creationDate = Date().advanced(by: 200)
//        subFolder3.creationDate = Date().advanced(by: 300)
//
//
//        homeFolder.add(subfolder: subFolder1)
//        homeFolder.add(subfolder: subFolder2)
//        homeFolder.add(subfolder: subFolder3)
//
//        subFolder1.modificationDate = Date().advanced(by: 100)
//        subFolder2.modificationDate = Date().advanced(by: 200)
//        subFolder3.modificationDate = Date().advanced(by: 300)

        let archive = Folder(title: FolderType.getFolderName(type: .archive), context: context)
        archive.title += ""
       
        let trashBin = Folder(title: FolderType.getFolderName(type: .trashbin), context: context)
        
        context.saveCoreData()
        return [homeFolder, archive, trashBin]
    }
    
    static func provideInitialFolder(context: NSManagedObjectContext) -> Folder {
        let homeFolder = Folder(title: FolderType.getFolderName(type: .folder), context: context)
        context.saveCoreData()
        return homeFolder
    }
}

extension Folder {
    func getFolderInfo() {
        print("folderInfo triggered")
        print("myFolderFlag")
        print("Folder.uuid: \(self.uuid)")
        print("Folder.title: \(self.title)")
        print("Folder.creationDate: \(self.creationDate)")
        
         self.subfolders.forEach { print($0.title)}
        print("number of subfolders: \(self.subfolders.count)")
        print("parent: \(String(describing: self.parent?.title))")
        
        print("number of memos: \(self.memos.count)")
        
         self.memos.forEach { $0.getMemoInfo()}
    }
    
    static func isBelongToArchive(currentfolder: Folder) -> Bool {
        var folder: Folder? = currentfolder
        
        while (folder!.parent != nil ) {
            folder = folder!.parent
        }
        
        if FolderType.compareName(folder!.title, with: .folder){
            return false
        }
        return true
    }
}

//extension Folder {
//    static func lookForResult(of keyword: String, target: [Folder]) -> [Folder] {
//        var resultFolders = [Folder]()
//        for eachFolder in target {
//            if eachFolder.title.lowercased().contains(keyword.lowercased()) {
//                resultFolders.append(eachFolder)
//            }
//        }
//        return resultFolders
//    }
//}

