//
//  MemoView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/21.
//


import SwiftUI
import Combine
import CoreData


//struct IconNames {
//
//}
//extension String {
    enum IconNames {
        static let relocateFill = "arrowshape.turn.up.right.fill"
        static let relocate = "arrowshape.turn.up.right"
    }
//}

struct MemoView: View {
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    @EnvironmentObject var trashBinVM: TrashBinViewModel
    @EnvironmentObject var messageVM: MessageViewModel
    
    @StateObject var preventingAnimationViewModel = PreventingAnimationViewModel()
    
    @ObservedObject var memo: Memo
    
    @FocusState var editorFocusState: Bool
    
    @State var isShowingSelectingFolderView = false
    
    @State var contents: String = ""
//    @State var isBookMarkedTemp: Bool?
    
    @Binding var isPresentingView: Bool
    
//    @State var msgToShow: String?
    
    var parent: Folder?
    
    var calledFromMainView: Bool
    
    var backBtn : some View {
        Button(action: {
            self.isPresentingView = false
            self.presentationMode.wrappedValue.dismiss()
        }) {
            SystemImage("chevron.left", size: 18)
                .tint(colorScheme == .dark ? .navColorForDark : .navColorForLight)
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
            }
        }
        
        if parent != nil {
            parent!.title += "" //
        }
        
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
    
    
    init(memo: Memo, parent: Folder?, presentingView: Binding<Bool>, calledFromMainView: Bool = false) {
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
                    .foregroundColor(colorScheme == .dark ? .black :.white)
//                Rectangle().frame(width: UIScreen.screenWidth, height: 1, alignment: .center)
//                    .foregroundColor(colorScheme == .dark ? Color(.sRGB, red: 0.2, green: 0.2, blue: 0.2, opacity: 1) : Color(.sRGB, red: 0.8, green: 0.8, blue: 0.8, opacity: 1))
                Spacer()
            }
            .ignoresSafeArea(edges: .top)
            
            VStack(spacing:0) {
                HStack {
                    backBtn
                    Spacer()
                    
                    HStack(spacing: 16) {
                        if !belongToTrashFolder() {
                            // PIN Button
                            Button(action: togglePin) {
                                SystemImage( memo.isPinned ? "pin.fill" : "pin", size: Sizes.regularButtonSize)
                                    .tint(colorScheme == .dark ? .navColorForDark : .black)
                            }
                        }
                        
                        // RELOCATE
                        Button {
                            isShowingSelectingFolderView = true
                            memoEditVM.dealWhenMemoSelected(memo)
//                            focusState = false
                            editorFocusState = false
                        } label: {
//                            SystemImage("folder", size: Sizes.regularButtonSize)
//                            SystemImage("arrowshape.turn.up.right.fill", size: Sizes.regularButtonSize)
                            SystemImage(IconNames.relocate, size: Sizes.regularButtonSize)
                                .tint(contents == "" ?
                                    (.gray) : (colorScheme == .dark ? .navColorForDark : .navColorForLight))
                                .animation(.spring(), value: preventingAnimationViewModel.viewAppear && contents == "")
                        }
                        
                        // REMOVE
                        Button(action: removeMemo) {
                            SystemImage("trash", size: Sizes.regularButtonSize)
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
            .padding(.top, 5)
        }
        
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
//                selectionEnum: Folder.isBelongToArchive(currentfolder: parent!) == true ? FolderTypeEnum.archive : FolderTypeEnum.folder,
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
