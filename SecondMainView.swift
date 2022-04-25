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
    //    @Environment(\.presentationMode) var presentationMode
    @AppStorage(AppStorageKeys.pinState) var pinState = true
    @AppStorage(AppStorageKeys.inFolderOrder) var inFolderOrder = true
    @AppStorage(AppStorageKeys.isHidingArchive) var isHidingArchive = true
    
    @AppStorage(AppStorageKeys.mOrderType) var mOrderType = OrderType.modificationDate
    @AppStorage(AppStorageKeys.mOrderAsc) var mOrderAsc = false
//    @Environment()
    
    @ObservedObject var fastFolderWithLevelGroup: FastFolderWithLevelGroup
    @ObservedObject var currentFolder: Folder
    
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    
    @GestureState var isScrolled = false
    
    @FocusState var focusState: Bool
    
    @StateObject var dragVM = DraggableViewModel()
    @Binding var isShowingSecondView: Bool
    
    
    @State var searchKeyword = ""
    @State var isShowingSelectingFolderView = false
    @State var isAddingMemo = false
    
    @State var oneOffset: CGFloat = 0
    
    @GestureState var isDragging = false
    /// dragging flag end a little later than isDragging, to complete onEnd Action (for Better UX)
    ///
    @State var isOnDraggingAction = false
    
    @State var draggingMemo: Memo? = nil
    
    @State var isShowingSubFolderView = false
    
    @State var isAddingFolder = false
    
    
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
    
    
    var rotatedPinWithPadding: some View {
        HStack {
            SystemImage("pin.fill").rotationEffect(.degrees(45))
                .padding(.horizontal, 10)
            Spacer()
        }
        .padding(.leading, Sizes.overallPadding)
        .padding(.vertical, 5)
    }
    
    
    var dividerBetweenPin: some View {
        Rectangle()
            .frame(height: 1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(Color(.sRGB, white: 0.85, opacity: 0.5))
            .padding(.vertical, 5)
    }

    
    
    var body: some View {
        
        let scroll = DragGesture(minimumDistance: 10, coordinateSpace: .local)
            .updating($isScrolled) { _, _, _ in
                print("is Scrolling : \(isScrolled)")
                focusState = false
            }
        
        var foundNestedMemos: [NestedMemo] {
            if isHidingArchive {
                return returnMatchedMemos(targetFolders: currentFolders, keyword: searchKeyword)
            } else {
                return returnMatchedMemos(targetFolders: allFolders, keyword: searchKeyword)
            }
        }
        
        return NavigationView {
            
            ZStack {
                VStack(alignment: .leading) {
                    // MARK: - Nav Location
                    HStack {
                        Button {
                            memoEditVM.initSelectedMemos()
                            isShowingSecondView = false
                            focusState = false
                            searchKeyword = ""
                        } label: {
                            SystemImage("rectangle.lefthalf.inset.fill", size: 24)
//                                .foregroundColor(colorScheme == .dark ? .cream : .black)
                                .foregroundColor(colorScheme == .dark ? Color.newNavForDark : Color.newNavForLight)
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
                        
                        OrderingMenuInSecondView(pinState: $pinState,
                                                 inFolderOrder: $inFolderOrder,
                                                 isHidingArchive: $isHidingArchive)
                        
                    }
                    .padding(.horizontal, 20)
                    
                    
                    ZStack {
                        ScrollView {
                            VStack(spacing: 0) {

                                if foundNestedMemos.count != 0 { // wraps all Memos
                                    // MARK: - Pin State is On
                                    if pinState {
                                        // MARK: - Show Pinned Memos First
                                        if Memo.checkIfHasPinned(from: foundNestedMemos){
                                            Section {
                                                ForEach(Memo.getPinnedOnly(from: foundNestedMemos ), id: \.self) { pinnedMemo in
                                                    DraggableMemoBoxView(memo: pinnedMemo)
                                                        .environmentObject(dragVM)
                                                }
                                            } header: {
                                                rotatedPinWithPadding
                                            }
                                            
                                            dividerBetweenPin
                                        
                                        }
                                        
                                        // MARK: - Show UnPinned Memos Next
                                        if Memo.checkIfHasUnpinned(from: foundNestedMemos) {
                                            if inFolderOrder {
                                                // MARK: - Pin State & inFolderOrder. spread unpinnedMemos with containing folders
                                                ForEach( Memo.getUnpinnedNestedMemos(from: foundNestedMemos), id: \.self) { unpinnedMemoArray in
                                                    Section(header:
                                                                NavigationLink(destination: {
                                                        FolderView(currentFolder: unpinnedMemoArray.memos.first!.folder!)
                                                    }, label: {
                                                        HStack {
                                                            HierarchyLabelView(currentFolder: unpinnedMemoArray.memos.first!.folder!)
                                                            Spacer()
                                                        }
                                                        .padding(.top, 10)
                                                        .padding(.bottom, 4)
                                                        .padding(.leading, Sizes.overallPadding + 5)
                                                    })
                                                    ) {
                                                        ForEach(Memo.sortMemos(memos: unpinnedMemoArray.memos), id: \.self) { memo in
                                                            DraggableMemoBoxView(memo: memo)
                                                                .environmentObject(dragVM)
                                                        }
                                                    }
                                                }
                                                // MARK: - Pin State & !inFolderOrder. spread all unpinned memos without folders
                                            } else {
                                                Text(" ").font(.caption2)
                                                ForEach(Memo.getUnpinnedMemos(from: foundNestedMemos), id: \.self) { unpinnedMemo in
                                                    DraggableMemoBoxView(memo: unpinnedMemo)
                                                        .environmentObject(dragVM)
                                                }
                                            }
                                        }
                                        // MARK: - Pin State Off
                                    } else {
                                        if foundNestedMemos.count != 0 {
                                            HStack {
                                                Text("").padding(.vertical, 1)
                                            }
                                            if inFolderOrder {
                                                // MARK: - Pin: Off, in FolderOrder -> spread memos with folders, pinned placed to the top
                                                ForEach( foundNestedMemos, id: \.self) { memoArray in
                                                    Section(header:
                                                                NavigationLink(destination: {
                                                        FolderView(currentFolder: memoArray.memos.first!.folder!)
                                                    }, label: {
                                                        HStack {
                                                            HierarchyLabelView(currentFolder: memoArray.memos.first!.folder!)
                                                            Spacer()
                                                        } // end of HStack
                                                        .padding(.top, 10)
                                                        .padding(.bottom, 4)
                                                        .padding(.leading, Sizes.overallPadding + 5)
                                                        
                                                    }) // end of NavigationLink
                                                    ) {
                                                        ForEach(Memo.sortPinnedFirst(memos: memoArray.memos), id: \.self) { memo in
                                                            DraggableMemoBoxView(memo: memo)
                                                                .environmentObject(dragVM)
                                                        } // end of ForEach
                                                    }
                                                } // end of ForEach
                                            } else { // MARK: - Pin Off, not in Folder Order -> follow memo sorting only
                                                ForEach(Memo.getAllMemos(from: foundNestedMemos), id: \.self) { memo in
                                                    DraggableMemoBoxView(memo: memo)
                                                        .environmentObject(dragVM)
                                                }
                                            }
                                        }
                                    } // end of else pin state
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
                        
                        MemoEditView(
                            plusView:
                                Button(action: addMemo, label: {
//                                    PlusImage()
                                    RadialPlusImage()
                                        .offset(x: memoEditVM.isSelectionMode ? UIScreen.screenWidth : 0)
                                        .animation(.spring(), value: memoEditVM.isSelectionMode)
                                }),
                            toolbarView:
                                MemosToolBarView(
                                    currentFolder: currentFolder,
                                    showSelectingFolderView: $isShowingSelectingFolderView,
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
//        .padding(.horizontal, Sizes.overallPadding)
    }
}


//struct DividerBetweenPin: View {
//    var body: some View{
//        Rectangle()
//            .frame(height: 1)
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .foregroundColor(Color(.sRGB, white: 0.85, opacity: 0.5))
//            .padding(.vertical, 5)
//    }
//}

//struct RotatedPinWithPadding: View {
//    var body: some View {
//        HStack {
//            SystemImage("pin.fill").rotationEffect(.degrees(45))
//                .padding(.horizontal, 10)
//            Spacer()
//        }
//        .padding(.leading, Sizes.overallPadding)
//        .padding(.vertical, 5)
//    }
//}

struct OrderingMenuInSecondView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var pinState: Bool
    @Binding var inFolderOrder: Bool
    @Binding var isHidingArchive: Bool

    var body: some View {

        Menu {
            Toggle(isOn: $pinState) {
                Text(LocalizedStringStorage.pinOnTheTop)
            }
            Toggle(isOn: $inFolderOrder) {
                Text(LocalizedStringStorage.inFolderOrder)
            }
            Toggle(isOn: $isHidingArchive) {
                Text(LocalizedStringStorage.hideArchive)
            }

            Divider()
            Divider()

            MemoOrderingMenuInSecondView()

            FolderOrderingMenuInSecondView()

        } label: {
            SystemImage("arrow.up.arrow.down")
//                .tint(Color.navBtnColor)
                .tint(colorScheme == .dark ? .newNavForDark : .newNavForLight)
        }
    }
}
