//
//  SearchViewModel.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/02/18.
//

import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var keyword: String = ""
//    @Published var
    
//    @Published var foldersMatched: [Folder]
//    @Published var memosMatched: [Memo]
    
    var targetFolders: [Folder]
    var targetMemos: [Memo]
    // 하나의 폴더만 보낼때도 있고, 여러 폴더를 보낼 때도 있음.
    // 여러 폴더는 전부 다 를 의미..음.. 폴더는.. 다중을 보내되, 다중일 때는 TopFolder 와 Archive Folder 일 때만을 의미.
    init(folders: [Folder], memos: [Memo], keyword: String) {
        self.targetFolders = folders
        self.targetMemos = memos
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
    
    func returnMatchedMemos() -> [Memo] {
        var matchedMemos = [Memo]()
        
        if keyword != "" {
        for eachMemo in targetMemos {
            if eachMemo.contents.lowercased().contains(keyword.lowercased()) {
                matchedMemos.append(eachMemo)
            }
        }
        } else {
            _ = targetMemos.map { matchedMemos.append($0)}
        }
        
        return matchedMemos
    }
    
    
}
