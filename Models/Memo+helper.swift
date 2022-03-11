//
//  Memo+helper.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/04.
//

import Foundation
import CoreData
import UIKit
import SwiftUI

extension Memo {
    
    convenience init(title: String, contents: String, context: NSManagedObjectContext) {
        self.init(context: context)
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
    
    
    var modificationDate: Date {
        get { modificationDate_ ?? Date() }
        set { modificationDate_ = newValue }
    }
    
    var isPinned: Bool { // initialValue: false
        get { isPinned_ }
        set { isPinned_ = newValue }
    }
    
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
    
    static func delete(_ memo: Memo) {
        if let context = memo.managedObjectContext {
            context.delete(memo)
            context.saveCoreData()
        }
    }
    // topFolder 가 업데이트되면, Folder 로 이동.. 어떻게 해결하지..?
        // 1. trashBin 이 Folder 가 아니면 됨.
    // 2.
    // this function makes bug.. why??
    static func makeNotBelongToFolder(_ memo: Memo, _ trash: Folder) {
        if let context = memo.managedObjectContext {
            memo.modificationDate = Date() // it's not the problem..
            memo.folder = nil
            // make topFolder update, which navigate to prev Folder for subFolder
//            memo.folder = trash

            context.saveCoreData()
        }
    }
    
    static func moveToTrashBin(_ memo: Memo, _ trash: Folder) {
        if let context = memo.managedObjectContext {
            memo.modificationDate = Date() // it's not the problem..
//            memo.folder = nil
            // make topFolder update, which navigate to prev Folder for subFolder
            memo.folder = trash

            context.saveCoreData()
        }
    }
    
    
}


extension Memo {
    
    func getMemoInfo() {
        print("getMemoInfo")
        print("memo.uuid: \(self.uuid)")
        print("memo.creationDate: \(self.creationDate)")
        print("memo.contents: \(self.contents)")
        print("memo.modificationDate: \(String(describing: self.modificationDate))")
    }
    
//    func setToSampleData() {
//        UnitTestHelpers.deletesAllMemos(context: PersistenceController().container.viewContext)
//    }
    

    static let lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    
    static let longLorem = Memo.lorem + Memo.lorem + Memo.lorem + Memo.lorem + Memo.lorem

    // 계속 수정해주어야 하는 코드..
    // error has triggered HERE !! let TitleIndex = self.titleToShow.endIndex
    
    
    // 여기 함수에 뭔가 문제가 있구나? 하아....
//    func saveTitleWithContentsToShow(context: NSManagedObjectContext) {
//
//        var title: String {
//            if let firstIndex = self.contents.firstIndex(of: "\n") {
//                // if no title entered, means memo starts with "\n"
//                // 음.. 공백으로 이어지다가 Enter 가 나올수도 있음..
//
//                // very first character is "\n"
//                if firstIndex == self.contents.index(self.contents.startIndex, offsetBy: 0)  {
//                    return ""
//
//                } else {
//
//                    let offsetLimit = self.contents.distance(from: self.contents.startIndex, to: firstIndex)
//                    var offsetIndex = 0
//
//                    // if ..spaces continues to the first \n
//                    while (self.contents[self.contents.index(self.contents.startIndex, offsetBy: offsetIndex)] == " ") && offsetIndex < offsetLimit {
//                        offsetIndex += 1
//                    }
//                    // first line is filled with spaces.
//                    if offsetIndex == offsetLimit {
//                        return ""
//                    } else {
//                        let title = self.contents[..<firstIndex]
//                        return String(title)
//                    }
//                }
//
//                // no "\n" entered.
//            } else {
//                return self.contents
//            }
//        }
//
//        self.titleToShow = title
//
//
//        if self.titleToShow != "" {
//            var tempContentsToShow = self.contents
//
//            for _ in 0 ..< self.titleToShow.count {
//                tempContentsToShow.removeFirst()
//            }
//            // remove \n
//            if tempContentsToShow.first == "\n" {
//                tempContentsToShow.removeFirst()
//            }
//
//            self.contentsToShow = tempContentsToShow
//        }
//
//        // remove spaces or enters from the very first part to use in MemoBoxView
//
//        while(self.contentsToShow != "") {
//            if self.contentsToShow.first! == " " || self.contentsToShow.first! == "\n"{
//                self.contentsToShow.removeFirst()
//            } else {
//                break
//            }
//        }
//        context.saveCoreData()
//    }
    
