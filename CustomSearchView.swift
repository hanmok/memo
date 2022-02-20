//
//  SearchView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/02/15.
//

import SwiftUI
import CoreData

//enum SearchType: String {
//    case all = "All"
//    case current = "Current"
//}

// scrolling is not working well in search..
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
        
        print("returnMatchedMemos has triggered")
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
                            .foregroundColor(Color(white: 131 / 255))
                            .padding(.horizontal, 7)

                        TextField("Search2", text: $searchKeyword)
                            .focused($focusState)
                            .frame(width: UIScreen.screenWidth - 9 * Sizes.overallPadding, alignment: .leading)
                            .frame(height: 30)
                            .focused($focusState)
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
                                .tint(colorScheme.adjustBlackAndWhite())
                                .frame(width: 8, height: 8)
                            }
                            .padding(.trailing, 10)
                        }
                    }
                    .frame(height: 32)
                    .frame(width: UIScreen.screenWidth - 5.1 * Sizes.overallPadding)
                    .background(Color(white: 239 / 255 ))
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
                .gesture(scroll)
            }
//            Spacer()
            .padding(.top)
            .gesture(scroll)

//            .searchable(text: $searchKeyword)
//            .searchable(text: $searchKeyword, focus)
//            .focused($focusState)
//            .onSubmit(of: .search) {
//            }
            
//            .navigationBarItems(
//                trailing:
//                    Button(action: {
//                        showingSearchView = false
//                        hidingNavBar = false
//                    }, label: {
////                        Image(systemName: "multiply")
//                        ChangeableImage(imageSystemName: "multiply")
//                            .foregroundColor(colorScheme.adjustBlackAndWhite())
////                        Image(systemName: "").frame(height: 28)
//                    })
////                    .padding(.trailing, Sizes.overallPadding)
//            )
            .navigationBarHidden(true)
        }
    }
}
