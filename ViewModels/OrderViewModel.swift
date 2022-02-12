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

class FolderOrder: ObservableObject {
    @Published var isAscending = true
    
    @Published var orderType: OrderType = .creationDate
}

class MemoOrder: ObservableObject {
    @Published var isAscending = false
    
    @Published var orderType: OrderType = .modificationDate
}

//8599795fcfe9bd92d8e67c53eb29c7678db43d29

//class FolderOrderVM: ObservableObject {
//
//
//    @Published var isAscending = true
//    {
//        didSet {
//            print("type has changed to \(isAscending)")
//            switch orderType {
//            case .creationDate:
//                self.sortingMethod = oldValue ? {$0.creationDate < $1.creationDate} : {$0.creationDate >= $1.creationDate}
//            case .modificationDate:
//                self.sortingMethod = oldValue ? {$0.modificationDate! < $1.modificationDate!} : {$0.modificationDate! >= $1.modificationDate!}
//            case .alphabetical:
//                self.sortingMethod = oldValue ? {$0.title < $1.title} : {$0.title >= $1.title}
//            }
//        }
//    }
//
//    @Published var orderType: OrderType = .creationDate
//    {
//        willSet {
//            print("type has changed to : \(newValue)")
//            switch newValue {
//            case .creationDate:
//                self.sortingMethod = isAscending ? {$0.creationDate < $1.creationDate} : {$0.creationDate >= $1.creationDate}
//            case .modificationDate:
//                self.sortingMethod = isAscending ? {$0.modificationDate! < $1.modificationDate!} : {$0.modificationDate! >= $1.modificationDate!}
//            case .alphabetical:
//                self.sortingMethod = isAscending ? {$0.title < $1.title} : {$0.title >= $1.title}
//            }
//        }
//    }
//
//    @Published var sortingMethod: (Folder, Folder) -> Bool = { _, _ in true}
//
//    func getHierarchicalFolders(topFolder: Folder, sortingMethod: (Folder, Folder) -> Bool) -> [FolderWithLevel] {
////        print("getHierarchicalFolders triggered, sortingMemod : \(sortingMethod)")
//
//            var currentFolder: Folder? = topFolder
//            var level = 0
//            var trashSet = Set<Folder>()
//            var folderWithLevelContainer = [FolderWithLevel(folder: currentFolder!, level: level)]
//            var folderContainer = [currentFolder]
//
//        whileLoop: while (currentFolder != nil) {
//            print("currentFolder: \(currentFolder!.id)")
//            print(#line)
//            if currentFolder!.subfolders.count != 0 {
//
//                // check if trashSet has contained Folder of arrayContainer2
//                for folder in currentFolder!.subfolders.sorted(by: sortingMethod) {
//                    if !trashSet.contains(folder) && !folderContainer.contains(folder) {
//        //            if !trashSet.contains(folder) && !arrayContainer2 {
//                        currentFolder = folder
//                        level += 1
//                        folderContainer.append(currentFolder!)
//                        folderWithLevelContainer.append(FolderWithLevel(folder: currentFolder!, level: level))
//                        continue whileLoop // this one..
//                    }
//                }
//                // subFolders 가 모두 이미 고려된 경우.
//                trashSet.update(with: currentFolder!)
//            } else { // subfolder 가 Nil 인 경우
//                trashSet.update(with: currentFolder!)
//            }
//
//            for i in 0 ..< folderWithLevelContainer.count {
//                if !trashSet.contains(folderWithLevelContainer[folderWithLevelContainer.count - i - 1].folder) {
//
//                    currentFolder = folderWithLevelContainer[folderWithLevelContainer.count - i - 1].folder
//                    level = folderWithLevelContainer[folderWithLevelContainer.count - i - 1].level
//                    break
//                }
//            }
//
//            if folderWithLevelContainer.count == trashSet.count {
//                break whileLoop
//            }
//        }
//            return folderWithLevelContainer
//        }
//
//}



//class MemoOrder: ObservableObject {
//    @Published var isAscending = false
////    {
////        didSet {
////            Memo.isAscending = isAscending
////        }
////    }
//
//    @Published var orderType: OrderType = .modificationDate
////    {
////        didSet{
////            Memo.orderType = orderType
////        }
////    }
//
//    @Published var sortingMethod: (Memo, Memo) -> Bool = { _, _ in true}
//}





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


