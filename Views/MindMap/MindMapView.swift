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
    
    @Environment(\.managedObjectContext) var context
    //    @Environment(\.colorScheme) var colorScheme
    @Environment(\.colorScheme) var colorScheme
    @StateObject var memoEditVM = MemoEditViewModel()
    @StateObject var folderEditVM = FolderEditViewModel()
    @StateObject var folderOrder = FolderOrder()
    @StateObject var memoOrder = MemoOrder()
//    @StateObject var
    @EnvironmentObject var allMemoVM: AllMemosViewModel
    
    
    @State var newFolderName = ""
    
    @State var showTextField = false
    @State var textFieldType: TextFieldAlertType? = nil
    
    @State var folderToAddSubFolder : Folder? = nil
    
    //    @ObservedObject var fastFolderWithLevelGroup: FastFolderWithLevelGroup
    @ObservedObject var folderGroup: FolderGroup
    
//    @ObservedObject var bookMarkedMemos: BookMarkedMemos
//    @StateObject var
    @FocusState var textFieldFocus: Bool
    
    @State var showSelectingFolderView = false
    
    @State var folderToBeRenamed : Folder? = nil
    
    @State var shouldExpand = true
    
    var body: some View {
        
        return ZStack {
            VStack(spacing: 0) {
                // MARK: - TOP Views
                HStack {
                    Spacer()
                    HStack {
                        // sort
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
                
                // MARK: - List of all Folders (hierarchy)
                // another VStack
                
                //                List {
                //                    Section(header:
                //                                Text("Folders")
                //                    ) {
                //                        // need to fetch only Home Folder
                //                        ForEach(fastFolderWithLevelGroup.allFolders, id: \.self) {folderWithLevel in
                ////                            folderWithLevel.folder
                //                            DynamicFolderCell(
                //                                folder: folderWithLevel.folder,
                //                                level: folderWithLevel.level)
                //                                .environmentObject(memoEditVM)
                //                                .environmentObject(folderEditVM)
                //                                .environmentObject(memoOrder)
                //                            // ADD Sub Folder
                //                                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                //                                    Button {
                //                                        folderToAddSubFolder = folderWithLevel.folder
                ////                                 shouldAddSubFolder = true
                //                                        showTextField = true
                //                                        textFieldType = .newSubFolder
                //                                    } label: {
                //                                        ChangeableImage(imageSystemName: "folder.badge.plus")
                //                                    }
                //                                    .tint(.blue)
                //                                }
                //                            // Change Folder Name
                //                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                //                                    Button {
                //                                        showTextField = true
                //                                        textFieldType = .rename
                //                                        folderToBeRenamed = folderWithLevel.folder
                //                                    } label: {
                //                                        ChangeableImage(imageSystemName: "pencil")
                //                                    }
                //                                    .tint(.yellow)
                //                                }
                //                        } // end of ForEach
                //
                //                        Text("hi")
                //                    } // end of Section
                //                }
                //                .listStyle(InsetGroupedListStyle())
                
                
                
                
                
                
                
                
                
                //                List(fastFolderWithLevelGroup.allFolders.first!.folder, children: \.subfolders_) { folder in
                //                    HStack {
                //
                //                    }
                //                }
                
                
                
                
                
                
                // MARK: - VERSION 1
                //                List {
                //                    ForEach(folderGroup.realFolders) { folder in
                //                        Section(header: FolderTitleWithStar(folder: folder)) { // TopFolder, and Archive should be located here.
                //                OutlineGroup(folder.children ?? [Folder](), children: \.children) { child in
                //                                ZStack(alignment: .leading) {
                //                                NavigationLink(destination: FolderView(currentFolder: child)
                //                                                .environmentObject(memoEditVM)
                //                                                .environmentObject(folderEditVM)
                //                                                .environmentObject(memoOrder)
                //                                ) {
                //                                    EmptyView()
                //                                }.opacity(0)
                //                                    FolderTitleWithStar(folder: child)
                //                                }
                //                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                //                                    Button {
                //                                        print("nothing")
                //                                    } label: {
                //                                        ChangeableImage(imageSystemName: "trash")
                //                                    }
                //                                    .tint(.red)
                //                                }
                //                            }
                //                                         .listItemTint(.black)
                //                        }
                //                    }
                //                }
                
                
                //                // MARK: - VERSION 2
                List(folderGroup.realFolders,children: \.children ) { folder in
                    
                    RecursiveFolderCell(folder: folder)
                        .environmentObject(memoEditVM)
                        .environmentObject(folderEditVM)
                        .environmentObject(memoOrder)
                        .environmentObject(allMemoVM)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            
                            // remove !
                            Button {
                                context.saveCoreData()
                            } label: {
                                ChangeableImage(imageSystemName: "trash")
                            }
                            .tint(.red)
                            
                            // change Folder location
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            
                            // remove !
                            Button {
                                context.saveCoreData()
                            } label: {
                                ChangeableImage(imageSystemName: "pencil")
                            }
                            .tint(.red)
                            
                            // change Folder location
                        }
                } // End of List
                
                
                //                List(folderGroup.realFolders,children: \.children ) { folder in
                //                Text("Using Disclosure Group")
                
                // MARK: - VERSION 3
                //                List {
                //                    Section(header: Text("Folder")) {
                //                        ForEach(folderGroup.realFolders) { folder in
                ////                            DisclosureGroup((folder.title)) {
                //
                //
                //
                ////                            DisclosureGroup(isExpanded: $shouldExpand, content: {
                ////
                ////
                ////                                OutlineGroup(folder.children ?? [Folder](), children: \.children) { child in
                ////                                    RecursiveFolderCell(folder: child)
                ////                                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                ////
                ////                                            // remove !
                ////                                            Button {
                ////                                                context.saveCoreData()
                ////                                            } label: {
                ////                                                ChangeableImage(imageSystemName: "pencil")
                ////                                            }
                ////                                            .tint(.red)
                ////
                ////                                            // change Folder location
                ////                                        }
                ////                                }
                ////                            }, label:{ Text(folder.title)
                ////                            })
                //
                //                            DisclosureGroup {
                //                                OutlineGroup(folder.children ?? [Folder](), children: \.children) { child in
                //                                    RecursiveFolderCell(folder: child)
                //                                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                //
                //                                            // remove !
                //                                            Button {
                //                                                context.saveCoreData()
                //                                            } label: {
                //                                                ChangeableImage(imageSystemName: "pencil")
                //                                            }
                //                                            .tint(.red)
                //
                //                                            // change Folder location
                //                                        }
                //                                }
                //                            } label: {
                //                                Text(folder.title)
                //                            }
                //                            }
                //                        }
                //                    }
                
                
                // MARK: - MEMO SECTION
                
                Section(header:
                            HStack {
                    Text("BookMarked Memos")
                        .padding(.vertical, Sizes.smallSpacing)
                        .padding(.leading, Sizes.overallPadding)

                    Spacer()
                }
                ) {
                    ScrollView(.horizontal) {
                        LazyHStack(alignment: .top, spacing: Sizes.smallSpacing ) {
                            ForEach(allMemoVM.bookMarkedMemos, id: \.self) { memo in

                                NavigationLink(destination: MemoView(memo: memo, parent: memo.folder!)
// Memo 만을 위한 ViewModel 이 있으면 좋..을까?
                                ) {
//EmptyView()
                                    BookMarkedMemoBoxView(memo: memo)
//                                        .frame(width: UIScreen.screenWidth  - 2 * Sizes.overallPadding, alignment: .leading)
//                                        .frame(width: UIScreen.screenWidth, alignment: .leading)
//                                        .padding(.leading, Sizes.overallPadding)
//                                        .padding(.trailing, Sizes.smallSpacing)
                                        
                                }
                                //                            .environmentObject(memoEditVM)

                            } // end of ForEach
                            
                        } // HStack
                        .padding(.horizontal, Sizes.overallPadding)
                    }
                    .frame(height: 150)
                } // end of Section
                        
                        
                        
                        
            }
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
        
        //        .sheet(isPresented: $folderEditVM.shouldShowSelectingView, content: {
        //            SelectingFolderView(fastFolderWithLevelGroup: fastFolderWithLevelGroup)
        //                .environmentObject(folderEditVM)
        //                .environmentObject(memoEditVM)
        //        })
        .fullScreenCover(isPresented: $folderEditVM.shouldShowSelectingView,  content: {
            //            SelectingFolderView(fastFolderWithLevelGroup: fastFolderWithLevelGroup)
            SelectingFolderView(folderGroup: folderGroup)
                .environmentObject(folderEditVM)
                .environmentObject(memoEditVM)
        })
        .navigationBarHidden(true)
    }
}

// text.bubble
// bubble.right.fill
// square.split.1x2.fill
// text.badge.plus
//}


struct FolderTitleWithStar: View {
    @ObservedObject var folder: Folder
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var body: some View {
        HStack {
            Text(folder.title)
                .foregroundColor(colorScheme.adjustBlackAndWhite())
            
            if folder.isFavorite {
                Text(Image(systemName: "star.fill"))
                    .tint(.yellow) // why not working ?
            }
        }
    }
}
