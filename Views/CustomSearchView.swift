//
//  SearchView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/02/15.
//

import SwiftUI
import CoreData


struct NestedMemo: Hashable {
    var memos: [Memo]
}

enum SearchType: String {
    case all = "All"
    case current = "Current"
}

struct CustomSearchView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var context
    
    @GestureState var isScrolled = false
    
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
    
    init(fastFolderWithLevelGroup: FastFolderWithLevelGroup, currentFolder: Folder, showingSearchView: Binding<Bool>) {
        self.fastFolderWithLevelGroup = fastFolderWithLevelGroup
        self.currentFolder = currentFolder
        _showingSearchView = showingSearchView
      
    }
    
    func returnMatchedMemos(targetFolders: [Folder], keyword: String) ->  [NestedMemo] {
        
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
        
        let scroll = DragGesture(minimumDistance: 10, coordinateSpace: .local)
            .updating($isScrolled) { _, _, _ in
                print("is Scrolling : \(isScrolled)")
                focusState = false
            }
        
        return NavigationView {
            
            
            VStack {
                HStack {
                    HStack(spacing: 0) {

                        ChangeableImage(imageSystemName: "magnifyingglass", height: 16)
//                            .tint(Color.)
                            .foregroundColor(Color(white: 131 / 255))
                            .padding(.horizontal, 7)

                        TextField("Search", text: $searchKeyword)
//                            .tint(Color.textViewTintColor)
                            .accentColor(Color.textViewTintColor)
                            .focused($focusState)
                            .frame(width: UIScreen.screenWidth - 9 * Sizes.overallPadding, alignment: .leading)
                            .frame(height: 30)
//                            .focused($focusState)

//                            .foregroundColor(colorScheme.adjustBlackAndWhite())
                            .foregroundColor(Color.blackAndWhite)
                        Spacer()
                        Button{
                            searchKeyword = ""
                            focusState = false
                        } label: {
                            ZStack {
                                Circle()
                                    .frame(width: 18, height: 18)
                                    .foregroundColor(Color(white: 0.75))

                                Image(systemName: "multiply")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .tint(Color.blackAndWhite)
                                .frame(width: 8, height: 8)
                            }
                            .padding(.trailing, 10)
                        }
                    }
                    .frame(height: 32)
                    .frame(width: UIScreen.screenWidth - 5.1 * Sizes.overallPadding)
                    .background(colorScheme == .dark ? Color(white: 16 / 255): Color(white: 239 / 255 ))
                    .cornerRadius(10)
                    Spacer()
                    
                    Button("Cancel") {
                        focusState = false
                        searchKeyword = ""
                        showingSearchView = false
                    }
                }
                .padding(.horizontal, Sizes.overallPadding)
            
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
                                    Text("No Memo contains \"\(searchKeyword)\" in \(currentFolder.title)")
                                }
                            } // searchTypeEnum == .current
                        } // nil
                    }
                }
                .gesture(scroll)
            }
            .padding(.top)
            .gesture(scroll)

            .navigationBarHidden(true)
        }
    }
}
