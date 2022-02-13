//
//  MindMapView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/31.
//

import SwiftUI

struct FolderWithLevel: Hashable {
    var folder: Folder
    var level: Int
    var isCollapsed: Bool = false
    var isShowing: Bool = true
}

class FolderGroup: ObservableObject {
    @Published var realFolders: [Folder]
    init(targetFolders: [Folder]) {
        self.realFolders = targetFolders
    }
}

struct LevelAndCollapsed {
    var level: Int
    var collapsed: Bool
}


struct MindMapView: View {
    
//    @AppStorage("ordering") private(set) var order: Ordering = Ordering(folderType: "Modification Date", memoType: "Creation Date", folderAsc: true, memoAsc: false)
    
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var memoEditVM = MemoEditViewModel()
    @StateObject var folderEditVM = FolderEditViewModel()
    @StateObject var folderOrder = FolderOrder()
    @StateObject var memoOrder = MemoOrder()
    
    @ObservedObject var fastFolderWithLevelGroup: FastFolderWithLevelGroup
    
    @FocusState var textFieldFocus: Bool
    
    @State var newFolderName = ""
    
    @State var showTextField = false
    @State var textFieldType: TextFieldAlertType? = nil
    
    @State var folderToAddSubFolder : Folder? = nil
    
    @State var showSelectingFolderView = false
    
    @State var folderToBeRenamed : Folder? = nil
    
    @State var isAddingMemo = false
    
    @State var selectionEnum = FolderTypeEnum.folder // default value
    
    func addMemo() {
            isAddingMemo = true
        
    }
    
    var body: some View {
        return ZStack {
            VStack(spacing: 0) {
                // MARK: - TOP Views
                HStack {
                    Spacer()
                    HStack {
                        FolderOrderingMenu(folderOrder: folderOrder)
                            .padding(.trailing, Sizes.smallSpacing)
                        
                        // Add new Folder to the top Folder
                        Button {
                            //                            shouldAddFolderToTop = true
                            showTextField = true
                            textFieldType = .newTopFolder
                        } label: {
                            //                            ChangeableImage(imageSystemName: "plus")
                            ChangeableImage(imageSystemName: "folder.badge.plus", width: 28, height: 28)
                            
                                .foregroundColor(colorScheme.adjustBlackAndWhite())
                        }
                    }
                    .padding(.trailing, Sizes.overallPadding)
                    .padding(.vertical)
                }
                
                
                Picker("", selection: $selectionEnum) {
                    
                    Image(systemName: FolderType.getfolderImageName(type: FolderTypeEnum.folder)).tag(FolderTypeEnum.folder)
                    
                    Image(systemName: FolderType.getfolderImageName(type: FolderTypeEnum.archive)).tag(FolderTypeEnum.archive)
                    
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.top, Sizes.overallPadding)
                
                
                // MARK: - List of all Folders (hierarchy)
                // another VStack
                if selectionEnum == .folder {
                    List {
                            ForEach(fastFolderWithLevelGroup.folders, id: \.self) {folderWithLevel in
                                DynamicFolderCell(
                                    folder: folderWithLevel.folder,
                                    level: folderWithLevel.level)
                                    .environmentObject(memoEditVM)
                                    .environmentObject(folderEditVM)
                                    .environmentObject(memoOrder)
                                // ADD Sub Folder
                                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                        Button {
                                            folderToAddSubFolder = folderWithLevel.folder
                                            showTextField = true
                                            textFieldType = .newSubFolder
                                        } label: {
                                            ChangeableImage(imageSystemName: "folder.badge.plus")
                                        }
                                        .tint(.blue)
                                    }
                                // Change Folder Name
                                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                        Button {
                                            showTextField = true
                                            textFieldType = .rename
                                            folderToBeRenamed = folderWithLevel.folder
                                        } label: {
                                            ChangeableImage(imageSystemName: "pencil")
                                        }
                                        .tint(.yellow)
                                    }
                            } // end of ForEach
                    }
                    .listStyle(InsetGroupedListStyle())
                } else {
                    List {
                            ForEach(fastFolderWithLevelGroup.archives, id: \.self) {folderWithLevel in
                                DynamicFolderCell(
                                    folder: folderWithLevel.folder,
                                    level: folderWithLevel.level)
                                    .environmentObject(memoEditVM)
                                    .environmentObject(folderEditVM)
                                    .environmentObject(memoOrder)
                                    
                                // ADD Sub Folder
                                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                        Button {
                                            folderToAddSubFolder = folderWithLevel.folder
                                            showTextField = true
                                            textFieldType = .newSubFolder
                                        } label: {
                                            ChangeableImage(imageSystemName: "folder.badge.plus")
                                        }
                                        .tint(.blue)
                                    }
                                // Change Folder Name
                                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                        Button {
                                            showTextField = true
                                            textFieldType = .rename
                                            folderToBeRenamed = folderWithLevel.folder
                                        } label: {
                                            ChangeableImage(imageSystemName: "pencil")
                                        }
                                        .tint(.yellow)
                                    }
                            } // end of ForEach
//                        } // end of Section
                    }
                    .listStyle(InsetGroupedListStyle())
                }
                
            } // end of VStack .
            // another ZStack
