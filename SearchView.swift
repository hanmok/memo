//
//  SearchView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/02/15.
//

import SwiftUI
import CoreData

enum SearchType: String {
    case all = "All"
    case current = "Current"
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
    
    /*
    var matchedMemos: [Memo] {
        
        let allMemos: [Memo] = Memo.fetchAllmemos(context: context)

        var resultMemos = [Memo]()
        
        for eachMemo in allMemos {
            if eachMemo.contents.lowercased().contains(searchKeyword.lowercased()) {
                resultMemos.append(eachMemo)
            }
        }
        
        return resultMemos
    }
    */
    
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
        _ = allFolders.map { print("contaiend Folders: \($0.title)")}
        return allFolders
    }
    
    //    var matchedFolders: [Folder] = []
    
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                Picker("", selection: $searchTypeEnum) {
                    Text(SearchType.all.rawValue).tag(SearchType.all)
                    Text(SearchType.current.rawValue).tag(SearchType.current)
                }
                .pickerStyle(SegmentedPickerStyle())
                ScrollView {
                    VStack {
                        Section(header:
                                    HStack {
                            Text("Matched Memos")
                                .padding(.leading, Sizes.overallPadding)
                            Spacer()
                        }
                        ) {
                            ForEach(SearchViewModel(folders: allFolders, keyword: searchKeyword).returnMatchedMemos().nestedMemos,
                                    id: \.self) { memoArray in
                                Section(header:
                                            HStack {
                                    HierarchyLabelView(currentFolder: memoArray.memos.first!.folder!)
                                        .padding(.leading, Sizes.littleBigPadding)
                                    Spacer()
                                }
                                ) {
                                    ForEach(memoArray.memos, id: \.self) { eachMemo in
                                        NavigationLink {
                                            MemoView(memo: eachMemo, parent: eachMemo.folder!, presentingView: .constant(false))
                                        } label: {
                                            MemoBoxView(memo: eachMemo)
                                                .environmentObject(memoEditVM)
                                        }
                                    }
                                }
                            }
                        }
                        Rectangle()
                            .background(.clear)
                            .frame(height: 40)
                        
                        Section(header:
                                    HStack {
                            Text("Matched Folders")
                                .padding(.leading, Sizes.overallPadding)
                            Spacer()
                        }
                        ) {
                            ForEach(SearchViewModel(folders: allFolders, keyword: searchKeyword).returnMatchedFolders(), id: \.self) { matchedFolder in
                                Text(matchedFolder.title)
                            }
                        }
                        // what if.. there's no matched folder or memo ?
                    }
                }
                
                
            }.searchable(text: $searchKeyword)
                .onSubmit(of: .search) {
                    
                    
                    
                }
        }
        .onAppear(perform: {
            print("allMatchedFolders: \(matchedFolders)")
        })
        .navigationBarHidden(true)
    }
}



// Folder 를 위한 Boxiew 가 필요함.
// 이동 시 FolderView 로 이동.
// MemoView 도 Hierarchy 가 나오게끔 어떻게.. 해야겠는데 .. ?
// 없을 때 .. 는 어떻게해 ??

// 결과를 활용하지 않으면 시간이 엄청나게 걸리겠다.. 정말로....