    func saveTitleWithContentsToShow(context: NSManagedObjectContext) {
            
            var title: String {
                if let firstIndex = self.contents.firstIndex(of: "\n") {
                    
                    // if no title entered, means memo starts with "\n"
                    // very first character is "\n"
                    // case 3
                    if firstIndex == self.contents.index(self.contents.startIndex, offsetBy: 0)  {
                        return ""
                        
                        // 공백으로 이어지다가 Enter 가 나올수도 있음..
                    } else {
                        let offsetLimit = self.contents.distance(from: self.contents.startIndex, to: firstIndex)
                        var offsetIndex = 0
                        
                        // if ..spaces continues to the first \n
                        while (self.contents[self.contents.index(self.contents.startIndex, offsetBy: offsetIndex)] == " ") && offsetIndex < offsetLimit {
                            offsetIndex += 1
                        }
                        // first line is filled with only spaces.
                        if offsetIndex == offsetLimit {
                            return ""
                        } else { // \n 가 나오기 전까지를 title로, case 1 and 2
                            let title = self.contents[..<firstIndex]
                            return String(title)
                        }
                    }
                    // case 2
                    // no "\n" entered.
                } else {
                    return self.contents
                }
            }
            
            self.titleToShow = title
            
            
            if self.titleToShow != "" {
                var tempContentsToShow = self.contents
                // Title 글자만큼 tempContentsToShow 글자 제거.
                for _ in 0 ..< self.titleToShow.count {
                    tempContentsToShow.removeFirst()
                }
                // remove \n
                if tempContentsToShow.first == "\n" {
                    tempContentsToShow.removeFirst()
                }
                self.contentsToShow = tempContentsToShow
            } else { // titleToShow == ""
                contentsToShow = contents
            }
            // 현재 ContentsToShow 의 첫부분에 공백이 끼어있을 수 있음.
            
            // remove spaces or enters from the very first part to use in MemoBoxView
            // 스페이스와 \n 이 골고루 섞여있는 경우,, 판별을 어떻게 할것인가?  해당 라인에 Contents 가 포함되어있는지.. 를 봐야하는데...
           
            var emptySpacesTillEnter = 0
            
            // 만약,, 모두 space, \n 으로 이루어져 있는 경우, 에러가 생긴다.
            // 카운트가 필요함.
            
            while(self.contentsToShow.count > emptySpacesTillEnter){
                print("loops continues.. ")
                print("count: \(self.contentsToShow.count)")
                print("emptySpaces: \(emptySpacesTillEnter)")
            if self.contentsToShow[self.contentsToShow.index(self.contentsToShow.startIndex, offsetBy: emptySpacesTillEnter)] == " "{
                
                emptySpacesTillEnter += 1
                
            } else if self.contentsToShow[self.contentsToShow.index(self.contentsToShow.startIndex, offsetBy: emptySpacesTillEnter)] == "\n" {
                
                if emptySpacesTillEnter != 0 {
                for _ in 0 ..< emptySpacesTillEnter {
                    self.contentsToShow.removeFirst()
                }
                } else {
                    self.contentsToShow.removeFirst()
                }
                
                emptySpacesTillEnter = 0
                
            } else {
                break
            }
            
        }
            
//            while(self.contentsToShow != "") {
//                if self.contentsToShow.first! == " " || self.contentsToShow.first! == "\n"{
//                    //            if self.contentsToShow.first! == "\n"{
//                    self.contentsToShow.removeFirst()
//                } else {
//                    break
//                }
//            }
            context.saveCoreData()
        }
}

extension Memo {
    
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
    
    static func sortMemos(memos: [Memo]) -> [Memo] {
        print("sortMemos has triggered!")
        @AppStorage(AppStorageKeys.mOrderType) var mOrderType = OrderType.modificationDate
        @AppStorage(AppStorageKeys.mOrderAsc) var mOrderAsc = false
        let sortingMethod = Memo.getSortingMethod(type: mOrderType, isAsc: mOrderAsc)
        
        return memos.sorted(by: sortingMethod)
    }
    
    static func sortMemosWithPin(memos: [Memo]) -> [Memo] {
        @AppStorage(AppStorageKeys.mOrderType) var mOrderType = OrderType.modificationDate
        @AppStorage(AppStorageKeys.mOrderAsc) var mOrderAsc = false
        
        let sortingMethod = Memo.getSortingMethod(type: mOrderType, isAsc: mOrderAsc)
        
        let pinnedMemos = memos.filter { $0.isPinned }
        let unpinnedMemos = memos.filter { !$0.isPinned }
        
        var allMemos = pinnedMemos.sorted(by: sortingMethod)
        
        _ = unpinnedMemos.sorted(by: sortingMethod).map { allMemos.append($0) }
        
        return allMemos
    }

//    static func
}

// 북마크를 어떻게 처리하지..??


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
