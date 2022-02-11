//
//  Ordering.swift
//  DeeepMemo
//
//  Created by 이한목 on 2022/02/05.
//

import Foundation
import SwiftUI

// MARK: - ORDERING BASIC STRUCTURE
enum OrderType: String, CaseIterable, Codable {
    case modificationDate = "Modification Date"
    case creationDate = "Creation Date"
    case alphabetical = "Alphabetical"
}


class FolderOrderVM: ObservableObject {
    
    static var shard = FolderOrderVM()
    
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
//        didSet {
//            print("oldValue: \(oldValue)")
//            switch oldValue {
//            case .creationDate:
//                self.sortingMethod = isAscending ? {$0.creationDate < $1.creationDate} : {$0.creationDate >= $1.creationDate}
//            case .modificationDate:
//                self.sortingMethod = isAscending ? {$0.modificationDate! < $1.modificationDate!} : {$0.modificationDate! >= $1.modificationDate!}
//            case .alphabetical:
//                self.sortingMethod = isAscending ? {$0.title < $1.title} : {$0.title >= $1.title}
//            }
//        }
        
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
    
    @Published var sortingMethod: (Folder, Folder) -> Bool = { _, _ in true}
    
    
}

class MemoOrder: ObservableObject {
    @Published var isAscending = false
//    {
//        didSet {
//            Memo.isAscending = isAscending
//        }
//    }

    @Published var orderType: OrderType = .modificationDate
//    {
//        didSet{
//            Memo.orderType = orderType
//        }
//    }
    
    @Published var sortingMethod: (Memo, Memo) -> Bool = { _, _ in true}
}





//typealias FolderOrdering2 = [OrderType]
//
//extension FolderOrdering2: RawRepresentable {
//    public init?(rawValue: String) {
//        guard let data = rawValue.data(using: .utf8),
//              let result = try? JSONDecoder().decode(
//                                FolderOrdering2.self, from: data)
//        else {
//            return nil
//        }
//        self = result
//    }
//
//    public var rawValue: String {
//        guard let data = try? JSONEncoder().encode(self),
//              let result = String(data: data, encoding: .utf8)
//        else {
//            return "[]"
//        }
//        return result
//    }
//}


