//
//  SearchView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/02/15.
//

import SwiftUI
import CoreData

enum SearchType {
    case all
    case current
}

/*
struct ContainedMemos {
    var folder: Folder
    var memos: [Memo]
    var memosCount: Int
}
*/

//struct MemoAndContainer {
//    var memo: Memo
//    var folder: Folder
//}


struct SearchView: View {
    @State var searchKeyword = ""
    @Environment(\.managedObjectContext) var context
    
    
    @ObservedObject var fastFolderWithLevelGroup: FastFolderWithLevelGroup
    @State var searchTypeEnum: SearchType = .all
    
    // Memos Found , + Folder name of each memo
    var matchMemos: [Memo] {
        
        var allMemos: [Memo] = Memo.fetchAllmemos(context: context)
//        fastFolderWithLevelGro
        // fetch All Memos
        
        // check if any memo has search Keyword
        _ = allMemos.map { $0.contents.contains(searchKeyword)}
        _ = allMemos.map { $0.title.contains(searchKeyword)}
        
        return allMemos
    }
    
    // Folders Found
    var matchFolders: [Folder] {
        var allFolders = [Folder]()
        return allFolders.filter { $0.title.contains(searchKeyword)}
    }
    
    var body: some View {
        
        NavigationView {
            VStack {
                Picker("", selection: $searchTypeEnum) {
                    Image(systemName: FolderType.getfolderImageName(type: FolderTypeEnum.folder)).tag(SearchType.all)
                    Image(systemName: FolderType.getfolderImageName(type: FolderTypeEnum.archive)).tag(SearchType.current)
                }
                List {
                    ForEach(fastFolderWithLevelGroup.folders, id: \.self) { folderWithLevel in
                    }
                }
            }.searchable(text: $searchKeyword)
        }
        .navigationBarHidden(true)
    }
}