//            VStack {
//                Spacer()
//                HStack {
//                    Button(action: addMemo) {
                        BookmarkedFolderView(folder: fastFolderWithLevelGroup.homeFolder)
//                    BookmarkedFolderView(folder: fastFolderWithLevelGroup.folders.first!.folder)
                            .environmentObject(memoEditVM)
                            .environmentObject(folderEditVM)
                            .environmentObject(memoOrder)
//                    }
//                }
//            }
//            .ignoresSafeArea( edges: .horizontal)
            
            // ANOTHER Z STACK
//            BookmarkedFolderView(folder: fastFolderWithLevelGroup.homeFolder)
//                .environmentObject(memoEditVM)
//                .environmentObject(folderEditVM)
//                .environmentObject(memoOrder)
//                .frame(width: UIScreen.screenWidth,height: UIScreen.screenHeight)
//                    .offset(y: UIScreen.screenHeight - 160)
            
//            PlusImage()
            
            
//                .offset(y: 500)
//                .offset(y: -130)
//                    .padding(.bottom, 100)
            
            // MARK: - 여기에 메모 관련된 것을 만들면, FolderView 에서 작동을 안함.. 왜 그럴까 ??

//            NavigationLink(
//                destination:
//                    MemoView(
//                    memo: Memo(title: "", contents: "", context: context),
//                    parent: fastFolderWithLevelGroup.homeFolder,
//                    isNewMemo: true
//                    ),
//                isActive: $isAddingMemo) {}

            
            
            // MARK: - rename is not currently working .
            PrettyTextFieldAlert(
                type: textFieldType ?? .rename,
                isPresented: $showTextField,
                text: $newFolderName,
                focusState: _textFieldFocus) { newName in
                    // MARK: - submit Actions
                    switch textFieldType! {
                        
                    case .newTopFolder:
                        let _ = Folder(title: newName, context: context)
                        
                    case .newSubFolder:
                        let newSubFolder = Folder(title: newName, context: context)
                        if let validSubFolder = folderToAddSubFolder {
                            validSubFolder.add(subfolder: newSubFolder)
                        }
                        
                    case .rename:
                        if folderToBeRenamed != nil {
                            folderToBeRenamed!.title = newName
                            folderToBeRenamed = nil
                            context.saveCoreData()
                        }
                    }
                    
                    context.saveCoreData()
                    Folder.updateTopFolders(context: context)
                    
                    newFolderName = ""
                    textFieldType = nil
                    showTextField = false
                } cancelAction: {
                    newFolderName = ""
                    textFieldType = nil
                    showTextField = false
                }
        } // end of ZStack
        
        
        
        .fullScreenCover(isPresented: $folderEditVM.shouldShowSelectingView,  content: {
            NavigationView {
                SelectingFolderView(fastFolderWithLevelGroup: fastFolderWithLevelGroup, isFullScreen: true)
                .environmentObject(folderEditVM)
                .environmentObject(memoEditVM)
            }
        })
        .navigationBarHidden(true)
    }
}


