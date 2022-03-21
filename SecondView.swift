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
//    @Environment(\.presentationMode) var presentationMode
    @AppStorage(AppStorageKeys.pinState) var pinState = true
    
    @ObservedObject var fastFolderWithLevelGroup: FastFolderWithLevelGroup
    @ObservedObject var currentFolder: Folder
    
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    
    @GestureState var isScrolled = false
    
    @FocusState var focusState: Bool
    
    @Binding var isShowingSecondView: Bool
    
    
    @State var searchKeyword = ""
    @State var isShowingSelectingFolderView = false
    @State var isAddingMemo = false
    
    @State var oneOffset: CGFloat = 0
    
    @GestureState var isDragging = false
    /// dragging flag end a little later than isDragging, to complete onEnd Action (for Better UX)
    @State var isOnDraggingAction = false
    
    @State var draggingMemo: Memo? = nil
    
    @State var isShowingSubFolderView = false
    
    @State var isAddingFolder = false
    
//    @State var bookmarkState = true // need to be user Default.
    
//    @State var msgToShow: String?
    
    //    @State var isLoading = false
    
    func addMemo() {
        if !memoEditVM.isSelectionMode {
            isAddingMemo = true
        }
        print("addMemo triggered, state: \(isAddingMemo)")
    }
    
    
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
    
    var allFolders: [Folder] {
        var folders: [Folder] = []
        fastFolderWithLevelGroup.folders.forEach { folders.append($0.folder)}
        fastFolderWithLevelGroup.archives.forEach { folders.append($0.folder)}
        
        return folders
    }
    
    
    var currentFolders: [Folder] {
        var folders: [Folder] = []
        Folder.getHierarchicalFolders(topFolder: currentFolder).forEach { folders.append($0.folder)}
        
        return folders
    }
    
    /*
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
     */
    
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
    
    
    init(fastFolderWithLevelGroup: FastFolderWithLevelGroup,
         currentFolder: Folder,
         isShowingSecondView: Binding<Bool>
    ) {
        self.fastFolderWithLevelGroup = fastFolderWithLevelGroup
        self.currentFolder = currentFolder
        _isShowingSecondView = isShowingSecondView
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
    }
    
    func onEnd(value: DragGesture.Value, memo: Memo) {
        withAnimation {
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
        
        var foundMemos: [NestedMemo] {
            return returnMatchedMemos(targetFolders: allFolders, keyword: searchKeyword)
        }
        
        

        var foundPinnedMemos: [Memo] = []
        
        var foundUnpinnedMemos: [NestedMemo] = []
        
        
        
        // 이것도 안되네 .. ?
//        foundUnpinnedMemos = foundMemos.map { return NestedMemo(memos: $0.memos.filter { !$0.isBookMarked}) }.filter { !$0.memos.isEmpty}
        foundUnpinnedMemos = foundMemos.map { return NestedMemo(memos: $0.memos.filter { !$0.isPinned}) }.filter { !$0.memos.isEmpty}
        
        

        
        foundMemos.forEach { nestedMemo in
//            nestedMemo.memos.filter { $0.isBookMarked}.forEach { allBookMarkedFoundMemos.append($0) }
            nestedMemo.memos.filter { $0.isPinned}.forEach { foundPinnedMemos.append($0) }
        }
        
        
        foundPinnedMemos = Memo.sortMemos(memos: foundPinnedMemos)
        
        
        
        
        
        
        return NavigationView {
            
            ZStack {
                
                VStack(alignment: .leading) {
                    // MARK: - Nav Location
                    HStack {
                        Button {
//                            presentationMode.wrappedValue.dismiss()
                            memoEditVM.initSelectedMemos()
                            isShowingSecondView = false
                            focusState = false
                            searchKeyword = ""
                        } label: {
                            SystemImage("rectangle.lefthalf.inset.fill", size: 24)
                                .foregroundColor(colorScheme == .dark ? .cream : .black)
                            
                        }
                        
                        
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
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(colorScheme == .dark ? Color.cream : Color.clear))
                        .padding(.horizontal, 10)
                        
                        // End of Search TextField
                        Spacer()
                        
                        Button {
                            DispatchQueue.main.async {
                                pinState.toggle()
                            }
                            
                        } label: {
//                            pinState ? SystemImage("bookmark.fill").tint(.navBtnColor) : SystemImage("bookmark.slash").tint(.navBtnColor)
                            pinState ? SystemImage("pin.fill").tint(.navBtnColor) : SystemImage("pin").tint(.navBtnColor)
                        }
                        
                        MemoOrderingMenu(parentFolder: fastFolderWithLevelGroup.homeFolder)
                    }
                    .padding(.horizontal, 20)
                    

                    // 정리 지금 안하면 안됨..
                    ZStack {
                        ScrollView {
                            // spacing: // make tight
                            VStack(spacing: 0) {
                                
                                // ALL FOLDERS
                                
                                // MARK: - Bookmark State is On
                                if foundMemos.count != 0 { // wraps all Memos
                                    if pinState {
                                        
                                        // MARK: - Show Bookmarked Memos First
                                        if foundPinnedMemos.count != 0 {
                                            Section {
                                                // working fine 3.21
                                                ForEach(foundPinnedMemos, id: \.self) { pinnedMemo in
                                                    NavigationLink(destination:
                                                                    MemoView(memo: pinnedMemo, parent: pinnedMemo.folder!, presentingView:.constant(false))
                                                    ) {
                                                        MemoBoxView(memo: pinnedMemo)
                                                            .frame(width: UIScreen.screenWidth - 20, alignment: .center)
                                                            .offset(x: draggingMemo == pinnedMemo ? oneOffset : 0)
                                                            .background {
                                                                BackgroundImage
                                                            }
                                                            .gesture(DragGesture()
                                                                .updating($isDragging, body: { value, state, _ in
                                                                    state = true
                                                                    onChanged(value: value, memo: pinnedMemo)
                                                                }).onEnded({ value in
                                                                    onEnd(value: value, memo: pinnedMemo)
                                                                }))
                                                    }
                                                    .padding(.bottom, Sizes.spacingBetweenMemoBox * 2)
                                                    .disabled(memoEditVM.isSelectionMode)
                                                    .gesture(DragGesture()
                                                        .updating($isDragging, body: { value, state, _ in
                                                            state = true
                                                            onChanged(value: value, memo: pinnedMemo)
                                                        }).onEnded({ value in
                                                            onEnd(value: value, memo: pinnedMemo)
                                                        }))
                                                    .simultaneousGesture(TapGesture().onEnded{
                                                        print("Tap pressed!")
                                                        
                                                        if memoEditVM.isSelectionMode {
                                                            print("Tap gesture triggered!")
                                                            memoEditVM.dealWhenMemoSelected(pinnedMemo)
                                                        }
                                                    })
                                                }
                                            } header: {
                                                HStack {
//                                                    SystemImage("bookmark.fill")
                                                    SystemImage("pin.fill").rotationEffect(.degrees(45))
                                                        .padding(.horizontal, 10)
                                                    Spacer()
                                                }
                                                .padding(.leading, Sizes.overallPadding)
                                                .padding(.vertical, 5)
                                            }
                                            Rectangle()
                                                .frame(height: 1)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .foregroundColor(Color(.sRGB, white: 0.85, opacity: 0.5))
                                                .padding(.vertical, 5)
                                            
                                        }
                                        
                                        // MARK: - Show Unbookmarked Memos Next
                                       
                                        if foundUnpinnedMemos.count != 0 {
                                            
                                            ForEach( foundUnpinnedMemos, id: \.self) { unpinnedMemoArray in
                                                Section(header:
                                                            NavigationLink(destination: {
                                                    FolderView(currentFolder: unpinnedMemoArray.memos.first!.folder!)
                                                }, label: {
                                                    HStack {
                                                        HierarchyLabelView(currentFolder: unpinnedMemoArray.memos.first!.folder!)
                                                        
                                                        Spacer()
                                                    } // end of HStack
                                                    .padding(.leading, Sizes.overallPadding + 5)
                                                }) // end of NavigationLink
                                                ) {
//                                                    ForEach(Memo.sortUnpinnedMemos(memos: unpinnedMemoArray.memos), id: \.self) { memo in
                                                    ForEach(Memo.sortMemos(memos: unpinnedMemoArray.memos), id: \.self) { memo in
                                                        
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
                                    } else { // working weird
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
                                                    ForEach(Memo.sortPinnedFirst(memos: memoArray.memos), id: \.self) { memo in
                                                        
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
                                .frame(height: 50)
                                .foregroundColor(.clear)
                        } // end of ScrollView
                        .gesture(scroll)
                        // another element of ZStack begin // end of ZStack
                        
                        // Plus Button, and MemoToolBarView
                        
                        MemoEditView(
                            plusView:
                                Button(action: addMemo, label: {
                                    PlusImage()
                                        .offset(x: memoEditVM.isSelectionMode ? UIScreen.screenWidth : 0)
                                        .animation(.spring(), value: memoEditVM.isSelectionMode)
                                }),
                            toolbarView:
                                MemosToolBarView(
                                    currentFolder: currentFolder,
                                    showSelectingFolderView: $isShowingSelectingFolderView,
//                                    msgToShow: $msgToShow,
                                    calledFromSecondView: true
                                )
                                .padding(.bottom, Sizes.overallPadding )
                                .offset(x: memoEditVM.isSelectionMode ? 0 : UIScreen.screenWidth)
                                .animation(.spring(), value: memoEditVM.isSelectionMode)
                        )
                        .padding(.horizontal, Sizes.overallPadding)
                        .offset(y: focusState ? UIScreen.screenHeight : 0)
                        .animation(.spring().speed(0.5), value: focusState)
                    }
                } // end of Main VStack
                .navigationBarHidden(true)
                .padding(.top, 6)
                .gesture(scroll)
                // start moving scrollbar to the right !
                
                NavigationLink(destination:
                                NewMemoView(parent: currentFolder, presentingNewMemo: .constant(false)),
                               isActive: $isAddingMemo) {}
                
//                MsgView(msgToShow: $msgToShow)
//                    .padding(.top, UIScreen.screenHeight / 1.5)
                
            } // end of ZStack
            .sheet(isPresented: $isShowingSelectingFolderView,
                   content: {
                SelectingFolderView(
                    fastFolderWithLevelGroup:
                        FastFolderWithLevelGroup(
                            homeFolder: Folder.fetchHomeFolder(context: context)!,
                            archiveFolder: Folder.fetchHomeFolder(context: context,
                                                                  fetchingHome: false)!
                        ),
//                    msgToShow: $msgToShow,
                    invalidFolderWithLevels: []
                )
            })
            .navigationBarHidden(true)
            .onAppear {
                print("SecondView has appeared!")
                updateViewInHalfSecond()
            }
            .onDisappear {
                print("SecondView has disappeared!")
                memoEditVM.initSelectedMemos()
                focusState = false
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .padding(.horizontal, Sizes.overallPadding)
        .onAppear {
            print("CustomSearchView has appeared!!!!!")
        }
    }
}
