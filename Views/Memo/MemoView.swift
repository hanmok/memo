//
//  MemoView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/21.
//

import SwiftUI
import Combine
import CoreData


struct MemoView: View {
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    @EnvironmentObject var trashBinVM: TrashBinViewModel
    @EnvironmentObject var messageVM: MessageViewModel
    
    @ObservedObject var memo: Memo
    
    @FocusState var editorFocusState: Bool
    
    @State var isShowingSelectingFolderView = false
    
    @State var contents: String = ""
//    @State var isBookMarkedTemp: Bool?
    
    @Binding var isPresentingView: Bool
    
//    @State var msgToShow: String?
    
    let parent: Folder
    
    var calledFromMainView: Bool
    
    var backBtn : some View {
        Button(action: {
            self.isPresentingView = false
            self.presentationMode.wrappedValue.dismiss()
        }) {
            SystemImage("chevron.left", size: 18)
//                .tint(Color.navBtnColor)
                .tint(colorScheme == .dark ? .newNavForDark : .newNavForLight)
        }
    }
    
    func belongToTrashFolder() -> Bool {
        guard memo.folder != nil else { return false}
        return memo.folder!.parent == nil && FolderType.compareName(memo.folder!.title, with: .trashbin)
    }
    
    
    
    
    func saveChanges() {
        print("save changes has triggered")
        
        if memo.contents != contents {
            memo.modificationDate = Date()
        }
        
        memo.contents = contents
        
//        memo.isBookMarked = isBookMarkedTemp ?? memo.isBookMarked
        // if contents are empty, delete memo
        
        // two step confirmation for empty contents.  is it necessary ?
        
        if memo.contents == "" {
            messageVM.message = Messages.showMemosDeletedMsg(1)
            Memo.delete(memo)
            // if it has any contents, save contentsToShow and titleToShow proper String
        } else {
            memo.saveTitleWithContentsToShow(context: context)
            if memo.contentsToShow == "" && memo.titleToShow == "" {
                messageVM.message = Messages.showMemosDeletedMsg(1)
                Memo.delete(memo)
            } else {
                messageVM.message = Messages.memoSaved
            }
        }
        
        parent.title += "" //
        
        context.saveCoreData()
    }
    
    func togglePin() {
        memo.isPinned.toggle()
    }
    
    
//    func toggleBookMark() {
//
//        if isBookMarkedTemp == nil {
//            isBookMarkedTemp = memo.isBookMarked ? false : true
//        } else {
//            isBookMarkedTemp!.toggle()
//        }
//    }
    
    
    func removeMemo() {
//        messagevm
        memo.contents = contents
        
        // for valid contents,
        if memo.contents != "" {
            // if it is contained in trashBin -> delete forever.
//            if memo.folder!.parent == nil && FolderType.compareName(memo.folder!.title, with: .trashbin) {
            if belongToTrashFolder() {
                messageVM.message = Messages.showMemosDeletedMsg(1)
                Memo.delete(memo)
            } else { // else, not in trashBin -> move to trashBin
                messageVM.message = Messages.showMemoMovedToTrash(1)
//                Memo.makeNotBelongToFolder(memo, trashBinVM.trashBinFolder)
                Memo.moveToTrashBin(memo, trashBinVM.trashBinFolder)
            }
        } else { // for empty Contents,
            messageVM.message = Messages.showMemosDeletedMsg(1)
            Memo.delete(memo)
        }
        
        context.saveCoreData()
//        messageVM.message = Messages.showMemoMovedToTrash(1)
//        messageVM.message = Messages.showMemosDeletedMsg(1)
        presentationMode.wrappedValue.dismiss()
    }
    
    
    init(memo: Memo, parent: Folder, presentingView: Binding<Bool>, calledFromMainView: Bool = false) {
        self.memo = memo
        self.parent = parent
        self._isPresentingView = presentingView
        self.calledFromMainView = calledFromMainView
    }
    
