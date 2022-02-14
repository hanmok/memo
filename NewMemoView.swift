//
//  MemoView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/21.
//

import SwiftUI
import Combine
import CoreData

struct NewMemoView: View {
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var folderEditVM: FolderEditViewModel
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    
    @FocusState var editorFocusState: Bool
    @FocusState var focusState: Field?
    
    @GestureState var isScrolled = false
    
    @State var title: String = ""
    @State var contents: String = ""
    
    @State var isBookMarkedTemp: Bool = false
    @State var isPinned: Bool = false
    @State var showSelectingFolderView = false
//    @State var indicator = false {
//        didSet {
//            if oldValue == false {
//                // does not save on disappear
//            }
//        }
//    }
    
    @State var memo: Memo? = nil
    
    let parent: Folder

    let initialTitle: String = "Enter Title"

    init(parent: Folder) {
        self.parent = parent
    }
    
    func saveChanges() {
        print("save changes has triggered")
        
        if title == "" && contents == "" {
        // none is typed -> Do nothing. Cause memo is not created yet.
        } else {
            
            if memo != nil {
                if memo!.folder == parent {
                    parent.modificationDate = Date()
                }
                memo!.title = title
                memo!.contents = contents
                memo!.isBookMarked = isBookMarkedTemp
                memo!.pinned = isPinned
                memo!.creationDate = Date()
                memo!.modificationDate = Date()
                context.saveCoreData()
                
                // memo is not created yet.
            } else {
                memo = Memo(title: title, contents: contents, context: context)
                memo!.isBookMarked = isBookMarkedTemp
                memo!.pinned = isPinned
                memo!.creationDate = Date()
                memo!.modificationDate = Date()
                parent.add(memo: memo!)
                memo!.folder = parent
                context.saveCoreData()
                parent.title += ""
            }
        }
    }
    
    func togglePinMemo() {
        isPinned.toggle()
    }

    func toggleBookMark() {
        isBookMarkedTemp.toggle()
    }
    
    func removeMemo() {
        // nothing has been saved yet.
        title = ""
        contents = ""
        
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        let scroll = DragGesture(minimumDistance: 10, coordinateSpace: .local)
            .updating($isScrolled) { _, _, _ in
                editorFocusState = false
            }
        
        return VStack(spacing: 0) {
            TextField(initialTitle, text: $title)
                .font(.title2)
                .submitLabel(.continue)
                .disableAutocorrection(true)
                .focused($focusState, equals: .title)
                .onAppear(perform: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {  /// Anything over 0.5 seems to work
                        self.focusState = .title
                    }
                })
                .padding(.bottom, Sizes.largePadding)
                .padding(.horizontal, Sizes.overallPadding)
                .onSubmit {
                    focusState = .contents
                }
            
            // TextField Underline
                .overlay {
                    Divider()
                        .padding(.init(top: 15 , leading: Sizes.overallPadding, bottom: 0, trailing: Sizes.overallPadding))
                }
            
            // MARK: - Contents
            
            TextEditor(text: $contents)
                .frame(maxHeight: .infinity, alignment: .bottom)
                .disableAutocorrection(true)
                .padding(.horizontal, Sizes.overallPadding)
                .focused($editorFocusState)
                .focused($focusState, equals: .contents)
        } // end of VStack
        
        .frame(maxHeight: .infinity, alignment: .bottom)
        .gesture(scroll)
        .onDisappear(perform: {
            print("memoView has disappeared!")
            saveChanges()
            print("data saved!")
        })
        .navigationBarItems(
            trailing: HStack {
                
                Button(action: toggleBookMark) {
                    ChangeableImage(
                        imageSystemName: isBookMarkedTemp ?  "bookmark.fill" : "bookmark",
                        width: Sizes.regularButtonSize,
                        height: Sizes.regularButtonSize)
                }
                
                // pin Button
                Button(action: togglePinMemo) {
                    ChangeableImage(
                        imageSystemName: isPinned ? "pin.fill" : "pin",
                        width: Sizes.regularButtonSize,
                        height: Sizes.regularButtonSize)
                }
                
                Button {
                    // RELOCATE MEMO
                    
                    
                    if title == "" && contents == "" {
                        print("flag1")
                    } else {
                        memo = Memo(title: title, contents: contents, context: context)
                        memo!.isBookMarked = isBookMarkedTemp
                        memo!.pinned = isPinned
                        memo!.creationDate = Date()
                        memo!.modificationDate = Date()
                        parent.add(memo: memo!)
                        memo!.folder = parent
                        context.saveCoreData()
                        parent.title += ""

                        memoEditVM.dealWhenMemoSelected(memo!)
                        print("flag2")
                    }
                    print("flag3")
                    showSelectingFolderView = true

                } label: {
                    ChangeableImage(
                        imageSystemName: "folder",
                        width: Sizes.regularButtonSize,
                        height: Sizes.regularButtonSize)
                }
                
                
                // trash Button
                
                Button(action: removeMemo) {
                    ChangeableImage(
                        imageSystemName: "trash",
                        width: Sizes.regularButtonSize,
                        height: Sizes.regularButtonSize)
                }
            })
        .sheet(isPresented: $showSelectingFolderView) {
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
        }
    }
}
