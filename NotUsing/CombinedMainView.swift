
//
//  MindMapView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/31.
//

import SwiftUI

struct CombinedMainView: View {
    
    @AppStorage(AppStorageKeys.isFirstLaunch) var isFirstLaunch = true
    @AppStorage(AppStorageKeys.isFirstLaunchAfterBookmarkUpdate) var isFirstAfterBookmarkUpdate = true
    @AppStorage(AppStorageKeys.isFirstScreenSecondView) var isFirstScreenSecondView = false
    
    @Environment(\.scenePhase) var scenePhase
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var folderEditVM: FolderEditViewModel
    
    @EnvironmentObject var trashBinVM: TrashBinViewModel
    @EnvironmentObject var messageVM: MessageViewModel
    
    @ObservedObject var fastFolderWithLevelGroup: FastFolderWithLevelGroup
    
    @FocusState var textFieldFocus: Bool
    
    @State var newFolderName = ""
    @State var isShowingTextField = false
    @State var textFieldType: TextFieldAlertType? = nil
    
    @State var folderToAddSubFolder : Folder? = nil
    @State var isShowingSelectingFolderView = false
    @State var folderToBeRenamed : Folder? = nil
    
    @State var selectionEnum = FolderTypeEnum.folder // default value
    @State var foldersToShow: [Folder] = []
    
    @State var isShowingSearchView = false
    @State var isLoading = false
    //    @State var isShowingSecondView = false
    
    @State var isShowingSecondView: Bool
    
    @State var isAddingMemo = false
    
    
    //    @State var msgToShow: String?
    
    init(fastFolderWithLevelGroup: FastFolderWithLevelGroup
         ,isShowingSecondView: Bool
    ) {
        self.fastFolderWithLevelGroup = fastFolderWithLevelGroup
        _isShowingSecondView = State(initialValue: isShowingSecondView)
    }
    
    func addMemo() {
        isAddingMemo = true
    }
    
