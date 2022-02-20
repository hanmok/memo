//
//  SearchViewModel.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/02/18.
//

import SwiftUI


struct NestedMemo: Hashable {
    var memos: [Memo]
//    var folder: Folder
}

class SearchViewModel: ObservableObject {
    @Published var keyword: String = ""
//    @Published var
    
//    @Published var foldersMatched: [Folder]
//    @Published var memosMatched: [Memo]
    
    var targetFolders: [Folder]
//    var targetMemos: [Memo]
    // 하나의 폴더만 보낼때도 있고, 여러 폴더를 보낼 때도 있음.
    // 여러 폴더는 전부 다 를 의미..음.. 폴더는.. 다중을 보내되, 다중일 때는 TopFolder 와 Archive Folder 일 때만을 의미.
    init(folders: [Folder], keyword: String) {
        self.targetFolders = folders
//        self.targetMemos = memos
        self.keyword = keyword
    }
    
    func returnMatchedFolders() -> [Folder] {
        var matchedFolders = [Folder]()
        if keyword != "" {
        for eachFolder in targetFolders {
            if eachFolder.title.lowercased().contains(keyword.lowercased()) {
                matchedFolders.append(eachFolder)
            }
        }
        } else {
            _ = targetFolders.map { matchedFolders.append($0)}
        }
        return matchedFolders
    }
    
    // 그런데 이거,, 시간이 꽤 걸릴 수 있겠는데..??
    // Tuple 을 반환하고, 각 Tuple 의 Element에 이름지어주기 ~
//    func returnMatchedMemos() -> (memos: [Memo], hasAny: Bool) {
    func returnMatchedMemos() -> (nestedMemos: [NestedMemo], hasAny: Bool) {
//        var matchedMemos = [Memo]()
        var nestedMemos = [NestedMemo]()
        
        if keyword != "" {
        for eachFolder in targetFolders {
            var matchedMemos = [Memo]()
            for eachMemo in eachFolder.memos.sorted() {
                if eachMemo.contents.lowercased().contains(keyword.lowercased()) {
                    matchedMemos.append(eachMemo)
                }
            }
            if matchedMemos.isEmpty == false {
                nestedMemos.append(NestedMemo(memos: matchedMemos))
            }
        }
        
          // if keyword is empty
        } else {
             for eachFolder in targetFolders {
                 var matchedMemos = [Memo]()
                 for eachMemo in eachFolder.memos.sorted() {
                         matchedMemos.append(eachMemo)
                 }
                 
                 if matchedMemos.isEmpty == false {
                     nestedMemos.append(NestedMemo(memos: matchedMemos))
                 }
             }
        }
        
        if nestedMemos.isEmpty {
            return (nestedMemos, false)
        } else {
            return (nestedMemos, true)
        }
        
//        return matchedMemos
    }
    
    
}


//순서.
// fastFolderWithHierarchy 에서, 순서대로 !!
// MindMap 에서 보이는 Folder 의 순서대로 ! 담은 [폴더] 를 넘긴다.
// 해당 [폴더] 에서 각 폴더의 memos 를 뒤져보고, 매치되는게 있으면 묶는다.

// 다 묶은 [메모] 와 폴더 를 [MemosInFolder] 에 차곡차곡 담는다.
