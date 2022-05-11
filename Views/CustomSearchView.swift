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
    
    mutating func toggleSelf() {
        switch self {
        case .all:
            self = .current
        case .current:
            self = .all
        }
    }
}


struct CustomSearchView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var context

    @ObservedObject var fastFolderWithLevelGroup: FastFolderWithLevelGroup
    @ObservedObject var currentFolder: Folder
    
    @EnvironmentObject var trashBinVM: TrashBinViewModel

    @GestureState var isScrolled = false
    
    @FocusState var focusState: Bool
    
    @State var searchKeyword = ""

    @State var searchTypeEnum: SearchType
    
    @Binding var showingSearchView: Bool
    
    func updateViewInHalfSecond() {
        var increasedSeconds = 0.0
        for _ in 0 ... 5 {
            increasedSeconds += 0.1
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + increasedSeconds) {
                
                searchKeyword += " "
                searchKeyword.removeLast()
                
            }
        }
    }
    
    var shouldIncludeTrashOnCurrent: Bool
    var shouldIncludeTrashOverall: Bool
    
    var allFolders: [Folder] {
        var folders: [Folder] = []
        fastFolderWithLevelGroup.folders.forEach { folders.append($0.folder)}
        fastFolderWithLevelGroup.archives.forEach { folders.append($0.folder)}
        
        if shouldIncludeTrashOverall {
            folders.append(trashBinVM.trashBinFolder)
        }
        
        return folders
    }

    var currentFolders: [Folder] {
        var folders: [Folder] = []
         Folder.getHierarchicalFolders(topFolder: currentFolder).forEach { folders.append($0.folder)}
        if shouldIncludeTrashOnCurrent {
            folders.append(trashBinVM.trashBinFolder)
        }
        print("appended Folders in currnetFolders: \(folders)")
        
        return folders
    }
    
    /*
    var foundMemos: [NestedMemo]? {
        if searchTypeEnum == .all {
            return returnMatchedMemos(targetFolders: allFolders, keyword: searchKeyword)
        } else {
            return returnMatchedMemos(targetFolders: currentFolders, keyword: searchKeyword)
        }
    }
     */
    

    
    init(fastFolderWithLevelGroup: FastFolderWithLevelGroup,
         currentFolder: Folder,
         showingSearchView: Binding<Bool>, shouldShowAll: Bool = false, shouldIncludeTrashOnCurrent: Bool = false,
         shouldIncludeTrashOverall: Bool = false) {
        
        self.fastFolderWithLevelGroup = fastFolderWithLevelGroup
        self.currentFolder = currentFolder
        _showingSearchView = showingSearchView
        // initialize state value
        _searchTypeEnum = State(initialValue: shouldShowAll ? .all : .current)
        self.shouldIncludeTrashOnCurrent = shouldIncludeTrashOnCurrent
        self.shouldIncludeTrashOverall = shouldIncludeTrashOverall
    }
    
    func returnMatchedMemos(targetFolders: [Folder], keyword: String) ->  [NestedMemo] {
        
        @AppStorage(AppStorageKeys.mOrderType) var mOrderType = OrderType.modificationDate
        @AppStorage(AppStorageKeys.mOrderAsc) var mOrderAsc = false
        
        let sortingMethod = Memo.getSortingMethod(type: mOrderType, isAsc: mOrderAsc)
        
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
        
        var foundMemos: [NestedMemo] {
            if searchTypeEnum == .all {
                return returnMatchedMemos(targetFolders: allFolders, keyword: searchKeyword)
            } else {
                return returnMatchedMemos(targetFolders: currentFolders, keyword: searchKeyword)
            }
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
                            .submitLabel(.search)
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
                    .overlay(RoundedRectangle(cornerRadius: 10)
//                        .stroke(colorScheme == .dark ? Color.cream : Color.clear))
                        .stroke(colorScheme == .dark ? Color.white : Color.clear))
                    
                    Spacer()
                    
                    Button {
                        focusState = false
                        searchKeyword = ""
                        showingSearchView = false
                    } label: {
                        Text(LocalizedStringStorage.cancelInSearch)
//                            .foregroundColor(.buttonTextColor)
                            .foregroundColor(.white)
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
//                        if foundMemos != nil {
                            if searchTypeEnum == .all {
//                                if foundMemos!.count != 0 {
                                if foundMemos.count != 0 {
                                    
//                                    ForEach( foundMemos!, id: \.self) { memoArray in
                                    ForEach( foundMemos, id: \.self) { memoArray in
                                        
                                        Section(header:
                                                    NavigationLink(destination: {
                                            FolderView(currentFolder: memoArray.memos.first!.folder!)
//                                                .environmentObject(trashBinVM)
                                        }, label: {
                                            HStack {
//                                                HierarchyLabelView(currentFolder: memoArray.memos.first!.folder!, isNavigationLink: true)
                                                HierarchyLabelView(currentFolder: memoArray.memos.first!.folder!)
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
//                                                        .environmentObject(trashBinVM)
                                                } label: {
                                                    MemoBoxView(memo: eachMemo)
                                                        .background {
                                                            ZStack {
                                                                Color(colorScheme == .dark ? .black : .white)
                                                                    .frame(width: UIScreen.screenWidth  - 2 * Sizes.overallPadding - 2)
                                                                    .cornerRadius(10)
                                                            }
                                                            .shadow(
                                                                color: Color(.sRGB, white: 0, opacity: colorScheme == .dark ? 1: 0.6),
                                                                radius: 4, x: 4, y: 4)
                                                        }
                                                }
                                                .padding(.bottom, Sizes.spacingBetweenMemoBox)
                                            }
                                        }
                                    }
                                } else { // no  searchResult
                                    Spacer()
                                    Text(LocalizedStringStorage.emptySearchResult)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                }
                            }// searchTypeEnum == .current
                            else {
//                                if foundMemos!.count != 0 {
                                if foundMemos.count != 0 {
//                                    ForEach( foundMemos!, id: \.self) { memoArray in
                                    ForEach( foundMemos, id: \.self) { memoArray in
                                        Section(header:
                                                    NavigationLink(destination: {
                                            FolderView(currentFolder: memoArray.memos.first!.folder!)
//                                                .environmentObject(trashBinVM)
                                        }, label: {
                                            HStack {
//                                                HierarchyLabelView(currentFolder: memoArray.memos.first!.folder!, isNavigationLink: true)
                                                HierarchyLabelView(currentFolder: memoArray.memos.first!.folder!)
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
//                                                        .environmentObject(trashBinVM)
                                                } label: {
                                                    MemoBoxView(memo: eachMemo)
                                                        .background {
                                                            ZStack {
                                                                Color(colorScheme == .dark ? .black : .white)
                                                                    .frame(width: UIScreen.screenWidth  - 2 * Sizes.overallPadding - 2)
                                                                    .cornerRadius(10)
                                                            }
                                                            .shadow(
                                                                color: Color(.sRGB, white: 0, opacity: colorScheme == .dark ? 1: 0.6),
                                                                radius: 4, x: 4, y: 4)
                                                        }
                                                }
                                                .padding(.bottom, Sizes.spacingBetweenMemoBox)
                                            }
                                        }
                                    }
                                } else { // no  searchResult
                                    Spacer()
                                    Text(LocalizedStringStorage.emptySearchResult)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                }
                            } // searchTypeEnum == .current
//                        } // nil
                    }
                }
                .gesture(scroll)
            }
        
//            .background(colorScheme == .dark ? Color.newBGForDark : Color.white)
            .background(colorScheme == .dark ? Color(white: 38 / 255) : Color(white: 239 / 255 ))
            .onAppear(perform: {
                print(" CustomSearchView has appeared!")
                updateViewInHalfSecond()
            })
//            .padding(.top)
            .gesture(scroll)

            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
        .onAppear {
            updateViewInHalfSecond()
        }
    }
}
