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
    @Binding var isShowingSecondView: Bool
    
    @EnvironmentObject var trashBinVM: TrashBinViewModel
    @EnvironmentObject var memoOrder: MemoOrder
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    @EnvironmentObject var folderEditVM: FolderEditViewModel
    
    //    @StateObject var memoEditVM = MemoEditViewModel()
    
    @GestureState var isScrolled = false
    
    @FocusState var focusState: Bool
    
    @State var searchKeyword = ""
    @State var isShowingSelectingFolderView = false
//    @State var searchTypeEnum: SearchType
    @State var isAddingMemo = false
    
    @State var oneOffset: CGFloat = 0
    
    @GestureState var isDragging = false
    /// dragging flag end a little later than isDragging, to complete onEnd Action (for Better UX)
    @State var isOnDraggingAction = false
    
    @State var draggingMemo: Memo? = nil
    
    func addMemo() {
        if !memoEditVM.isSelectionMode {
            isAddingMemo = true
        }
        print("addMemo triggered, state: \(isAddingMemo)")
    }
    
    @State var isShowingSubFolderView = false
    @State var isAddingFolder = false
    
    @State var bookmarkState = true // need to be user Default.
    
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
    
    // determind whether it shows Archive
    var foundMemos: [NestedMemo]? {
//        if searchTypeEnum == .all {
        // shows both folder and archive
            return returnMatchedMemos(targetFolders: allFolders, keyword: searchKeyword)
//        } else {
        // shows folder
//            return returnMatchedMemos(targetFolders: currentFolders, keyword: searchKeyword)
//        }
    }
    

    
    init(fastFolderWithLevelGroup: FastFolderWithLevelGroup,
         currentFolder: Folder,
//         shouldShowAll: Bool = false,
         shouldIncludeTrashOnCurrent: Bool = false,
         shouldIncludeTrashOverall: Bool = false,
         isShowingSecondView: Binding<Bool>
    ) {
        self.fastFolderWithLevelGroup = fastFolderWithLevelGroup
        self.currentFolder = currentFolder
//        _searchTypeEnum = State(initialValue: shouldShowAll ? .all : .current)
        self.shouldIncludeTrashOnCurrent = shouldIncludeTrashOnCurrent
        self.shouldIncludeTrashOverall = shouldIncludeTrashOverall
        _isShowingSecondView = isShowingSecondView
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
    
    func onChanged(value: DragGesture.Value, memo: Memo) {
        DispatchQueue.main.async {
            draggingMemo = memo
            
        }
        print("onChanged triggered")
        
        if isDragging && value.translation.width < -5 {
            
            DispatchQueue.main.async {
                isOnDraggingAction = true
            }
        }
        
        
        if isDragging && value.translation.width < 0 {
            
            print("dragged value: \(value.translation.width)")
            switch value.translation.width {
            case let width where width <= -65:
                DispatchQueue.main.async {
                    
                    oneOffset = -65
                }
            default:
                DispatchQueue.main.async {
                    oneOffset = value.translation.width
                }
            }
        }
        print("isDraggingAction: \(isOnDraggingAction)")
    }
    
    func onEnd(value: DragGesture.Value, memo: Memo) {
        withAnimation {
            print("onEnd triggered")
            if value.translation.width <= -65 {
                
                DispatchQueue.main.async {
                    memoEditVM.isSelectionMode = true
                    memoEditVM.dealWhenMemoSelected(memo)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    
                    oneOffset = 0
                    
                    isOnDraggingAction = false
                }
                
            } else {
                DispatchQueue.main.async {
                    oneOffset = 0
                    isOnDraggingAction = false
                }
            }
        }
        draggingMemo = nil
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
                            isShowingSecondView = false
                        } label: {
                                                        SystemImage("house", size: 24)
//                            SystemImage("magnifyingglass")
                                .foregroundColor(colorScheme == .dark ? .cream : .black)
                            
                        }
                        // temp
//                        .padding(.leading, 16)
//                        .padding(.trailing, 10)
                        
                        // TextField HStack
                        HStack(spacing: 0) {
                            
                            ChangeableImage(imageSystemName: "magnifyingglass", height: 16)
                                .foregroundColor(Color(white: 131 / 255))
                                .padding(.horizontal, 7)
                            
                            TextField(LocalizedStringStorage.searchPlaceholder, text: $searchKeyword)
                                .accentColor(Color.textViewTintColor)
                            
                                .focused($focusState)
//                                .frame(width: UIScreen.screenWidth - 9 * Sizes.overallPadding, alignment: .leading)
                                .frame(alignment: .leading)
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
//                        .frame(width: UIScreen.screenWidth - 5.1 * Sizes.overallPadding )
                        .background(colorScheme == .dark ? Color(white: 16 / 255): Color(white: 239 / 255 ))
                        .cornerRadius(10)
                        
                        Spacer()
                        
                        Button {
                            bookmarkState.toggle()
                        } label: {
                            bookmarkState ? SystemImage("bookmark").tint(.navBtnColor) : SystemImage("bookmark.slash").tint(.navBtnColor)
                        }
                        MemoOrderingMenu(memoOrder: memoOrder, parentFolder: fastFolderWithLevelGroup.homeFolder)
//                            .padding(.trailing, 20)
                        // temp
                        
                    }
                    .padding(.horizontal, 10)
                    // 정리 지금 안하면 안됨..
                    ZStack {
                        ScrollView {
                            // spacing: // make tight
                            VStack(spacing: 0) {
//                            VStack {
                                // ALL FOLDERS
                                if foundMemos != nil {
                                    //                            if searchTypeEnum == .all {
                                    if foundMemos!.count != 0 {
                                        ForEach( foundMemos!, id: \.self) { memoArray in
                                            
                                            Section(header:
                                                        NavigationLink(destination: {
                                                FolderView(currentFolder: memoArray.memos.first!.folder!)
                                                    .environmentObject(memoEditVM)
                                                    .environmentObject(folderEditVM)
                                                    .environmentObject(memoOrder)
                                                    .environmentObject(trashBinVM)
                                            }, label: {
                                                HStack {
                                                     // make tight
                                                    HierarchyLabelView(currentFolder: memoArray.memos.first!.folder!)
                                                    Spacer()
                                                } // end of HStack
                                                .padding(.leading, Sizes.overallPadding + 5)
                                            }) // end of NavigationLink
                                            ) {
                                                ForEach(Memo.sortMemosWithPinAndBookmark(memos: memoArray.memos), id: \.self) { memo in
                                                    NavigationLink(destination:
                                                                    MemoView(memo: memo, parent: memo.folder!, presentingView:.constant(false))
                                                                    .environmentObject(memoEditVM)
                                                                    .environmentObject(folderEditVM)
                                                                    .environmentObject(trashBinVM)
                                                    ) {
                                                        MemoBoxView(memo: memo)
                                                            .environmentObject(memoEditVM)
                                                            .frame(width: UIScreen.screenWidth - 20, alignment: .center)
                                                            .offset(x: draggingMemo == memo ? oneOffset : 0)
                                                            .background {
                                                                ZStack {
                                                                    Color(isOnDraggingAction ? .memoBoxSwipeBGColor : .white)
                                                                        .frame(width: UIScreen.screenWidth  - 2 * Sizes.overallPadding - 2)
                                                                        .cornerRadius(10)
                                                                    HStack {
                                                                        Spacer()
                                                                        SystemImage("checkmark")
                                                                            .frame(width: 65)
                                                                            .foregroundColor(.basicColors)
                                                                            .opacity(isOnDraggingAction ? 1 : 0)
                                                                    }
                                                                }
                                                                .padding(.horizontal, Sizes.smallSpacing)
                                                                .frame(width: UIScreen.screenWidth  - 2 * Sizes.overallPadding - 2 )
                                                            }
                                                        
                                                            .gesture(DragGesture()
                                                                        .updating($isDragging, body: { value, state, _ in
                                                                state = true
                                                                onChanged(value: value, memo: memo)
                                                            }).onEnded({ value in
                                                                onEnd(value: value, memo: memo)
                                                            }))
                                                    } // end of ZStack
                        
                                                    .padding(.bottom, Sizes.spacingBetweenMemoBox * 2)
                                                    .disabled(memoEditVM.isSelectionMode)
                                                    .gesture(DragGesture()
                                                                .updating($isDragging, body: { value, state, _ in
                                                        state = true
                                                        onChanged(value: value, memo: memo)
                                                    }).onEnded({ value in
                                                        onEnd(value: value, memo: memo)
                                                    }))
                                                    
                                                    .simultaneousGesture(TapGesture().onEnded{
                                                        print("Tap pressed!")
                                                        
                                                        if memoEditVM.isSelectionMode {
                                                            print("Tap gesture triggered!")
                                                            memoEditVM.dealWhenMemoSelected(memo)
                                                        }
                                                    })
                                                } // end of ForEach
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
                        // another element of ZStack begin // end of ZStack
                        
                        // Plus Button, and MemoToolBarView
                        VStack {
                            Spacer()
                            ZStack {
                                HStack {
                                    Spacer()
                                    VStack(spacing: Sizes.minimalSpacing) {
                                        
                                        Button(action: addMemo) {
                                            PlusImage()
//                                                .padding(EdgeInsets(top: 0, leading: 0, bottom: Sizes.overallPadding, trailing: Sizes.overallPadding))
                                                .padding(.trailing, 10)
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
                                        .padding(.trailing, 10)
                                        .padding(.bottom,Sizes.overallPadding )
                                        .offset(x: memoEditVM.isSelectionMode ? 0 : UIScreen.screenWidth)
                                        .animation(.spring(), value: memoEditVM.isSelectionMode)
                                }
                            }
                        } // end of Memo Realated View
                    }
                } // end of Main VStack
                .navigationBarHidden(true)
                .padding(.horizontal, Sizes.overallPadding)
                .padding(.top, 6)
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
        .environmentObject(trashBinVM)
        .environmentObject(memoOrder)
        .environmentObject(memoEditVM)
        .environmentObject(folderEditVM)
        .padding(.horizontal, Sizes.overallPadding)
        
        .navigationBarHidden(true)
        .onAppear {
            print("CustomSearchView has appeared!!!!!")
        }
    }
}