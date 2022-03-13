//
//  SearchView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/02/15.
//

import SwiftUI
import CoreData

struct SecondView: View {
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
    
    @State var msgToShow: String?
    
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
    
//    var shouldIncludeTrashOnCurrent: Bool
//    var shouldIncludeTrashOverall: Bool
    
    var allFolders: [Folder] {
        var folders: [Folder] = []
        _ = fastFolderWithLevelGroup.folders.map { folders.append($0.folder)}
        _ = fastFolderWithLevelGroup.archives.map { folders.append($0.folder)}
//        if shouldIncludeTrashOverall {
//            folders.append(trashBinVM.trashBinFolder)
//        }
        return folders
    }
    
    
    var currentFolders: [Folder] {
        var folders: [Folder] = []
        _ = Folder.getHierarchicalFolders(topFolder: currentFolder).map { folders.append($0.folder)}
//        if shouldIncludeTrashOnCurrent {
//            folders.append(trashBinVM.trashBinFolder)
//        }
        print("appended Folders in currnetFolders: \(folders)")
        
        _ = folders.map { print($0.title)}
        
        return folders
    }
    
    // determind whether it shows Archive
    var foundMemos: [NestedMemo] {
        //        if searchTypeEnum == .all {
        // shows both folder and archive
//        print("nestedMemos form: \(returnMatchedMemos(targetFolders: allFolders, keyword: searchKeyword))")
        return returnMatchedMemos(targetFolders: allFolders, keyword: searchKeyword)
        //        } else {
        // shows folder
        //            return returnMatchedMemos(targetFolders: currentFolders, keyword: searchKeyword)
        //        }
    }
    
