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



extension Folder {
    static func provideTestingFolders(context: NSManagedObjectContext) -> [Folder] {
        
        let homeFolder = Folder(title: FolderType.getFolderName(type: .folder), context: context)
        
        let dailyFolder = Folder(title: "Daily", context: context)
        dailyFolder.parent = homeFolder
        
        let personalWork = Folder(title: "Personal Work", context: context)
        personalWork.parent = dailyFolder
        
        let apps = Folder(title: "Apps", context: context)
        apps.parent = personalWork
        
        let thisMemo = Folder(title: "This Memo", context: context)
        let calie = Folder(title: "Calie", context: context)
        [thisMemo, calie].forEach { $0.parent = apps }
        
        let plan = Folder(title: "Plan", context: context)
        let Diary = Folder(title: "Diary", context: context)
        
        [plan, Diary].forEach { $0.parent = dailyFolder }
        
        let work = Folder(title: "Work", context: context)
        work.parent = homeFolder
        
        let mainProject = Folder(title: "Main Project", context: context)
        mainProject.parent = work
        
        let mainTodo = Folder(title: "Todo", context: context)
        let mainDone = Folder(title: "Done", context: context)
        [mainTodo, mainDone].forEach { $0.parent = mainProject }
        

        let asap = Folder(title: "ASAP", context: context)
        asap.parent = mainTodo
        
        let subProject = Folder(title: "Sub Project", context: context)
        subProject.parent = work
        let subTodo = Folder(title: "Todo", context: context)
        let subDone = Folder(title: "Done", context: context)
        
        [subTodo, subDone].forEach { $0.parent = subProject }
        
        
        
        let archive = Folder(title: FolderType.getFolderName(type: .archive), context: context)
        archive.title += ""
        
        
        let trashBin = Folder(title: FolderType.getFolderName(type: .trashbin), context: context)
        
        context.saveCoreData()
        return [homeFolder, archive, trashBin]
    }
    
    static func provideTestingFolders2(context: NSManagedObjectContext) -> [Folder] {
        
        let homeFolder = Folder(title: FolderType.getFolderName(type: .folder), context: context)

        let cuisinePrac = Folder(title: "Cuisine Practice", context: context)
        
        let asian = Folder(title: "Asian", context: context)
        let korean = Folder(title: "Korean", context: context)
        let vietnamese = Folder(title: "Vietnamese", context: context)

        
        let western = Folder(title: "Western", context: context)
        let american = Folder(title: "American", context: context)
        let italian = Folder(title: "Italian", context: context)
        
        cuisinePrac.parent = homeFolder
        [asian, western].forEach { $0.parent = cuisinePrac }
        [korean, vietnamese].forEach { $0.parent = asian }
        [american, italian].forEach { $0.parent = western }
        
        let koreanPork = Memo(titleToShow: "Pork bones soup", contentsToShow: .SampleDatas.koreanPork, context: context)
        koreanPork.contents = "Pork bones soup" + "\n" + .SampleDatas.koreanPork
        koreanPork.isPinned = true
        let koreanChickenSoup = Memo(titleToShow: "Ginseng chicken soup", contentsToShow: .SampleDatas.koreanChicken, context: context)

        let koreanGopchang = Memo(titleToShow: "Gopchang Jeongol", contentsToShow: .SampleDatas.koreanGopchange, context: context)
        [koreanPork, koreanChickenSoup, koreanGopchang].forEach { $0.folder = korean }
        
        let vietBunCha = Memo(titleToShow: "Bun Cha", contentsToShow: .SampleDatas.vietBuncha, context: context)
        let vietPho = Memo(titleToShow: "Pho", contentsToShow: .SampleDatas.vietPho, context: context)
        [vietBunCha, vietPho].forEach { $0.folder = vietnamese }
        
//        let someItalian1 = Memo(contents: "some1", context: context)
        let someItalian1 = Memo(titleToShow: "Risotto", contentsToShow: .SampleDatas.italianRisotto, context: context)
        let someItalian2 = Memo(titleToShow: "Creamy Tomato Pasta", contentsToShow: .SampleDatas.italianPasta, context: context)
//        let someItalian2 = Memo(contents: "some2", context: context)
//        someItalian2.isPinned = true
        [someItalian1, someItalian2].forEach { $0.folder = italian }
        
        let someAmerican = Memo(titleToShow: "Mac and Cheese", contentsToShow: .SampleDatas.americanMacCheese, context: context)
        let someAmerican2 = Memo(titleToShow: "Buffalo Wings", contentsToShow: .SampleDatas.americanBuffalo, context: context)
        let someAmerican3 = Memo(titleToShow: "Chicago Pizza", contentsToShow: .SampleDatas.americanChicagoPizza, context: context)
//        someAmerican3.isPinned = true
        someAmerican3.contents = "Chicago Pizza \n" + .SampleDatas.americanChicagoPizza
        [someAmerican, someAmerican2, someAmerican3].forEach { $0.folder = american }
        
        let referenceLinks = Folder(title: "Reference Links", context: context)
        let dummyMemo1 = Memo(context: context)
            let dummyMemo2 = Memo(context: context)
            let dummyMemo3 = Memo(context: context)
            let dummyMemo4 = Memo(context: context)
        [dummyMemo1, dummyMemo2, dummyMemo3, dummyMemo4].forEach { $0.folder = referenceLinks }
        
        let archive = Folder(title: FolderType.getFolderName(type: .archive), context: context)
   
        archive.title += ""
        
        referenceLinks.parent = archive
        
        let trashBin = Folder(title: FolderType.getFolderName(type: .trashbin), context: context)
   let inTrash = Memo(context: context)
        inTrash.folder = trashBin
        context.saveCoreData()
        return [homeFolder, archive, trashBin]
    }
}

