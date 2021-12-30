//
//  MemoStruct.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/21.
//

import Foundation
import UIKit
import SwiftUI
// This is a Sampel Memo Struct, Which will be replaced by coreData.

// a folder should have contain empty or multiple folders ( + Memos )
//

// MARK: - Folder Struct
struct Folder: Hashable  {
    
    static func == (lhs: Folder, rhs: Folder) -> Bool {
        return lhs.id == rhs.id
    }

    // it should be
    // let parentFolderId: UUID
    var parentFolderId: UUID?
    
//    let folderId: UUID = UUID()
    let id = UUID()
    var subFolders: [Folder]?
    var memos: [Memo]?
    
    var title: String
//    var color: UIColor? = .white
//    var color: Color = .white
    
    let createdAt: Date = Date()
    var modifiedAt: Date = Date()
    
    var pinnedIndex: Int?
}

extension Folder : Identifiable { }

// MARK: - Memo Struct
struct Memo: Hashable, Identifiable {
    let id: UUID = UUID()

    var parentFolder: Folder?
    
    var title: String = ""
    var overView: String = ""
    var contents: String = ""

//    var color: UIColor = .clear
    
    var imageContained: [UIImage]?

    let createdAt : Date = Date()
    var modifiedAt: Date = Date()
    
    var pinnedIndex: Int?
    
    static let lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
}


// Initializer .. 를 더 배워야겠는데 ?? two phase initializer.
var memo0 = Memo(parentFolder: folder0, modifiedAt: Date())
//let memo2 = Memo(parentFolder: <#T##Folder#>, title: <#T##String#>, contents: <#T##String#>, color: <#T##UIColor#>, imageContained: <#T##[UIImage]?#>, modifiedAt: <#T##Date#>, pinnedIndex: <#T##Int?#>)
// MARK: - Sample Datas
///



let folder0: Folder = Folder(title: "Empty", modifiedAt: Date())

let folder2: Folder = Folder(

    subFolders:
        [
            Folder(title: "first folder",  modifiedAt: Date()),
            Folder(title: "second folder", modifiedAt: Date())
        ],
    title: "My Main Folder",
    
    modifiedAt: Date()
)

let folder8: Folder = Folder(
    
    subFolders:
        [
            Folder(title: "first folder",  modifiedAt: Date()),
            Folder(title: "second folder", modifiedAt: Date()),
            Folder(title: "third folder", modifiedAt: Date()),
            Folder(title: "fourth folder",  modifiedAt: Date()),
            Folder(title: "fifth folder", modifiedAt: Date()),
            Folder(title: "sixth folder",  modifiedAt: Date()),
            Folder(title: "seventh folder", modifiedAt: Date()),
            Folder(title: "eighth folder",  modifiedAt: Date()),
            Folder(subFolders: folder2.subFolders , title: "ninth folder", modifiedAt: Date())
//            Folder(
        ],
    title: "My Main Folder",
    modifiedAt: Date()
)





let deeperFolder: Folder = Folder(
    parentFolderId: nil,
    subFolders:
        [
            Folder(parentFolderId: UUID(),
                   subFolders: folder8.subFolders,
                   title: "deeper one-one"),
                   
            Folder(parentFolderId: UUID(),
                   subFolders: folder2.subFolders,
                   title: "deeper one-two"),
            
            Folder(parentFolderId: UUID(),
                   subFolders: folder0.subFolders,
                   title: "deeper one-three")
        ],
    // overview 가 있을 때 contents 는 보이지 않음.
    // title: one line,
    // overview: up to two lines,
    // contents : up to 4 lines
    memos: [
        Memo(title: "has everthing short 1", overView: "sample overview1", contents: "sample contents 1"),
        Memo(title: "has everything long 2", overView: "sample overview2", contents: Memo.lorem),
        Memo( overView: "doesnt have title short 3 ", contents: "sample contents 3"),
        Memo( overView: "doesnt have title long 4 ", contents: Memo.lorem),
        Memo(title: "doesnt have overview short 5", contents: "sample contents 5"),
        Memo(title: "doesnt have overview long 6", contents: Memo.lorem),
        Memo( contents: "doesn't have title and overView short 7"),
        Memo( contents: "doesn't have title and overView long 8"),
        Memo(title: "only title 9"),
    ],
    title: "deeper One", modifiedAt: Date())


let sampleMemos: [Memo] = [
    Memo(title: "sample Memo title 1", overView: "sample overview1", contents: "sample contents 1"),
    Memo(title: "sample Memo title 2", overView: "sample overview2", contents: "sample contents 2"),
    Memo(title: "sample Memo title 3", overView: "sample overview3", contents: "sample contents 3"),
    Memo(title: "sample Memo title 4", overView: "sample overview4", contents: "sample contents 4"),
    Memo(title: "sample Memo title 5", overView: "sample overview5", contents: "sample contents 5"),
    Memo(title: "sample Memo title 6", overView: "sample overview6", contents: "sample contents 6"),
    Memo(title: "sample Memo title 7", overView: "sample overview7", contents: Memo.lorem)
]