    func deleteFolder() {
        DispatchQueue.main.async {
            isLoading = true
        }
        if let validFolderToRemoved = folderEditVM.folderToRemove {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isLoading = false
                //                msgToShow = Messages.showFolderDeleted(targetFolder: validFolderToRemoved)
                messageVM.message = Messages.showFolderDeleted(targetFolder: validFolderToRemoved)
            }
            Folder.moveMemosToTrashAndDelete(from: validFolderToRemoved, to: trashBinVM.trashBinFolder)
            
            folderEditVM.folderToRemove = nil
        }
        context.saveCoreData()
    }
    
    func move(toMemoList: Bool) {
        
        isShowingSecondView = toMemoList
        
    }
    
    var body: some View {
        
        return ZStack {
            
            Color(colorScheme == .dark ? .newBGForDark : .white)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                // MARK: - Start
                
                ZStack {
                    VStack(spacing: 0) {
                        
                        // MARK: - navigation Bar  (need to be in ZStack)
                        HStack {
                            Spacer()
                            HStack(spacing: 0) {
                                //  Button 1: SEARCH
                                Button {
                                    // show SearchView !
                                    isShowingSearchView = true
                                } label: {
                                    SystemImage( "magnifyingglass")
                                        .tint(colorScheme == .dark ? .navColorForDark : .navColorForLight)
                                }
                                
                                // Button 2: Folder Ordering
                                FolderOrderingMenu()
                                    .padding(.leading, 16)
                                
                                // MARK: - Button 3: Add new Folder to the top Folder
                                Button {
                                    isShowingTextField = true
                                    if selectionEnum == .folder {
                                        textFieldType = .newTopFolder
                                        newFolderName = ""
                                    } else {
                                        textFieldType = .newTopArchive
                                        newFolderName = ""
                                    }
                                    
                                } label: { // original : 28
                                    SystemImage( "folder.badge.plus", size: 28)
                                        .foregroundColor(colorScheme == .dark ? .navColorForDark : .navColorForLight)
                                }
                                .padding(.leading, 12)
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.top, 3)
                        
                        
                        //                        Form {
                        List {
                            Section(header: Text("Main Folder")) {
                                ForEach(fastFolderWithLevelGroup.folders, id: \.self) {folderWithLevel in
                                    
                                    if folderWithLevel.folder.parent == nil {
                                        DynamicTopFolderCell(
                                            folder: folderWithLevel.folder,
                                            level: folderWithLevel.level)
                                        .environmentObject(folderEditVM)
                                        .environmentObject(trashBinVM)
                                        // ADD Sub Folder
                                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                            Button {
                                                folderToAddSubFolder = folderWithLevel.folder
                                                isShowingTextField = true
                                                textFieldType = .newSubFolder
                                                newFolderName = ""
                                            } label: {
                                                SystemImage("folder.badge.plus")
                                                    .foregroundColor(.black)
                                            }
                                            .tint(colorScheme == .dark ? Color.darkSwipeBtn1 : Color.lightSwipeBtn1)
                                        }
                                    }
                                    else {
                                        DynamicFolderCell(
                                            folder: folderWithLevel.folder,
                                            level: folderWithLevel.level)
                                        .environmentObject(folderEditVM)
                                        .environmentObject(trashBinVM)
                                        //                                        .listRowBackground(Color.blue)
                                        // ADD Sub Folder
                                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                            Button {
                                                folderToAddSubFolder = folderWithLevel.folder
                                                isShowingTextField = true
                                                textFieldType = .newSubFolder
                                                newFolderName = ""
                                            } label: {
                                                SystemImage("folder.badge.plus")
                                                    .foregroundColor(.black)
                                            }
                                            .tint(colorScheme == .dark ? Color.darkSwipeBtn1 : Color.lightSwipeBtn1)
                                        }
                                        // Change Folder Name
                                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                            
                                            Button {
                                                folderEditVM.folderToRemove = folderWithLevel.folder
                                                isLoading = true
                                                deleteFolder()
                                            } label: {
                                                SystemImage("trash")
                                            }
                                            .tint(.red)
                                            
                                            
                                            // RELOCATE FOLDER
                                            Button {
                                                UIView.setAnimationsEnabled(false)
                                                folderEditVM.shouldShowSelectingView = true
                                                folderEditVM.folderToCut = folderWithLevel.folder
                                            } label: {
                                                SystemImage("folder")
                                            }
                                            //                                            .tint(Color.swipeBtnColor2)
                                            .tint(Color.lightSwipeBtn2)
                                            //                                            .tint(Color(rgba: 0x14A7FA))
                                            //                                            .tint(Color(red: 100, green: 100, blue: 230))
                                            //                                            .tint(Color(red: 81, green: 176, blue: 255))
                                            
                                            Button {
                                                if folderWithLevel.folder.parent != nil {
                                                    isShowingTextField = true
                                                    textFieldType = .rename
                                                    folderToBeRenamed = folderWithLevel.folder
                                                    newFolderName = folderWithLevel.folder.title
                                                }
                                            } label: {
                                                SystemImage("pencil")
                                            }
                                            .tint(colorScheme == .dark ? Color.darkSwipeBtn1 : Color.lightSwipeBtn1)
                                            
                                        }
                                    } // end of ForEach
                                }
                            }
                            
                            
                            // MARK: - Archive, Trashbin
                            // Another ZStack Element
                            //                    VStack {
                            //                        List {
                            Section(header: Text("Archive, TrashBin")) {
                                ForEach(fastFolderWithLevelGroup.archives, id: \.self) {folderWithLevel in
                                    if folderWithLevel.folder.parent == nil {
                                        DynamicTopFolderCell(
                                            folder: folderWithLevel.folder,
                                            level: folderWithLevel.level)
                                        .environmentObject(folderEditVM)
                                        // ADD Sub Folder
                                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                            Button {
                                                folderToAddSubFolder = folderWithLevel.folder
                                                isShowingTextField = true
                                                textFieldType = .newSubFolder
                                                newFolderName = ""
                                            } label: {
                                                SystemImage("folder.badge.plus")
                                                    .foregroundColor(.black)
                                            }
                                            .tint(colorScheme == .dark ? Color.darkSwipeBtn1 : Color.lightSwipeBtn1)
                                        }
                                    } else {
                                        DynamicFolderCell(
                                            folder: folderWithLevel.folder,
                                            level: folderWithLevel.level)
                                        .environmentObject(folderEditVM)
                                        
                                        // ADD Sub Folder
                                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                            Button {
                                                folderToAddSubFolder = folderWithLevel.folder
                                                isShowingTextField = true
                                                textFieldType = .newSubFolder
                                                newFolderName = ""
                                            } label: {
                                                SystemImage("folder.badge.plus")
                                                
                                            }
                                            //                                            .tint(Color.lightSwipeBtn1)
                                            .tint(colorScheme == .dark ? Color.darkSwipeBtn1 : Color.lightSwipeBtn1)
                                            
                                        }
                                        // Change Folder Name
                                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                            // DELETE FOLDER
                                            Button {
                                                folderEditVM.folderToRemove = folderWithLevel.folder
                                                deleteFolder()
                                            } label: {
                                                SystemImage("trash")
                                            }
                                            .tint(.red)
                                            
                                            
                                            // RELOCATE FOLDER
                                            Button {
                                                UIView.setAnimationsEnabled(false)
                                                folderEditVM.shouldShowSelectingView = true
                                                folderEditVM.folderToCut = folderWithLevel.folder
                                            } label: {
                                                SystemImage("folder")
                                            }
                                            //                                            .tint(Color.swipeBtnColor2)
                                            .tint(Color.lightSwipeBtn2)
                                            
                                            Button {
                                                if folderWithLevel.folder.parent != nil {
                                                    isShowingTextField = true
                                                    textFieldType = .rename
                                                    folderToBeRenamed = folderWithLevel.folder
                                                    newFolderName = folderWithLevel.folder.title
                                                }
                                            } label: {
                                                SystemImage("pencil")
                                            }
                                            //                                            .tint(Color.swipeBtnColor2)
                                            //                                            .tint(Color.lightSwipeBtn1)
                                            .tint(colorScheme == .dark ? Color.darkSwipeBtn1 : Color.lightSwipeBtn1)
                                        }
                                    } // end of Else Case
                                } // end of ForEach
                                TrashBinCell()
                                    .environmentObject(trashBinVM)
                                //                        }// end of List
                            }
                        }
                        .listStyle(InsetGroupedListStyle())
                    } // end of VStack , Inside ZStack.
                    .onAppear {
                        UITableView.appearance().backgroundColor = .clear
                    }
                    
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: addMemo) {
                                NewPlusImage()
                            }
                            .padding([ .trailing], Sizes.overallPadding)
                            .padding(.bottom, 20)
                            //                            .padding(.bottom, )
                        }
                    }
                    
                    // another element of ZStack
                    // umm... relocated left
                    SecondMainView2(fastFolderWithLevelGroup: fastFolderWithLevelGroup,
                                    currentFolder: fastFolderWithLevelGroup.homeFolder,
                                    isShowingSecondView: $isShowingSecondView)
                    .environmentObject(trashBinVM)
                    .offset(x: -UIScreen.screenWidth)
                    
                    // TODO: Relocate!. when pressed, mainTabBar shouldn't be seen
                    NavigationLink(destination:
                                    NewMemoView(parent: fastFolderWithLevelGroup.homeFolder, presentingNewMemo: .constant(false)),
                                   isActive: $isAddingMemo) {}
                    
                    
                    
                    if isLoading {
                        Color(.clear)
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                        //                    .tint(colorScheme == .dark ? .cream : .black)
                    }
                    
                    
                    if isShowingTextField {
                        Color(.sRGB, white: colorScheme == .dark ? 0.25 : 0.8, opacity: 0.9)
                            .ignoresSafeArea()
                    }
                    
                    // MARK: - rename is not currently working .
                    
                    PrettyTextFieldAlert(
                        type: textFieldType ?? .rename,
                        isPresented: $isShowingTextField,
                        text: $newFolderName, //
                        focusState: _textFieldFocus) { newName in
                            // MARK: - submit Actions
                            switch textFieldType! {
                                
                            case .newTopFolder:
                                let newFolder = Folder(title: newName, context: context)
                                
                                fastFolderWithLevelGroup.folders.first(
                                    where:{FolderType.compareName($0.folder.title, with: .folder)})!.folder.add(subfolder: newFolder)
                                //                            where:{$0.folder.title == FolderType.getFolderName(type: .folder)})!.folder.add(subfolder: newFolder)
                                
                            case .newTopArchive:
                                
                                let newFolder = Folder(title: newName, context: context)
                                
                                fastFolderWithLevelGroup.archives.first(
                                    where: {FolderType.compareName($0.folder.title, with: .archive)})!.folder.add(subfolder: newFolder)
                                //                            where: {$0.folder.title == FolderType.getFolderName(type: .archive)})!.folder.add(subfolder: newFolder)
                                
                            case .newSubFolder:
                                let newSubFolder = Folder(title: newName, context: context)
                                if let validSubFolder = folderToAddSubFolder {
                                    validSubFolder.add(subfolder: newSubFolder)
                                }
                                
                            case .rename:
                                if folderToBeRenamed != nil {
                                    folderToBeRenamed!.title = newName
                                    folderToBeRenamed!.modificationDate = Date()
                                    folderToBeRenamed = nil
                                    
                                    context.saveCoreData()
                                }
                            }
                            
                            context.saveCoreData()
                            Folder.updateTopFolders(context: context)
                            
                            newFolderName = ""
                            textFieldType = nil
                            isShowingTextField = false
                        } cancelAction: {
                            newFolderName = ""
                            textFieldType = nil
                            isShowingTextField = false
                        }
                    
                    
                }
                .offset(x: isShowingSecondView ? UIScreen.screenWidth : 0)
                .animation(.spring(response: 0.3, dampingFraction: 1, blendDuration: 0.3), value: isShowingSecondView)
                
                // another VStack Element ... ;;;
                // 굳이 필요 없나보네 ?