extension String {
    struct SampleDatas {
        static let koreanPork = """
Ingredients

2½ to 3 pounds of pork neck bones (or spine bones)
1 ounce ginger, sliced
2 tablespoons doenjang (Korean fermented bean paste)
2 dried Shiitake mushrooms
1 medium onion, sliced
1 large dried red chili pepper (or a few red chili peppers)
1 pound of napa cabbage, cut off the core
2 or 3 medium potatoes, peeled
8 ounces soybean sprouts, washed and strained
4 green onions, washed and cut into 2 inch long
1 green onion, chopped for garnish
8 to 12 perilla leaves, washed
6 garlic cloves, minced
3 tablespoons gochugaru (Korean hot pepper flakes)
1 tablespoon gochujang (Korean hot pepper paste)
3 tablespoons fish sauce
¼ cup deulkkae-garu (perilla seeds powder)
½ teaspoon ground black pepper
½ cup water
"""
        static let koreanChicken = """
            Ingredients
            
            2 cornish hens. Each hen weighs about 1½ pounds, a nice portion for 1 person.
            ½ cup short grain rice (or glutinous rice), rinsed and soaked in cold water for 1 hour.
            2 fresh ginseng roots, washed
            2 large dried jujubes, washed
            16 garlic cloves, washed and the tips are removed
            2 to 3 green onions, chopped
            kosher salt
            ground black pepper
            """
        
        static let koreanGopchange = """
Ingredients

300 grams of the large window
1 potato
1 king oyster mushroom
1 bag of enoki mushrooms
5 leaves of cabbage or 1 single cabbage
Half-haired tofu optional
3 large green onions more than I thought
Spinach optional
4 Cheongyang Peppers
1000 mm beef bone broth
3 tablespoons fine red pepper powder
5 tablespoons of red pepper paste
5 tablespoons soy sauce
50 grams of chopped garlic
2 tablespoons of mirin
1 tablespoon sugar
1 teaspoon ginger juice
A little pepper
100 grams of noodles soak then weigh
1 frozen udon noodles
Rice laver chives
"""
        
        
        static let vietBuncha = """
Ingredients

250 - 300 g/8 - 10 oz pork mince (ground pork)(Note 1) 1 tbsp fish sauce (Note 2) 2 tsp white sugar 1/3 cup finely chopped green onions / scallions 1 clove garlic , minced Pinch of white pepper and salt 2 tsp lemongrass paste or fresh finely chopped , optional (Note 4) 1 1/2 tbsp oil , for cooking


 3 tbsp white sugar 3 tbsp fish sauce (Note 2) 2 tbsp rice wine vinegar 2 tbsp lime juice 1/3 cup water 1 birds eye chilli , seeded and finely chopped (Note 3) 3 cloves garlic , finely chopped

 100 g / 3.5 oz vermicelli noodles , dried Big handful beansprouts Few lettuce leaves , folded or shredded Julienned carrot and white radish (daikon), optional quick pickle (Note 5) Handful of coriander/cilantro sprigs , mint Sliced red chilli , lime wedges (optional)
"""
        
