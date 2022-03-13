//
//  MemoView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/21.
//

import SwiftUI
import Combine
import CoreData
//import Introspect

struct NewMemoView: View {
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme

    @EnvironmentObject var folderEditVM: FolderEditViewModel
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    @EnvironmentObject var trashBinVM: TrashBinViewModel
    

    @FocusState var editorFocusState: Bool
    
    @State var hasRelocated = false
    @State var contents: String = ""
    
    @State var isBookMarkedTemp: Bool = false
    @State var isPinned: Bool = false
    @State var isShowingSelectingFolderView = false
    
    @State var memo: Memo? = nil
    
    @Binding var isPresentingNewMemo: Bool
    
    @State var msgToShow: String?
    
    func updateViewInHalfSecond() {
        var increasedSeconds = 0.0
        for _ in 0 ... 5 {
            increasedSeconds += 0.1
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + increasedSeconds) {
                self.editorFocusState = true
            }
        }
    }
    
    
//    var hasSafeBottom: Bool {
//        
//        let scenes = UIApplication.shared.connectedScenes
//        let windowScene = scenes.first as? UIWindowScene
//        let window = windowScene?.windows.first
//        if (window?.safeAreaInsets.bottom)! > 0 {
//            print("has safeArea!")
//            return true
//        } else {
//            print("does not have safeArea!")
//            return false
//        }
//    }
    
    let parent: Folder

    var backBtn : some View {
        Button(action: {
            self.isPresentingNewMemo = false
            self.presentationMode.wrappedValue.dismiss()
        }) {
            SystemImage( "chevron.left", size: 18)
                .tint(Color.navBtnColor)
        }
    }
    
    // need better code..
