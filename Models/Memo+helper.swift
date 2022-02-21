//
//  Memo+helper.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/04.
//

import Foundation
import CoreData
import UIKit

extension Memo {
    
    convenience init(title: String, contents: String, context: NSManagedObjectContext) {
        self.init(context: context)
//        self.title = title
        self.creationDate = Date()
        self.contents = contents
        self.modificationDate = Date()
        context.saveCoreData()
        print("memo has created! ")
    }
    
    convenience init(title: String, contents: String, context: NSManagedObjectContext, modifiedAt: Date) {
        self.init(title: title, contents: contents, context: context)
        self.modificationDate = modifiedAt
        context.saveCoreData()
    }
    
    convenience init(contents: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.contents = contents
        self.creationDate = Date()
        self.modificationDate = Date()
        context.saveCoreData()
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
    
//    var title: String {
//        get { title_ ?? "" }
//        set { title_ = newValue }
//    }
    
    var contents: String {
        get { contents_ ?? ""}
        set { contents_ = newValue}
    }
    
    var titleToShow: String {
        get { titleToShow_ ?? "" }
        set { titleToShow_ = newValue }
    }
    
    var contentsToShow: String {
        get { contentsToShow_ ?? "" }
        set { contentsToShow_ = newValue }
    }
    
    var overview: String {
        get { overview_ ?? "" }
        set { overview_ = newValue }
    }
    
    var modificationDate: Date {
        get { modificationDate_ ?? Date() }
        set { modificationDate_ = newValue }
    }
    
    var pinned: Bool { // initialValue: false
        get { pinned_ }
        set { pinned_ = newValue }
    }
    
    var color: UIColor? {
        get {
            guard let hex = colorAsHex else { return nil }
            return UIColor(hex: hex)
        }
        set (newColor) {
            if let newColor = newColor {
                colorAsHex = newColor.toHex
            }
        }
    }
    
    var colorIndex: Int {
        get {
            Int(colorIndex_)
        }
        set (newValue) {
            colorIndex_ = Int64(newValue)
        }
    }
    // What do I need to do now .. ?
    // Getting a Color
//    let color = note.color
    
    // Setting a Color
//    note.color = UIColor(hex: "FF5F5B")
    
    

//    var colorAsInt: Int64 { // initialValue: 0
//        get { colorAsInt_ }
//        set { colorAsInt_ = newValue}
//    }
    
    
    
    static func fetch(_ predicate: NSPredicate) -> NSFetchRequest<Memo> {
        let request = NSFetchRequest<Memo>(entityName: "Memo")
//        request.sortDescriptors = [NSSortDescriptor(key: MemoProperties.order, ascending: true)]
        request.sortDescriptors = [NSSortDescriptor(key: MemoProperties.modificationDate, ascending: true)] // doesn't make change
        request.predicate = predicate
        return request
    }
    
    static func fetchAllmemos(context: NSManagedObjectContext) -> [Memo] {
        let req = Memo.fetch(.all)
        
        if let result = try? context.fetch(req) {
            return result
        } else {
            print("Error fetching all Memos")
            return []
        }
        
    }
    
    static func bookMarkedFetchReq() -> NSFetchRequest<Memo> {
        let req = NSFetchRequest<Memo>(entityName: "Memo")
        
        req.sortDescriptors = [NSSortDescriptor(key: MemoProperties.modificationDate, ascending: false)]
        
        let format = MemoProperties.isBookMarked + " = true"
        req.predicate = NSPredicate(format: format)
        return req
    }
    
    static func fetchBookMarked(context: NSManagedObjectContext) -> [Memo] {
        let req = bookMarkedFetchReq()
        
        if let result = try? context.fetch(req) {
            return result
        } else {
            print("Error fetching bookMarked Memos")
            return []
        }
    }
    
    static func delete(_ memo: Memo) {
        if let context = memo.managedObjectContext {
            context.delete(memo)
//            try? context.save()
            context.saveCoreData()
        }
    }
    
    static func copyMemo(target: Memo, context: NSManagedObjectContext) -> Memo {
//        let newMemo = Memo(title: target.title, contents: target.contents, context: context)
        let newMemo = Memo(contents: target.contents, context: context)
        newMemo.modificationDate = target.modificationDate
//        newMemo.pinned = target.pinned
        return newMemo
//        return Memo(title: target.title, contents: target.contents, context: context)
    }
}


extension Memo {
    