        static let vietPho = """
Ingredients
 2 large onions , halved 150g / 5oz ginger , sliced down the centre
 10 star anise 4 cinnamon quills 4 cardamon pods 3 cloves (the spice cloves!) 1.5 tbsp coriander seeds

BEEF BONES (NOTE 1):
  1.5kg / 3lb beef brisket 1kg / 2lb meaty beef bones 1kg / 2lb marrow bones (leg, knuckle), cut to reveal marrow 3.5 litres / 3.75 quarts water (15 cups)


SEASONING:
  2 tbsp white sugar 1 tbsp salt 40 ml / 3 tbsp fish sauce (Note 2)


NOODLE SOUP - PER BOWL:
  50g / 1.5 oz dried rice sticks (or 120g/4oz fresh) (Note 3) 30g / 1 oz beef tenderloin, raw, very thinly sliced (Note 4) 3 - 5 brisket slices (used for broth)
"""
        
        static let americanChicagoPizza = """
Ingredients

1 teaspoon granulated sugar
1 packet (2 1/4 teaspoons) active dry yeast
18 ounces all-purpose flour (about 3 1/2 cups)
2 teaspoons fine sea salt
1/8 teaspoon cream of tartar
1/2 cup plus 3 tablespoons corn oil, plus additional for oiling the bowl
1 tablespoon melted unsalted butter
12 ounces deli sliced part skim mozzarella
1 pound bulk Italian sausage
8 ounces thinly sliced pepperoni
One 28-ounce can whole San Marzano tomatoes, crushed by hand
Grated Parmesan, for topping and garnish


Directions

Mix sugar, yeast and 11 ounces room temperature water (about 80 degrees) in a bowl and let bloom for 15 minutes. Combine flour, salt and cream of tartar in the bowl of a stand mixer.
Once yeast has bloomed, add to dry ingredients along with corn oil. Gently combine with a rubber spatula until a rough ball is formed.

Knead on low speed with the dough hook for 90 seconds. Transfer to a lightly oiled bowl and proof until doubled in size, about 6 hours. Punch down and let dough settle for 15 more minutes.

Position an oven rack in the middle of the oven and preheat to 450 degrees F.
Coat bottom and sides of a 12-inch cake pan or traditional Chicago style pizza pan with melted butter. Using your hands, spread out about three-quarters of the dough across the bottom and up the sides of the pan (save the remainder for another use). Cover entire bottom in mozzarella, all the way up to the edge.

Cover half with a thin, even layer of raw sausage. Cover the other half with the pepperoni. Top with a couple handfuls of crushed tomatoes. Spread out with hands to the edge. Sprinkle top evenly with grated Parm.
Bake, rotating halfway through, until golden around the edge, about 25 minutes. Let rest for about 5 minutes, then either gently lift pizza out of pan or just cut your slice out of the pan like a pie!
"""
        
        static let americanBuffalo = """
Ingredients
 4 lb / 2kg chicken wings, wingettes & drumettes (Note 1) 5 teaspoons baking powder (NOT baking soda / bi-carb soda) (Note 2) 3/4 teaspoons salt 4 tbsp (60g) unsalted butter, melted 1/2 cup Frank’s Original Red Hot Sauce (Note 3)  1 tbsp brown sugar 1/4 tsp salt 1/2 cup crumbled blue cheese, softened (I use gorgonzola) 1/2 cup sour cream 1/4 cup mayonnaise 1 clove small garlic, minced 1 - 3 tbsp milk 2 tbsp lemon juice 1/2 tsp salt Black pepper Celery sticks Lots of beer!
"""
        
        static let americanMacCheese = """
Ingredients

1 (8 ounce) box elbow macaroni ¼ cup butter ¼ cup all-purpose flour ½ teaspoon salt ground black pepper to taste 2 cups milk 2 cups shredded Cheddar cheese
"""
        static let italianRisotto = """
Ingredients

6 cups low-sodium chicken stock, or vegetable stock
2 tablespoons olive oil
1 shallot, finely chopped
1 lb shiitake mushroom(455 g), stemmed and thinly sliced
2 tablespoons unsalted butter
2 cloves garlic, minced
1 teaspoon fresh thyme, finely chopped
salt, to taste
pepper, to taste
1 ½ cups arborio rice(200 g)
½ cup white wine(120 mL)
1 cup grated parmesan cheese(110 g), plus more for serving
¼ cup fresh parsley(10 g), for serving
"""
        
        static let italianPasta = """
Ingredients

300g/10 oz spaghetti 2 tbsp / 30g unsalted butter 3 garlic cloves , minced ½ onion , finely chopped 1 cup / 250 ml tomato passata / tomato puree (Note 1) 3/4 cup / 185 ml heavy / thickened cream (Note 2 for subs) 1/2 cup / 125 ml milk , low fat 3/4 cup / 30g parmesan , finely freshly grated (Note 3) 1 tsp dried basil, or other herb of choice 1 tsp chicken or vegetable stock powder , or 1 bouillon cube, crumbled (Note 4) Finely ground pepper + salt
"""
    }
    
    
}