//    func belongToTrashFolder() -> Bool {
//        guard memo.folder != nil else { return false}
//        return memo.folder!.parent == nil && FolderType.compareName(memo.folder!.title, with: .trashbin)
//    }
    
    
    init(parent: Folder, presentingNewMemo: Binding<Bool> ) {
        self.parent = parent
            self._isPresentingNewMemo = presentingNewMemo
    }
    
    func saveChanges() {
        print("save changes has triggered")
        
        if contents == ""  {
            // none is typed -> Do nothing. Cause memo is not created yet.
            if hasRelocated {
                Memo.delete(memo!)
            }

        } else {
            if memo != nil {
                
                memo!.contents = contents
                memo!.saveTitleWithContentsToShow(context: context)
                
                if memo!.contentsToShow == "" && memo!.titleToShow == "" {
                    Memo.delete(memo!)
                    
                } else {
                    if memo!.folder == parent {
                        parent.modificationDate = Date()
                    }
                    memo!.isBookMarked = isBookMarkedTemp
                    memo!.isPinned = isPinned
                    memo!.creationDate = Date()
                    memo!.modificationDate = Date()
                    
                    context.saveCoreData()
                }
                // memo is not created yet. memo is nil.
            } else { // and contents is not empty.
                
                memo = Memo(contents: contents, context: context)
                memo!.saveTitleWithContentsToShow(context: context)
                if memo!.titleToShow == "" && memo!.contentsToShow == "" {
                    Memo.delete(memo!)
                } else {
                memo!.isBookMarked = isBookMarkedTemp
                memo!.isPinned = isPinned
                memo!.creationDate = Date()
                memo!.modificationDate = Date()
                
                parent.add(memo: memo!)
                memo!.folder = parent

                context.saveCoreData()
                parent.title += ""
                }
            }
        }
    }
    
    func togglePin() {
        isPinned.toggle()
    }

    func toggleBookMark() {
        isBookMarkedTemp.toggle()
    }
    
    func removeMemo() {
        // nothing has been saved yet.
        
        if contents == ""  {
        // none is typed -> Do nothing. Cause memo is not created yet.
        } else {
            if memo != nil {
                if memo!.folder == parent {
                    parent.modificationDate = Date()
                }

                memo!.contents = contents
                memo!.isBookMarked = isBookMarkedTemp
                memo!.isPinned = isPinned
                memo!.creationDate = Date()
                memo!.modificationDate = Date()
                
                memo!.saveTitleWithContentsToShow(context: context)
//                Memo.makeNotBelongToFolder(memo!, trashBinVM.trashBinFolder)
                Memo.moveToTrashBin(memo!, trashBinVM.trashBinFolder)
                context.saveCoreData()
                
                // memo is not created yet.
            } else {

                memo = Memo(contents: contents, context: context)
                memo!.isBookMarked = isBookMarkedTemp
                memo!.isPinned = isPinned
                memo!.creationDate = Date()
                memo!.modificationDate = Date()
                
                memo!.saveTitleWithContentsToShow(context: context)
//                Memo.makeNotBelongToFolder(memo!, trashBinVM.trashBinFolder)
                Memo.moveToTrashBin(memo!, trashBinVM.trashBinFolder)
                context.saveCoreData()
//                parent.title += ""
            }
        }
        presentationMode.wrappedValue.dismiss()
        Folder.updateTopFolders(context: context)
        // how to.. rerender a MainView ? not updated immediately.
    }
    
    var body: some View {
        
        return ZStack(alignment: .topLeading) {
            VStack {
                Rectangle()
//                    .frame(width: UIScreen.screenWidth, height: 90)
                    .frame(width: UIScreen.screenWidth, height: UIScreen.hasSafeBottom ? 90 : 70)
                    .foregroundColor(colorScheme == .dark ? .black : Color.mainColor)
                Spacer()
            }
            .ignoresSafeArea(edges: .top)
            
            VStack(spacing:0) {
                HStack {
                    backBtn
                    Spacer()
                    
                    HStack(spacing: 16) {
                        
                        
                        Button(action: toggleBookMark) {
                            SystemImage(isBookMarkedTemp ? "bookmark.fill" : "bookmark", size: Sizes.regularButtonSize)
                                .tint(Color.navBtnColor)
                        }
                        
                        // PIN Button
                        Button(action: togglePin) {
                            SystemImage(
                                isPinned ? "pin.fill" : "pin",
                                size: Sizes.regularButtonSize)
                                .tint(Color.navBtnColor)
                        }
                        
                        // RELOCATE MEMO
                        Button {
                            if !hasRelocated {
                                memo = Memo(contents: contents, context: context)

                                parent.add(memo: memo!)
                                context.saveCoreData()
                                parent.title += ""
                                
                                memoEditVM.dealWhenMemoSelected(memo!)
                                hasRelocated = true
                            } else {
                                // already been relocated.
                                memoEditVM.dealWhenMemoSelected(memo!)
                            }
                            isShowingSelectingFolderView = true
                        } label: {
                            SystemImage(
                                "folder",
                                size: Sizes.regularButtonSize)
                                .tint(Color.navBtnColor)
                        }
                        
                        // REMOVE
                        Button(action: removeMemo) {
                            SystemImage(
                                "trash",
                                size: Sizes.regularButtonSize)
                                .tint(Color.navBtnColor)
                        }
                    }
                }
                .padding(.bottom)
                .padding(.trailing, Sizes.overallPadding)
                .padding(.leading, Sizes.navBtnLeadingSpacing)
                
//                PlainTextView(text: $contents)
//                CustomTextView1(text: $contents)
                MemoTextView(text: $contents)
//                MemoTextViewTest1(text: $contents)
//                PlainTextView(text: $contents)
                    .padding(.top)
                    .focused($editorFocusState)
                    .foregroundColor(Color.memoTextColor)
                    .padding(.leading, Sizes.overallPadding)
            }
            .overlay(
                MsgView(msgToShow: $msgToShow)
                        .padding(.top, UIScreen.screenHeight / 1.5 ))
            .padding(.top, 10)
            
            
        }
//        .padding(.vertical)
        .padding(.bottom)
        .navigationBarHidden(true)
        .onAppear(perform: {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
//                /// Anything over 0.5 seems to work
//                self.editorFocusState = true
//            }
            updateViewInHalfSecond()
        })
        .onDisappear(perform: {
            print("memoView has disappeared!")
            saveChanges()
            print("data saved!")
        })
        .sheet(isPresented: $isShowingSelectingFolderView) {
            SelectingFolderView(
                fastFolderWithLevelGroup:
                    FastFolderWithLevelGroup(
                        homeFolder: Folder.fetchHomeFolder(context: context)!,
                        archiveFolder: Folder.fetchHomeFolder(context: context,
                                                              fetchingHome: false)!
                    ), selectionEnum: Folder.isBelongToArchive(currentfolder: parent) == true ? FolderTypeEnum.archive : FolderTypeEnum.folder, invalidFolderWithLevels: [], msgToShow: $msgToShow, shouldUpdateTopFolder: false
            )
                .environmentObject(folderEditVM)
                .environmentObject(memoEditVM)
        }
    }
}

