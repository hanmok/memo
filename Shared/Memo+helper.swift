//
//  Memo+helper.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/04.
//

import Foundation
import CoreData

extension Memo {
    
    convenience init(title: String, contents: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = title
        self.creationDate = Date()
        self.contents = contents
//        self.modificationDate = Date()
        try? context.save()
    }
    
    convenience init(title: String, contents: String, context: NSManagedObjectContext, modifiedAt: Date) {
        self.init(title: title, contents: contents, context: context)
//        self.modificationDate = modifiedAt
        try? context.save()
    }
    
    // these variables are not optionals.
    var uuid: UUID {
        get { uuid_ ?? UUID() }
        set { uuid_ = newValue }
    }
    
    var creationDate: Date {
        get { creationDate_ ?? Date() }
        set { creationDate_ = newValue }
    }
    
    var title: String {
        get { title_ ?? "" }
        set { title_ = newValue }
    }
    
    var contents: String {
        get { contents_ ?? ""}
        set { contents_ = newValue}
    }
    
    var overview: String {
        get { overview_ ?? "" }
        set { overview_ = newValue }
    }
    
//    var modificationDate: Date {
//        get { modificationDate_ ?? Date() }
//        set { modificationDate_ = newValue }
//    }
    
    var pinned: Bool { // initialValue: false
        get { pinned_ }
        set { pinned_ = newValue }
    }

    var colorAsInt: Int64 { // initialValue: 0
        get { colorAsInt_ }
        set { colorAsInt_ = newValue}
    }
    
    
    static func fetch(_ predicate: NSPredicate) -> NSFetchRequest<Memo> {
        let request = NSFetchRequest<Memo>(entityName: "Memo")
//        request.sortDescriptors = [NSSortDescriptor(key: MemoProperties.order, ascending: true)]
        request.sortDescriptors = [NSSortDescriptor(key: MemoProperties.modificationDate, ascending: true)] // doesn't make change
        request.predicate = predicate
        return request
    }
    
    static func delete(_ memo: Memo) {
        if let context = memo.managedObjectContext {
            context.delete(memo)
//            try? context.save()
            context.saveCoreData()
        }
    }
    
    static func copyMemo(target: Memo, context: NSManagedObjectContext) -> Memo {
        var newMemo = Memo(title: target.title, contents: target.contents, context: context)
//        newMemo.modificationDate = target.modificationDate
//        newMemo.pinned = target.pinned
        return newMemo
//        return Memo(title: target.title, contents: target.contents, context: context)
    }
}

extension Memo: Comparable {
    public static func < (lhs: Memo, rhs: Memo) -> Bool {
//        lhs.order < rhs.order
//        if lhs.modificationDate != nil && rhs.modificationDate != nil {
//            return lhs.modificationDate! > rhs.modificationDate! // make change
//        } else {
//            return true
//        }
        return true
    }
}

extension Memo {
    
    func getMemoInfo() {
        print("getMemoInfo")
        print("memo.uuid: \(self.uuid)")
        print("memo.title: \(self.title)")
        print("memo.creationDate: \(self.creationDate)")
        print("memo.contents: \(self.contents)")
//        print("memo.modificationDate: \(self.modificationDate)")
        print("memo.overview: \(self.overview)")
    }
    
    func setToSampleData() {
        UnitTestHelpers.deletesAllMemos(context: PersistenceController().container.viewContext)
        
    }
    func createSampleData() {
        
    }
    
    func removeAll() {
        
    }
    
    static let lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    
    static let longLorem = Memo.lorem + Memo.lorem + Memo.lorem + Memo.lorem + Memo.lorem
}

struct MemoProperties {
    static let id = "id_"
    static let creationDate = "creationDate_"
    static let modificationDate = "modificationDate"
    static let title = "title_"
    static let order = "order"
    static let colorAsInt = "colorAsInt"
    static let contents = "contents_"
    static let overview = "overview_"
    
    static let folder = "folder"
}
