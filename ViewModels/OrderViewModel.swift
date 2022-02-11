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
    @Published var isAscending = true {
        didSet {
            Folder.isAscending = isAscending
        }
    }

    @Published var orderType: OrderType = .creationDate {
        didSet {
            Folder.orderType = orderType
        }
    }
}

class MemoOrder: ObservableObject {
    @Published var isAscending = false {
        didSet {
            Memo.isAscending = isAscending
        }
    }

    @Published var orderType: OrderType = .modificationDate {
        didSet{
            Memo.orderType = orderType
        }
    }
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