//                Spacer()
                // MARK: - Main Tab Bar, 이거를 ... SecondView2 에도 넣어줘야 하겠는데 ..?
                
                
                HStack {
                    Button {
                        move(toMemoList: true)
                    } label: {
                        SystemImage(isShowingSecondView ? "rectangle.split.3x1.fill" : "rectangle.split.3x1", size: 24)
                            .rotationEffect(.degrees(90))
                            .scaleEffect(CGSize(width: 1, height: 0.8))
                    }.frame(width: UIScreen.screenWidth / 2)
                    
                    Button {
                        move(toMemoList: false)
                    } label: {
                        SystemImage(isShowingSecondView ?  "folder" : "folder.fill", size: 24)
                    }.frame(width: UIScreen.screenWidth / 2)
                }
                .frame(height: 60)
                .background(Color.black)
                .padding(.bottom, 10)
                //                        .offset(y: isAddingMemo ? 70 : 0)
                //                        .animation(.spring(), value: isAddingMemo)
            }
            .ignoresSafeArea(edges: .bottom)
            
            
            .fullScreenCover(isPresented: $folderEditVM.shouldShowSelectingView,  content: {
                NavigationView {
                    SelectingFolderView(fastFolderWithLevelGroup: fastFolderWithLevelGroup,
//                                        selectionEnum: selectionEnum,
                                        //                                    msgToShow: $msgToShow,
                                        invalidFolderWithLevels:
                                            Folder.getHierarchicalFolders(topFolder: folderEditVM.folderToCut),
                                        isFullScreen: true)
                    .environmentObject(folderEditVM)
                }
            })
            .alert(LocalizedStringStorage.bookmarkRemovingUpdateAlert, isPresented:
                    Binding<Bool>(get: {return !isFirstLaunch && isFirstAfterBookmarkUpdate},
                                  set: { _ in } ),
                   actions: {
                
                Button(role: .none) {
                    
                    // Make All bookmarked pinned
                    let allMemos = Memo.fetchAllmemos(context: context)
                    allMemos.filter { $0.isBookMarked }.forEach{ $0.isPinned = true}
                    
                    
                    DispatchQueue.main.async {
                        isLoading = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isLoading = false
                        messageVM.message = LocalizedStringStorage.completed
                    }
                    
                    isFirstAfterBookmarkUpdate = false
                    
                } label: {
                    Text(LocalizedStringStorage.done)
                }
                
                Button(role: .cancel ) {
                    isFirstAfterBookmarkUpdate = false
                } label: {
                    Text(LocalizedStringStorage.cancel)
                }
            })
            .onChange(of: scenePhase) { newScenePhase in
                if newScenePhase == .background {
                    print("isFirstScreenSecondView has updated to \(isShowingSecondView)")
                    isFirstScreenSecondView = isShowingSecondView
                }
            }
            .navigationBarHidden(true)
        }
    }
}