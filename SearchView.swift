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

// scrolling is not working well in search..
struct SearchView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var context
    
//    @GestureState var isScrolled = false
    
    @FocusState var focusState: Bool
    
    //    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var fastFolderWithLevelGroup: FastFolderWithLevelGroup
    
    @ObservedObject var currentFolder: Folder
    
    @StateObject var memoEditVM = MemoEditViewModel()
    
    @State var searchKeyword = ""
    @State var searchTypeEnum: SearchType = .all
    
    var allFolders: [Folder] {
        var folders: [Folder] = []
        _ = fastFolderWithLevelGroup.folders.map { folders.append($0.folder)}
        _ = fastFolderWithLevelGroup.archives.map { folders.append($0.folder)}
        return folders
    }
    
    var currentFolders: [Folder] {
        var folders: [Folder] = []
        _ = Folder.getHierarchicalFolders(topFolder: currentFolder).map { folders.append($0.folder)}
        return folders
    }
    
    var searchResultMemos: [NestedMemo]? {
        if searchTypeEnum == .all {
            return returnMatchedMemos(targetFolders: allFolders, keyword: searchKeyword)
        } else {
            return returnMatchedMemos(targetFolders: currentFolders, keyword: searchKeyword)
        }
    }
    
    @Binding var showingSearchView: Bool
    @Binding var hidingNavBar: Bool
    
    init(fastFolderWithLevelGroup: FastFolderWithLevelGroup, currentFolder: Folder, showingSearchView: Binding<Bool>, hidingNavBar: Binding<Bool>  = .constant(false)) {
        self.fastFolderWithLevelGroup = fastFolderWithLevelGroup
        self.currentFolder = currentFolder
        _showingSearchView = showingSearchView
        _hidingNavBar = hidingNavBar
    }
    
    func returnMatchedMemos(targetFolders: [Folder], keyword: String) ->  [NestedMemo] {
//        @AppStorage("mOrderType") var mOrderType = OrderType.modificationDate
        @AppStorage(AppStorageKeys.mOrderType) var mOrderType = OrderType.modificationDate
        @AppStorage(AppStorageKeys.mOrderAsc) var mOrderAsc = false

        let sortingMethod = Memo.getSortingMethod(type: mOrderType, isAsc: mOrderAsc)
        
        print("returnMatchedMemos has triggered")
        var nestedMemos = [NestedMemo]()
        
        if keyword != "" {
            for eachFolder in targetFolders {
                var matchedMemos = [Memo]()
                for eachMemo in eachFolder.memos.sorted(by: sortingMethod) {
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
                for eachMemo in eachFolder.memos.sorted(by: sortingMethod) {
                    matchedMemos.append(eachMemo)
                }
                
                if matchedMemos.isEmpty == false {
                    nestedMemos.append(NestedMemo(memos: matchedMemos))
                }
            }
        }
        return nestedMemos
    }
    
    var body: some View {
        
//        let scroll = DragGesture(minimumDistance: 5, coordinateSpace: .local)
//            .updating($isScrolled) { _, _, _ in
//                print("is Scrolling!!")
//                focusState = false
//                DispatchQueue.main.async {
//                    let resign = #selector(UIResponder.resignFirstResponder)
//                    UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
//                }
//
//            }
        
        return NavigationView {
           
            VStack {
                Picker("", selection: $searchTypeEnum) {
                    Text(SearchType.all.rawValue).tag(SearchType.all)
                    Text(SearchType.current.rawValue).tag(SearchType.current)
                }
                .padding(.horizontal, Sizes.overallPadding)
                .pickerStyle(SegmentedPickerStyle())
                
                ScrollView {
                    VStack {
                        // ALL FOLDERS
                        if searchResultMemos != nil {
                            if searchTypeEnum == .all {
                                // searchResult Memos does not update with searchTypeEnum
                                if searchResultMemos!.count != 0 {
                                    ForEach( searchResultMemos!, id: \.self) { memoArray in
                                        Section(header:
                                                    NavigationLink(destination: {
                                            FolderView(currentFolder: memoArray.memos.first!.folder!)
                                                .environmentObject(memoEditVM)
                                                .environmentObject(FolderEditViewModel())
                                                .environmentObject(MemoOrder())
                                        }, label: {
                                            HStack {
                                                HierarchyLabelView(currentFolder: memoArray.memos.first!.folder!, isNavigationLink: true)
                                                Spacer() // Spacer for aligning to the left.
                                            } // end of HStack
                                            .padding(.top, 5)
                                            .offset(y: 5)
                                            .padding(.leading, Sizes.overallPadding + 5)
                                        }) // end of NavigationLink
                                        ) {
                                            ForEach(memoArray.memos, id: \.self) { eachMemo in
                                                NavigationLink {
                                                    MemoView(memo: eachMemo, parent: eachMemo.folder!, presentingView: .constant(false))
                                                        .environmentObject(memoEditVM)
                                                } label: {
                                                    MemoBoxView(memo: eachMemo)
                                                        .environmentObject(memoEditVM)
                                                }
                                            }
                                        }
                                    }
                                } else { // no  searchResult
                                    Text("No Memo contains \"\(searchKeyword)\"")
                                }
                            }// searchTypeEnum == .current
                            else {
                                if searchResultMemos!.count != 0 {
                                    ForEach( searchResultMemos!, id: \.self) { memoArray in
                                        Section(header:
                                                    NavigationLink(destination: {
                                            FolderView(currentFolder: memoArray.memos.first!.folder!)
                                                .environmentObject(memoEditVM)
                                                .environmentObject(FolderEditViewModel())
                                                .environmentObject(MemoOrder())
                                        }, label: {
                                            HStack {
                                                HierarchyLabelView(currentFolder: memoArray.memos.first!.folder!, isNavigationLink: true)
                                                Spacer() // Spacer for aligning to the left.
                                            } // end of HStack
                                            .padding(.top, 5)
                                            .offset(y: 5)
                                            .padding(.leading, Sizes.overallPadding + 5)
                                            //                                                .padding(.horizontal, Sizes.overallPadding)
                                        }) // end of NavigationLink
                                        ) {
                                            ForEach(memoArray.memos, id: \.self) { eachMemo in
                                                NavigationLink {
                                                    MemoView(memo: eachMemo, parent: eachMemo.folder!, presentingView: .constant(false))
                                                        .environmentObject(memoEditVM)
                                                } label: {
                                                    MemoBoxView(memo: eachMemo)
                                                        .environmentObject(memoEditVM)
                                                }
                                            }
                                        }
                                    }
//                                    .gesture(scroll)
                                    
                                } else { // no  searchResult
                                    Text("No Memo contains \"\(searchKeyword)\" in \(currentFolder.title)")
                                }
                            } // searchTypeEnum == .current
                        } // nil
                    }
                }
            }
//            .gesture(scroll)

            .searchable(text: $searchKeyword)
//            .searchable(text: $searchKeyword, focus)
//            .focused($focusState)
            .onSubmit(of: .search) {
            }.navigationBarItems(
                trailing:
                    Button(action: {
                        showingSearchView = false
                        hidingNavBar = false
                    }, label: {
//                        Image(systemName: "multiply")
                        ChangeableImage(imageSystemName: "multiply")
                            .foregroundColor(colorScheme.adjustBlackAndWhite())
//                        Image(systemName: "").frame(height: 28)
                    })
//                    .padding(.trailing, Sizes.overallPadding)
            )
        }
    }
}