    var BackgroundImage: some View {
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
    
    //    struct makeMemoBoxView: ViewModifier {
    //        func body(content: Content) -> some View {
    //            content
    //                .frame(width: UIScreen.screenWidth - 20, alignment: .center)
    //                .offset(x: draggingMemo == memo ? oneOffset : 0)
    //                .background {
    //                    BackgroundImage
    //                }
    //        }
    //    }
    
    init(fastFolderWithLevelGroup: FastFolderWithLevelGroup,
         currentFolder: Folder,
         //         shouldShowAll: Bool = false,
//         shouldIncludeTrashOnCurrent: Bool = false,
//         shouldIncludeTrashOverall: Bool = false,
         isShowingSecondView: Binding<Bool>
    ) {
        self.fastFolderWithLevelGroup = fastFolderWithLevelGroup
        self.currentFolder = currentFolder
        //        _searchTypeEnum = State(initialValue: shouldShowAll ? .all : .current)
//        self.shouldIncludeTrashOnCurrent = shouldIncludeTrashOnCurrent
//        self.shouldIncludeTrashOverall = shouldIncludeTrashOverall
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
        
        var allBookMarkedFoundMemos: [Memo] = []
        
        var foundMemosWithoutBookmark = foundMemos.map {
            return NestedMemo(memos: $0.memos.filter { !$0.isBookMarked})
//            nested = $0.memos.filter {
//                !$0.isBookMarked
//            }
        }
        
        foundMemosWithoutBookmark = foundMemosWithoutBookmark.filter { !$0.memos.isEmpty }
        

        for each in foundMemos {
                _ = each.memos.filter { $0.isBookMarked }.map { allBookMarkedFoundMemos.append( $0) }
            }
        
        allBookMarkedFoundMemos = Memo.sortMemos(memos: allBookMarkedFoundMemos)
        
        print("nestedMemos form: \(foundMemos)")
        
        return NavigationView {
            
            ZStack {

                VStack(alignment: .leading) {
                    // MARK: - Nav Location
                    HStack {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                            isShowingSecondView = false
                        } label: {
                            SystemImage("house", size: 24)
                                .foregroundColor(colorScheme == .dark ? .cream : .black)
                            
                        }
                        
//                        Spacer()
//                            .padding(.horizontal)
                        // Search TextField
                        HStack(spacing: 0) {
                            
                            ChangeableImage(imageSystemName: "magnifyingglass", height: 16)
                                .foregroundColor(Color(white: 131 / 255))
                                .padding(.horizontal, 7)
                            
                            TextField(LocalizedStringStorage.searchPlaceholder, text: $searchKeyword)
                                .accentColor(Color.textViewTintColor)
                                .focused($focusState)
                                .frame(alignment: .leading)
                                .frame(height: 30)
                                .foregroundColor(Color.blackAndWhite)
                                .submitLabel(.search)

                            
//                            Spacer()
                            
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
                        .background(colorScheme == .dark ? Color(white: 16 / 255): Color(white: 239 / 255 ))
                        .cornerRadius(10)
                        .padding(.horizontal, 10)
                        // End of Search TextField
                        Spacer()
//                            .padding(.horizontal)
                        Button {
                            
                            bookmarkState.toggle()
                            
                            print("bookmarkState: \(bookmarkState)")
                            print("button has pressed!!")
                        } label: {
                            bookmarkState ? SystemImage("bookmark.fill").tint(.navBtnColor) : SystemImage("bookmark.slash").tint(.navBtnColor)
                        }
                        MemoOrderingMenu(memoOrder: memoOrder, parentFolder: fastFolderWithLevelGroup.homeFolder)
                    }
                    
                    // solve UI Padding bug For search result is none
                    .padding(.horizontal, foundMemos.count == 0 ? 0 : 10)
                    // 정리 지금 안하면 안됨..
                    ZStack {
                        ScrollView {
                            // spacing: // make tight
                            VStack(spacing: 0) {
                                
                                
                                // ALL FOLDERS
                                
                                // MARK: - Bookmark State is On
                                if foundMemos.count != 0 { // wraps all Memos
                                        if bookmarkState {
                                            // MARK: - Show Bookmarked Memos First
                                            if allBookMarkedFoundMemos.count != 0 {
                                            Section {
                                                ForEach(allBookMarkedFoundMemos, id: \.self) { markedMemo in
                                                    NavigationLink(destination:
                                                                    MemoView(memo: markedMemo, parent: markedMemo.folder!, presentingView:.constant(false))
                                                    ) {
                                                        MemoBoxView(memo: markedMemo)
                                                            .frame(width: UIScreen.screenWidth - 20, alignment: .center)
                                                            .offset(x: draggingMemo == markedMemo ? oneOffset : 0)
                                                            .background {
                                                                BackgroundImage
                                                            }
                                                            .gesture(DragGesture()
                                                                        .updating($isDragging, body: { value, state, _ in
                                                                state = true
                                                                onChanged(value: value, memo: markedMemo)
                                                            }).onEnded({ value in
                                                                onEnd(value: value, memo: markedMemo)
                                                            }))
                                                    }
                                                    .padding(.bottom, Sizes.spacingBetweenMemoBox * 2)
                                                    .disabled(memoEditVM.isSelectionMode)
                                                    .gesture(DragGesture()
                                                                .updating($isDragging, body: { value, state, _ in
                                                        state = true
                                                        onChanged(value: value, memo: markedMemo)
                                                    }).onEnded({ value in
                                                        onEnd(value: value, memo: markedMemo)
                                                    }))
                                                    .simultaneousGesture(TapGesture().onEnded{
                                                        print("Tap pressed!")
                                                        
                                                        if memoEditVM.isSelectionMode {
                                                            print("Tap gesture triggered!")
                                                            memoEditVM.dealWhenMemoSelected(markedMemo)
                                                        }
                                                    })
                                                }
                                            } header: {
                                                HStack {
                                                    SystemImage("bookmark.fill")
                                                    
                                                    Spacer()
                                                }
                                                .padding(.leading, Sizes.overallPadding)
                                                .padding(.vertical, 5)
                                            }
                                            
                                            
                                        Rectangle()
                                                .frame(width: UIScreen.screenWidth - 2 * Sizes.overallPadding, height: 3, alignment: .center)
//                                                .foregroundColor(Color.mainColor)
                                                .foregroundColor(colorScheme == .dark ? Color.init(white: 0.1) : .cream )
                                                .padding(.top, 4)
                                            
                                            Rectangle()
                                                    .frame(width: UIScreen.screenWidth - 2 * Sizes.overallPadding, height: 3, alignment: .center)
//                                                    .foregroundColor(Color.mainColor)
                                                    .foregroundColor(colorScheme == .dark ? Color.init(white: 0.1) : .cream )
                                                    .padding(.vertical, 4)
                                            
                                            }
                                            
                                            // MARK: - Show Unbookmarked Memos Next
                                            if foundMemosWithoutBookmark.count != 0 {
                                                
                                                    ForEach( foundMemosWithoutBookmark, id: \.self) { memoArray in
                                                        Section(header:
                                                                    NavigationLink(destination: {
                                                            FolderView(currentFolder: memoArray.memos.first!.folder!)
                                                        }, label: {
                                                            HStack {
                                                                HierarchyLabelView(currentFolder: memoArray.memos.first!.folder!)
                                                                    
                                                                Spacer()
                                                            } // end of HStack
                                                            .padding(.leading, Sizes.overallPadding + 5)
                                                        }) // end of NavigationLink
                                                        ) {
                                                            ForEach(Memo.sortMemosWithPinNoBookmark(memos: memoArray.memos), id: \.self) { memo in
                                                                
                                                                NavigationLink(destination:
                                                                                MemoView(memo: memo, parent: memo.folder!, presentingView:.constant(false))
                                                                ) {
                                                                    MemoBoxView(memo: memo)
                                                                        .frame(width: UIScreen.screenWidth - 20, alignment: .center)
                                                                        .offset(x: draggingMemo == memo ? oneOffset : 0)
                                                                        .background {
                                                                            BackgroundImage
                                                                        }
                                                                        .gesture(DragGesture()
                                                                                    .updating($isDragging, body: { value, state, _ in
                                                                            state = true
                                                                            onChanged(value: value, memo: memo)
                                                                        }).onEnded({ value in
                                                                            onEnd(value: value, memo: memo)
                                                                        }))
                                                                }
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
                                                    } // end of ForEach
                                                }
                                            // MARK: - BookMark State Off -> Show Bookmark & pinned Memos First, and then normal Memos
                                        } else {
                                            if foundMemos.count != 0 {
                                                HStack {
                                                Text("").padding(.vertical, 1)
                                                }
                                                ForEach( foundMemos, id: \.self) { memoArray in
                                                        Section(header:
                                                                    NavigationLink(destination: {
                                                            FolderView(currentFolder: memoArray.memos.first!.folder!)
                                                        }, label: {
                                                            HStack {
                                                                HierarchyLabelView(currentFolder: memoArray.memos.first!.folder!)
                                                                   
                                                                Spacer()
                                                            } // end of HStack
                                                            .padding(.leading, Sizes.overallPadding + 5)
                                                        }) // end of NavigationLink
                                                        ) {
                                                            ForEach(Memo.sortMemosWithPinAndBookmark(memos: memoArray.memos), id: \.self) { memo in
                                                                
                                                                NavigationLink(destination:
                                                                                MemoView(memo: memo, parent: memo.folder!, presentingView:.constant(false))
                                                                ) {
                                                                    MemoBoxView(memo: memo)
                                                                        .frame(width: UIScreen.screenWidth - 20, alignment: .center)
                                                                        .offset(x: draggingMemo == memo ? oneOffset : 0)
                                                                        .background {
                                                                            BackgroundImage
                                                                        }
                                                                        .gesture(DragGesture()
                                                                                    .updating($isDragging, body: { value, state, _ in
                                                                            state = true
                                                                            onChanged(value: value, memo: memo)
                                                                        }).onEnded({ value in
                                                                            onEnd(value: value, memo: memo)
                                                                        }))
                                                                }
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
                            }
                            Rectangle()
                                .frame(height: 100)
                                .foregroundColor(.clear)
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
                                        showSelectingFolderView: $isShowingSelectingFolderView,
                                        msgToShow: $msgToShow, calledFromSecondView: true
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
                
                MsgView(msgToShow: $msgToShow)
                    .padding(.top, UIScreen.screenHeight / 1.5)
                
            } // end of ZStack
            .sheet(isPresented: $isShowingSelectingFolderView,
                   content: {
                SelectingFolderView(
                    fastFolderWithLevelGroup:
                        FastFolderWithLevelGroup(
                            homeFolder: Folder.fetchHomeFolder(context: context)!,
                            archiveFolder: Folder.fetchHomeFolder(context: context,
                                                                  fetchingHome: false)!
                        ), invalidFolderWithLevels: [], msgToShow: $msgToShow
                )
                    .environmentObject(folderEditVM)
                    .environmentObject(memoEditVM)
            })
            .navigationBarHidden(true)
            .onAppear {
                print("SecondView has appeared!")
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                    searchKeyword += " "
//                    searchKeyword.removeLast()
////                DispatchQueue.main.asyncAfter
//
//            }
                updateViewInHalfSecond()
            }
            .onDisappear {
                print("SecondView has disappeared!")
//                memoEditVM.selectedMemos.removeAll()
                memoEditVM.initSelectedMemos()
            }
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
