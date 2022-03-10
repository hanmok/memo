//
//  SearchView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/02/15.
//

import SwiftUI
import CoreData

struct SecondMainView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var fastFolderWithLevelGroup: FastFolderWithLevelGroup
    
    @ObservedObject var currentFolder: Folder
        
    
    @EnvironmentObject var trashBinVM: TrashBinViewModel
    @EnvironmentObject var memoOrder: MemoOrder
    
    @EnvironmentObject var folderEditVM: FolderEditViewModel
    
    @StateObject var memoEditVM = MemoEditViewModel()

    @GestureState var isScrolled = false
    
    @FocusState var focusState: Bool
    
    @State var searchKeyword = ""
    @State var isShowingSelectingFolderView = false
    @State var searchTypeEnum: SearchType
    @State var isAddingMemo = false

    
    func addMemo() {
        if !memoEditVM.isSelectionMode {
            isAddingMemo = true
        }
        print("addMemo triggered, state: \(isAddingMemo)")
    }
    
    @State var isShowingSubFolderView = false
    @State var isAddingFolder = false
    
    var shouldIncludeTrashOnCurrent: Bool
    var shouldIncludeTrashOverall: Bool
    
    var allFolders: [Folder] {
        var folders: [Folder] = []
        _ = fastFolderWithLevelGroup.folders.map { folders.append($0.folder)}
        _ = fastFolderWithLevelGroup.archives.map { folders.append($0.folder)}
        if shouldIncludeTrashOverall {
        folders.append(trashBinVM.trashBinFolder)
        }
        return folders
    }
    // 여기다..
    
    var currentFolders: [Folder] {
        var folders: [Folder] = []
        _ = Folder.getHierarchicalFolders(topFolder: currentFolder).map { folders.append($0.folder)}
        if shouldIncludeTrashOnCurrent {
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
    

    
    init(fastFolderWithLevelGroup: FastFolderWithLevelGroup,
         currentFolder: Folder,
         shouldShowAll: Bool = false,
         shouldIncludeTrashOnCurrent: Bool = false,
         shouldIncludeTrashOverall: Bool = false
    ) {
        self.fastFolderWithLevelGroup = fastFolderWithLevelGroup
        self.currentFolder = currentFolder
        _searchTypeEnum = State(initialValue: shouldShowAll ? .all : .current)
        self.shouldIncludeTrashOnCurrent = shouldIncludeTrashOnCurrent
        self.shouldIncludeTrashOverall = shouldIncludeTrashOverall
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
            
            ZStack {
            VStack(alignment: .leading) {
                HStack {
                    Button {
                        // make it fullScreen temporary.
                        // navigate to MainMapView.
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        SystemImage("house", size: 24)
                            .foregroundColor(colorScheme == .dark ? .cream : .black)
                        
                    }
                    .padding(.trailing, 10)
                    // TextField HStack
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
                    
                    MemoOrderingMenu(memoOrder: memoOrder, parentFolder: fastFolderWithLevelGroup.homeFolder)
                    
                }
                .padding(.horizontal, Sizes.overallPadding)
            
                ZStack {
                ScrollView {
                    VStack {
                        // ALL FOLDERS
                        if foundMemos != nil {
//                            if searchTypeEnum == .all {
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
                                                }
                                                .padding(.bottom, Sizes.spacingBetweenMemoBox)
                                            }
                                        }
                                    }
                                } else { // no  searchResult
                                    Spacer()
                                    if searchKeyword != "" {
                                    Text(LocalizedStringStorage.emptySearchResult)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                    }
                                }
                        } // nil
                    }
                } // end of ScrollView
                .gesture(scroll)
                } // another element of ZStack begin
                
                VStack {
                    Spacer()
                    ZStack {
                        HStack {
                            Spacer()
                            VStack(spacing: Sizes.minimalSpacing) {
                                
                                Button(action: addMemo) {
                                    PlusImage()
                                        .padding(EdgeInsets(top: 0, leading: 0, bottom: Sizes.overallPadding, trailing: Sizes.overallPadding))
                                        .offset(x: memoEditVM.isSelectionMode ? UIScreen.screenWidth : 0)
                                        .animation(.spring(), value: memoEditVM.isSelectionMode)
                                }
                            }
                        }
                        HStack {
                            Spacer()
                            MemosToolBarView(
                                currentFolder: currentFolder,
                                showSelectingFolderView: $isShowingSelectingFolderView
                            )
                                .padding([.trailing], Sizes.overallPadding)
                                .padding(.bottom,Sizes.overallPadding )
                                .offset(x: memoEditVM.isSelectionMode ? 0 : UIScreen.screenWidth)
                                .animation(.spring(), value: memoEditVM.isSelectionMode)
                        }
                    }
                } // end of VStack
            } // end of Main VStack
            .navigationBarHidden(true)
            .padding(.top)
            .gesture(scroll)
            
            
            NavigationLink(destination:
                            NewMemoView(parent: currentFolder, presentingNewMemo: .constant(false))
                            .environmentObject(folderEditVM)
                            .environmentObject(memoEditVM)
                            .environmentObject(trashBinVM),
                           isActive: $isAddingMemo) {}
            }
            .sheet(isPresented: $isShowingSelectingFolderView,
                   content: {
                SelectingFolderView(
                    fastFolderWithLevelGroup:
                        FastFolderWithLevelGroup(
                            homeFolder: Folder.fetchHomeFolder(context: context)!,
                            archiveFolder: Folder.fetchHomeFolder(context: context,
                                                                  fetchingHome: false)!
                        ), invalidFolderWithLevels: []
                )
                    .environmentObject(folderEditVM)
                    .environmentObject(memoEditVM)
            })
            

            .navigationBarHidden(true)
        }
        .navigationBarHidden(true)
        .onAppear {
            print("CustomSearchView has appeared!!!!!")
        }
    }
}