    var body: some View {
        print("has Safebottom ? \(UIScreen.hasSafeBottom)")
        
        return ZStack(alignment: .topLeading) {
            
            VStack {
                Rectangle()
                    .frame(width: UIScreen.screenWidth, height: UIScreen.hasSafeBottom ? 90 : 70)
//                    .foregroundColor(colorScheme == .dark ? .black : Color.mainColor)
                    .foregroundColor(colorScheme == .dark ? .black : Color.newMemoBoxColor)
                Spacer()
            }
            .ignoresSafeArea(edges: .top)
            
            VStack(spacing:0) {
                HStack {
                    backBtn
                    Spacer()
                    
                    HStack(spacing: 16) {
                        // if it is not trashBin -> show bookmark and pin icon with the other two.
//                        if !(memo.folder!.parent == nil && FolderType.compareName(memo.folder!.title, with: .trashbin)) {
                        if !belongToTrashFolder() {
//                            Button(action: toggleBookMark) {
//
//                                SystemImage( (isBookMarkedTemp ?? memo.isBookMarked) ? "bookmark.fill" : "bookmark", size: Sizes.regularButtonSize)
//                                    .tint(Color.navBtnColor)
//                            }
                            
                            // PIN Button
                            Button(action: togglePin) {
                                SystemImage( memo.isPinned ? "pin.fill" : "pin", size: Sizes.regularButtonSize)
//                                    .tint(Color.navBtnColor)
//                                    .tint(colorScheme == .dark ? .newNavForDark : .newNavForLight)
                                    .tint(colorScheme == .dark ? .newNavForDark : .black)
                            }
                        }
                        
                        // RELOCATE
                        Button {
                            isShowingSelectingFolderView = true
                            memoEditVM.dealWhenMemoSelected(memo)
//                            focusState = false
                            editorFocusState = false
                        } label: {
                            SystemImage("folder", size: Sizes.regularButtonSize)
//                                .tint(Color.navBtnColor)
//                                .tint(colorScheme == .dark ? .newNavForDark : .newNavForLight)
                                .tint(colorScheme == .dark ? .newNavForDark : .black)
                        }
                        
                        // REMOVE
                        Button(action: removeMemo) {
                            SystemImage("trash", size: Sizes.regularButtonSize)
//                                .tint(Color.navBtnColor)
                                .tint(Color.red).opacity(0.9)
                        }
                    }
                }
                .padding(.bottom)
                .padding(.trailing, Sizes.overallPadding)
                .padding(.leading, Sizes.navBtnLeadingSpacing)
                
                
                MemoTextView(text: $contents)
                // if it is in trash Folder -> disable!
                    .disabled(belongToTrashFolder())
                //                PlainTextView(text: $contents)
                    .padding(.top)
                    .focused($editorFocusState)
                    .foregroundColor(Color.memoTextColor)
                    .padding(.leading, Sizes.overallPadding)
            }
            .padding(.top, 10)

        }
//        .overlay(
//            MsgView(msgToShow: $msgToShow)
//                    .padding(.top, UIScreen.screenHeight / 1.5 ))
//        .padding(.bottom)
        
        .navigationBarHidden(true)
        .onAppear(perform: {
            isPresentingView = true
            contents = memo.contents
            print("initial pin state: \(memo.isPinned)")
            print("memoView has appeared!")
            print("titleToShow: \(memo.titleToShow)")
            print("contentsToShow: \(memo.contentsToShow)")
        })
        
        .onDisappear(perform: {
            isPresentingView = false
            print("memoView has disappeared!")
            saveChanges()
            // Update BookmarkFolder memoList after deselecting bookmark
            // but.. it makes folder to go back for subFolder.
            // it need to be separate case.
            if calledFromMainView {
                Folder.updateTopFolders(context: context) // maybe... this one ?
            }
            print("data saved!")
        })
        
        .sheet(isPresented: $isShowingSelectingFolderView) {
            SelectingFolderView(
                fastFolderWithLevelGroup:
                    FastFolderWithLevelGroup(
                        homeFolder: Folder.fetchHomeFolder(context: context)!,
                        archiveFolder: Folder.fetchHomeFolder(
                            context: context,
                            fetchingHome: false)!
                    ),
                selectionEnum: Folder.isBelongToArchive(currentfolder: parent) == true ? FolderTypeEnum.archive : FolderTypeEnum.folder,
//                msgToShow: $msgToShow,
                invalidFolderWithLevels: [], shouldUpdateTopFolder: false,
                dismissAction: {
                    saveChanges()
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}
