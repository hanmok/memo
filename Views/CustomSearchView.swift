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

    @EnvironmentObject var trashBinVM: TrashBinViewModel

    @StateObject var memoEditVM = MemoEditViewModel()

    @ObservedObject var fastFolderWithLevelGroup: FastFolderWithLevelGroup
    
    @ObservedObject var currentFolder: Folder
    
    @GestureState var isScrolled = false
    
    @FocusState var focusState: Bool
    
    @State var searchKeyword = ""
//    @State var searchTypeEnum: SearchType = .all
    @State var searchTypeEnum: SearchType
    
    @Binding var showingSearchView: Bool
    var shouldIncludeTrash: Bool
    
    var allFolders: [Folder] {
        var folders: [Folder] = []
        _ = fastFolderWithLevelGroup.folders.map { folders.append($0.folder)}
        _ = fastFolderWithLevelGroup.archives.map { folders.append($0.folder)}
        folders.append(trashBinVM.trashBinFolder)
        return folders
    }
    // 여기다..
    var currentFolders: [Folder] {
        var folders: [Folder] = []
        _ = Folder.getHierarchicalFolders(topFolder: currentFolder).map { folders.append($0.folder)}
        if shouldIncludeTrash {
            folders.append(trashBinVM.trashBinFolder)
        }
        print("appended Folders in currnetFolders: \(folders)")
        
        _ = folders.map { print($0.title)}
        
        return folders
    }
    
    var foundMemos: [NestedMemo]? {
        if searchTypeEnum == .all {
            return returnMatchedMemos(targetFolders: allFolders, keyword: searchKeyword)
        } else {
            return returnMatchedMemos(targetFolders: currentFolders, keyword: searchKeyword)
        }
    }
    

    
    init(fastFolderWithLevelGroup: FastFolderWithLevelGroup, currentFolder: Folder, showingSearchView: Binding<Bool>, shouldShowAll: Bool = false, shouldIncludeTrash: Bool = false ) {
        self.fastFolderWithLevelGroup = fastFolderWithLevelGroup
        self.currentFolder = currentFolder
        _showingSearchView = showingSearchView
        // initialize state value
        _searchTypeEnum = State(initialValue: shouldShowAll ? .all : .current)
        self.shouldIncludeTrash = shouldIncludeTrash
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
        print("folder name of first element in nestedMemos: ")
        return nestedMemos
    }
    
    var body: some View {
        
        let scroll = DragGesture(minimumDistance: 10, coordinateSpace: .local)
            .updating($isScrolled) { _, _, _ in
                print("is Scrolling : \(isScrolled)")
                focusState = false
            }
        
        return NavigationView {
            
            
            VStack(alignment: .leading) {
                HStack {
                    HStack(spacing: 0) {

                        ChangeableImage(imageSystemName: "magnifyingglass", height: 16)
                            .foregroundColor(Color(white: 131 / 255))
                            .padding(.horizontal, 7)

                        TextField(LocalizedStringStorage.searchPlaceholder, text: $searchKeyword)
                            .accentColor(Color.textViewTintColor)
                            
                            .focused($focusState)
                            .frame(width: UIScreen.screenWidth - 9 * Sizes.overallPadding, alignment: .leading)
                            .frame(height: 30)
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
                                .tint(.black)
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
                    
                    Button {
                        focusState = false
                        searchKeyword = ""
                        showingSearchView = false
                    } label: {
                        Text(LocalizedStringStorage.cancelInSearch)
                            .foregroundColor(.buttonTextColor)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .padding(.horizontal, Sizes.overallPadding)
            
                Picker("", selection: $searchTypeEnum) {
                    Text(LocalizedStringStorage.convertSearchTypeToText(type: .all)).tag(SearchType.all)

                    Text(LocalizedStringStorage.convertSearchTypeToText(type: .current)).tag(SearchType.current)
                }
                .padding(.horizontal, Sizes.overallPadding)
                .pickerStyle(SegmentedPickerStyle())
                
                ScrollView {
                    VStack {
                        // ALL FOLDERS
                        if foundMemos != nil {
                            if searchTypeEnum == .all {
                                if foundMemos!.count != 0 {
                                    ForEach( foundMemos!, id: \.self) { memoArray in
                                        
                                        Section(header:
                                                    NavigationLink(destination: {
                                            FolderView(currentFolder: memoArray.memos.first!.folder!)
                                                .environmentObject(memoEditVM)
                                                .environmentObject(FolderEditViewModel())
                                                .environmentObject(MemoOrder()) // 왜.. 새로운 object 를 여기서 만들었지 ?
                                                .environmentObject(trashBinVM)
                                        }, label: {
                                            HStack {
                                                HierarchyLabelView(currentFolder: memoArray.memos.first!.folder!, isNavigationLink: true)
                                                Spacer()
                                                
                                            } // end of HStack
                                            .padding(.top, 5)
                                            .offset(y: 5)
                                            .padding(.leading, Sizes.overallPadding + 5)
                                        }) // end of NavigationLink
                                                
                                        ) {
                                            ForEach(memoArray.memos, id: \.self) { eachMemo in
                                                NavigationLink {
                                                    MemoView(memo: eachMemo, parent: eachMemo.folder!, presentingView: .constant(false))
                                                        .environmentObject(trashBinVM)
                                                        .environmentObject(memoEditVM)
                                                } label: {
                                                    MemoBoxView(memo: eachMemo)
                                                        .environmentObject(memoEditVM)
                                                    // 애초에 force unwrap 을 시킬 경우를 만들지 말아야하나 ?
//                                                        .onAppear {
//                                                            print("memo's parent: \(eachMemo.folder!.title)")
//                                                        }
                                                }
                                            }
                                        }
                                    }
                                } else { // no  searchResult
//                                    Text("No Memo contains \"\(searchKeyword)\"")
                                    Spacer()
                                    Text(LocalizedStringStorage.emptySearchResult)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                }
                            }// searchTypeEnum == .current
                            else {
                                if foundMemos!.count != 0 {
                                    ForEach( foundMemos!, id: \.self) { memoArray in
                                        Section(header:
                                                    NavigationLink(destination: {
                                            FolderView(currentFolder: memoArray.memos.first!.folder!)
                                                .environmentObject(memoEditVM)
                                                .environmentObject(FolderEditViewModel())
                                                .environmentObject(MemoOrder())
                                                .environmentObject(trashBinVM)
                                        }, label: {
                                            HStack {
                                                HierarchyLabelView(currentFolder: memoArray.memos.first!.folder!, isNavigationLink: true)
                                                Spacer()
                                            } // end of HStack
                                            .padding(.top, 5)
                                            .offset(y: 5)
                                            .padding(.leading, Sizes.overallPadding + 5)
                                        }) // end of NavigationLink
                                        ) {
                                            ForEach(memoArray.memos, id: \.self) { eachMemo in
                                                NavigationLink {
                                                    MemoView(memo: eachMemo, parent: eachMemo.folder!, presentingView: .constant(false))
                                                        .environmentObject(trashBinVM)
                                                        .environmentObject(memoEditVM)
                                                } label: {
                                                    MemoBoxView(memo: eachMemo)
                                                        .environmentObject(memoEditVM)
                                                }
                                            }
                                        }
                                    }
                                } else { // no  searchResult
                                    Spacer()
                                    Text(LocalizedStringStorage.emptySearchResult)
                                        .frame(maxWidth: .infinity, alignment: .center)
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
