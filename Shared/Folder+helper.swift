//
//  Folder+helper.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/04.
//

import Foundation
import CoreData

extension Folder {
    
    convenience init(title: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = title
        
//        let request = Folder.topFolderFetch()
//        let result = try? context.fetch(request)
//        let maxFolder = result?.max(by: {$0.order < $1.order })
//        self.order = ( maxFolder?.order ?? 0 ) + 1
        
        self.modificationDate = Date()
        
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

        
        
    }
    
    static func fetch(_ predicate: NSPredicate)-> NSFetchRequest<Folder> {
        let request = NSFetchRequest<Folder>(entityName: "Folder")
//        request.sortDescriptors = [NSSortDescriptor(key: FolderProperties.order, ascending: true)]
        request.sortDescriptors = [NSSortDescriptor(key: FolderProperties.modificationDate, ascending: false)]
        request.predicate = predicate
        return request
    }
    
    static func topFolderFetch() -> NSFetchRequest<Folder> {
        let request = NSFetchRequest<Folder>(entityName: "Folder")
//        request.sortDescriptors = [NSSortDescriptor(key: FolderProperties.order, ascending: true)]
        request.sortDescriptors = [NSSortDescriptor(key: FolderProperties.modificationDate, ascending: false)]
        
        let format = FolderProperties.parent + " = nil"
        request.predicate = NSPredicate(format: format)
        return request
    }
    
    static func delete(_ folder: Folder) {
        if let context = folder.managedObjectContext {
            context.delete(folder)
            try? context.save()
        }
    }
    
    static func nestedFolder(context: NSManagedObjectContext) -> Folder {
        let parent = Folder(title: "parent", context: context)
        let child1 = Folder(title: "child1", context: context)
        let child2 = Folder(title: "child2", context: context)
        let child3 = Folder(title: "child3", context: context)
        
        parent.add(subfolder: child1)
        parent.add(subfolder: child2)
        child2.add(subfolder: child3)
        try? context.save()
        return parent
    }
}

struct FolderProperties {
    static let id = "id_"
    static let creationDate = "creationDate_"
    static let modificationDate = "modificationDate"
    static let title = "title_"
    static let order = "order"
    
    static let memos = "memos_"
    static let parent = "parent"
    static let subfolders = "subfolders_"
    
}

extension Folder : Comparable {
    public static func < (lhs: Folder, rhs: Folder) -> Bool {
//        lhs.order < rhs.order
        if lhs.modificationDate != nil && rhs.modificationDate != nil {
            return lhs.modificationDate! < rhs.modificationDate!
        } else {
            return true
        }
    }
}

extension Folder {
    static func createHomeFolder(context: NSManagedObjectContext) -> Folder {
        let home = Folder(title: "Home Folder", context: context)
        try? context.save()
        return home
    }
    
    static func returnSampleFolder(context: NSManagedObjectContext) -> Folder {
        let homeFolder = Folder(title: "Home Folder", context: context)
        let firstChildFolder = Folder(title: "child1", context: context)
        let secondChildFolder = Folder(title: "child2", context: context)
        let thirdChildFolder = Folder(title: "child3", context: context)
        let fourthChildFolder = Folder(title: "child4", context: context)
        
        homeFolder.add(subfolder: firstChildFolder)
        homeFolder.add(subfolder: secondChildFolder)
        homeFolder.add(subfolder: thirdChildFolder)
        homeFolder.add(subfolder: fourthChildFolder)
        
        let memo1 = Memo(title: "First Memo", contents: "Memo Contents1", context: context)
        let memo2 = Memo(title: "Second Memo", contents: "Memo Contents2", context: context)
        let memo3 = Memo(title: "Third Memo", contents: "Memo Contents3", context: context)
        let memo4 = Memo(title: "Fourth Memo", contents: "Memo Contents4", context: context)
        let memo5 = Memo(title: "Fifth Memo", contents: "Memo Contents5", context: context)
        let memo6 = Memo(title: "Sixth Memo", contents: "Memo Contents6", context: context)
        let memo7 = Memo(title: "Seventh Memo", contents: "Memo Contents7", context: context)
        let memo8 = Memo(title: "Eighth Memo", contents: "Memo Contents8", context: context)
        let memo9 = Memo(title: "Ninth Memo", contents: "Memo Contents9", context: context)
        
        let hmemo1 = Memo(title: "First Memo", contents: "Memo Contents1", context: context)
        let hmemo2 = Memo(title: "Second Memo", contents: "Memo Contents2", context: context)
        let hmemo3 = Memo(title: "Third Memo", contents: "Memo Contents3", context: context)
        let hmemo4 = Memo(title: "Fourth Memo", contents: "Memo Contents4", context: context)
        let hmemo5 = Memo(title: "Fifth Memo", contents: "Memo Contents5", context: context)
        let hmemo6 = Memo(title: "Sixth Memo", contents: "Memo Contents6", context: context)
        let hmemo7 = Memo(title: "Seventh Memo", contents: "Memo Contents7", context: context)
        let hmemo8 = Memo(title: "Eighth Memo", contents: "Memo Contents8", context: context)
        let hmemo9 = Memo(title: "Ninth Memo", contents: "Memo Contents9", context: context)
        
        firstChildFolder.add(memo: memo1)
        firstChildFolder.add(memo: memo2)
        firstChildFolder.add(memo: memo3)
        firstChildFolder.add(memo: memo4)
        firstChildFolder.add(memo: memo5)
        firstChildFolder.add(memo: memo6)
        firstChildFolder.add(memo: memo7)
        firstChildFolder.add(memo: memo8)
        firstChildFolder.add(memo: memo9)
        
        homeFolder.add(memo: hmemo1)
        homeFolder.add(memo: hmemo2)
        homeFolder.add(memo: hmemo3)
        homeFolder.add(memo: hmemo4)
        homeFolder.add(memo: hmemo5)
        homeFolder.add(memo: hmemo6)
        homeFolder.add(memo: hmemo7)
        homeFolder.add(memo: hmemo8)
        homeFolder.add(memo: hmemo9)
        
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
        
        for eachFolder in self.subfolders {
            print(eachFolder.title)
        }
        print("number of subfolders: \(self.subfolders.count)")
        print("parent: \(String(describing: self.parent?.title))")
        
        print("number of memos: \(self.memos.count)")
        for eachMemo in self.memos {
            print("memo info: ")
            eachMemo.getMemoInfo()
        }

    }
}

/*
var subfolders: [Folder] {
    var folders: [Folder] = []
    for eachFolder in folder.subfolders {
        folders.append(eachFolder)
    }
    return folders
}
*/

extension NSManagedObjectContext {
    func saveCoreData() { // save to coreData
        DispatchQueue.main.async {
            try? self.save()
        }
         }
}