    func getMemoInfo() {
        print("getMemoInfo")
        print("memo.uuid: \(self.uuid)")
//        print("memo.title: \(self.title)")
        print("memo.creationDate: \(self.creationDate)")
        print("memo.contents: \(self.contents)")
        print("memo.modificationDate: \(String(describing: self.modificationDate))")
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

    // error has triggered HERE !! let TitleIndex = self.titleToShow.endIndex
    func saveTitleWithContentsToShow(context: NSManagedObjectContext) {
        var title: String {
            if let firstIndex = self.contents.firstIndex(of: "\n") {
                // if no title entered, means memo starts with "\n"
                if firstIndex == self.contents.index(self.contents.startIndex, offsetBy: 0)  {
                    return ""
                }
                
                let title = self.contents[..<firstIndex]
                
                return String(title)
                // no "\n" entered.
            } else {
                return ""
            }
        }
        
        self.titleToShow = title
        
        // what if .. titleToShow is Empty ?
        // title is too long if no title detected.
        
        if titleToShow != "" {
            var tempContentsToShow = self.contents
            while ( tempContentsToShow.first != "\n") {
                tempContentsToShow.removeFirst()
            }
            tempContentsToShow.removeFirst()
            
            self.contentsToShow = tempContentsToShow
            
//            let lastTitleIndex = self.titleToShow.endIndex
//            let distance = self.titleToShow.distance(from: self.titleToShow.startIndex, to: lastTitleIndex)
////            let distanceToInt = distance.
//            let distanceToInt = self.titleToShow.
//            print("lastTitleIndex: \(distance)")
//
//            print("contents: \(self.contents)")
//            var contentsToShowSaved = self.contents
//
//            for _ in distance {
//                contentsToShowSaved.removeFirst()
//            }
            
//            self.contentsToShow = contentsToShowSaved
            
//            self.contentsToShow = self.contents.replacingCharacters(in:  self.contents.startIndex ..< lastTitleIndex, with: "")
        }
        
        // remove spaces or enters from the very first part to use in MemoBoxView
        while(contentsToShow != "") {
            if contentsToShow.first! == " " || contentsToShow.first! == "\n"{
                contentsToShow.removeFirst()
            } else {
                break
            }
        }
        context.saveCoreData()
    }
    
    static func getSortingMethod(type: OrderType, isAsc: Bool) -> (Memo, Memo) -> Bool {
        switch type {
        case .creationDate:
            return isAsc ? {$0.creationDate < $1.creationDate} : {$0.creationDate >= $1.creationDate}
        case .modificationDate:
            return isAsc ? {$0.modificationDate < $1.modificationDate} : {$0.modificationDate >= $1.modificationDate}
        case .alphabetical:
            return isAsc ? {$0.contents < $1.contents} : {$0.contents >= $1.contents}
        }
    }
}



struct MemoProperties {
    static let id = "id_"
    static let creationDate = "creationDate_"
    static let modificationDate = "modificationDate_"
    static let title = "title_"
    static let order = "order"
    static let colorAsInt = "colorAsInt"
    static let contents = "contents_"
    static let overview = "overview_"
    
    static let folder = "folder"
    static let isBookMarked = "isBookMarked"
}

extension Memo {

    static var isAscending: Bool = false
    static var orderType: OrderType = .modificationDate

    // MARK: - Have TO FIX MODIFICATION DATE. it should not be nil for all.
    static func sortModifiedDate(_ lhs: Memo, _ rhs: Memo) -> Bool {
        if Memo.isAscending {
            return lhs.modificationDate < rhs.modificationDate
        } else {
            return lhs.modificationDate >= rhs.modificationDate
        }
    }

    static func sortCreatedDate(_ lhs: Memo, _ rhs: Memo) -> Bool {
        if Memo.isAscending {
            return lhs.creationDate < rhs.creationDate
        } else {
            return lhs.creationDate >= rhs.creationDate
        }
    }

    static func sortAlphabetOrder(_ lhs: Memo, _ rhs: Memo) -> Bool {
        if Memo.isAscending {
            return lhs.contents < rhs.contents
        } else {
            return lhs.contents >= rhs.contents
        }
    }
}



extension Memo: Comparable {
    
    public static func < (lhs: Memo, rhs: Memo) -> Bool {
        
//        switch Memo.orderType {
//        case .modificationDate :
//            return sortModifiedDate(lhs, rhs)
//        case .creationDate:
//            return sortCreatedDate(lhs, rhs)
//        case .alphabetical:
//            return sortAlphabetOrder(lhs, rhs)
//        }
//        return lhs.title < rhs.title
        return lhs.creationDate < rhs.creationDate
    }
}
