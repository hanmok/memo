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
    @StateObject var memoEditVM = MemoEditViewModel()
    // Memos Found , + Folder name of each memo
    
    var matchedMemos: [Memo] {

        var allMemos: [Memo] = Memo.fetchAllmemos(context: context)
//        fastFolderWithLevelGro
        // fetch All Memos
        
        // check if any memo has search Keyword
        _ = allMemos.map { $0.contents.lowercased().contains(searchKeyword)}
//        _ = allMemos.map { $0.title.contains(searchKeyword)}
        
        return allMemos
    }
    
    var allFolders: [Folder] {
        var folders: [Folder] = []
        _ = fastFolderWithLevelGroup.folders.map { folders.append($0.folder)}
        _ = fastFolderWithLevelGroup.archives.map { folders.append($0.folder)}
        return folders
    }
    var allMemos: [Memo] {
        var memos: [Memo] = []
        
        _ = Folder.returnContainedMemos(folder: fastFolderWithLevelGroup.homeFolder).map { memos.append($0)}
        
        _ = Folder.returnContainedMemos(folder: fastFolderWithLevelGroup.archive).map { memos.append($0)}
        return memos
    }
    
    // Folders Found
    var matchedFolders: [Folder] {

        var allFolders = [Folder]()
        _ = fastFolderWithLevelGroup.folders.map { allFolders.append($0.folder)}
        _ = fastFolderWithLevelGroup.archives.map { allFolders.append($0.folder)}

        for eachFolder in allFolders {
            if eachFolder.title.lowercased().contains(searchKeyword.lowercased()) {
                allFolders.append(eachFolder)
            }
        }
        return allFolders
    }
    
//    var matchedFolders: [Folder] = []
    
    
    var body: some View {
        
        NavigationView {
            VStack {
                Picker("", selection: $searchTypeEnum) {
                    Image(systemName: FolderType.getfolderImageName(type: FolderTypeEnum.folder)).tag(SearchType.all)
                    Image(systemName: FolderType.getfolderImageName(type: FolderTypeEnum.archive)).tag(SearchType.current)
                }
                .pickerStyle(SegmentedPickerStyle())
                List {
                    Section(header: Text("Matched Folders")) {
                        ForEach(                            SearchViewModel(folders: allFolders, memos: [], keyword: searchKeyword).returnMatchedFolders(), id: \.self) { matchedFolder in
                            Text(matchedFolder.title)

                        }
                    }
                    
                    Section(header: Text("Matched Memos")) {
                        ForEach(SearchViewModel(
                            folders: allFolders, memos: allMemos, keyword: searchKeyword).returnMatchedMemos(), id: \.self) { matchedMemo in
//                            Text(matchedMemo.contents)
                            ModifiedMemoBoxView(memo: matchedMemo)
                                .environmentObject(memoEditVM) // dummy..
                        }
                    }
                }
                
                
                
            }.searchable(text: $searchKeyword)
                .onSubmit(of: .search) {
           

                    
                }
        }
        .onAppear(perform: {
            print("allMatchedMemos: \(matchedMemos)")
            print("allMatchedFolders: \(matchedFolders)")
        })
        .navigationBarHidden(true)
    }
}
