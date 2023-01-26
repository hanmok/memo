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
    @Environment(\.colorScheme) var colorScheme

    @EnvironmentObject var folderEditVM: FolderEditViewModel
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    @EnvironmentObject var trashBinVM: TrashBinViewModel
    @EnvironmentObject var messageVM: MessageViewModel

    @FocusState var editorFocusState: Bool
    
    @State var hasRelocated = false
    @State var contents: String = ""
    
    @State var isPinned: Bool = false
    @State var isShowingSelectingFolderView = false
    
    @State var memo: Memo? = nil
    
    @Binding var isPresentingNewMemo: Bool
    @State var isRemoving = false
    
    func autoSave() {
        print("autoSave called")
        
        if contents != "" {
            if let validMemo = memo {
                validMemo.contents = contents
                validMemo.saveTitleWithContentsToShow(context: context)
                
                if validMemo.contentsToShow != "" || validMemo.titleToShow != "" {
                    if validMemo.folder == parent {
                        parent.modificationDate = Date()
                    }
                    validMemo.isPinned = isPinned
                    validMemo.creationDate = Date()
                    validMemo.modificationDate = Date()
                    
                    context.saveCoreData()
                }
            } else {
                memo = Memo(contents: contents, context: context)
                 guard let memo = memo else { return }
                 memo.saveTitleWithContentsToShow(context: context)
                if memo.titleToShow != "" || memo.contentsToShow != "" {
                    memo.isPinned = isPinned
                    memo.creationDate = Date()
                    memo.modificationDate = Date()
                    
                    parent.add(memo: memo)
                    memo.folder = parent

                    context.saveCoreData()
                    parent.title += ""
                }
            }
        }
        
        
        context.saveCoreData()
    }
    
    func showKeyboardInHalfSec() {
        var increasedSeconds = 0.0
        for _ in 0 ... 5 {
            increasedSeconds += 0.1
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + increasedSeconds) {
                self.editorFocusState = true
            }
        }
    }
    
    let parent: Folder

    var backBtn : some View {
        Button(action: {
            self.isPresentingNewMemo = false
            self.presentationMode.wrappedValue.dismiss()
        }) {
            SystemImage( "chevron.left", size: 18)
                .tint(colorScheme == .dark ? .navColorForDark : .black)
        }
    }
    
    init(parent: Folder, presentingNewMemo: Binding<Bool> ) {
        self.parent = parent
            self._isPresentingNewMemo = presentingNewMemo
    }
    
    func saveChanges() {
        print("save changes has triggered")
        
        if contents == ""  {
            // none is typed -> Do nothing. Cause memo is not created yet.
            if hasRelocated {
                if let emptyMemo = memo {
                    Memo.delete(emptyMemo)
                }
            }
        } else {
            if let validMemo = memo {
                validMemo.contents = contents
                validMemo.saveTitleWithContentsToShow(context: context)
                
                if validMemo.contentsToShow == "" && validMemo.titleToShow == "" {
                    messageVM.message = Messages.showMemosDeletedMsg(1)
                    Memo.delete(validMemo)
                    
                    
                } else {
                    if validMemo.folder == parent {
                        parent.modificationDate = Date()
                    }
                    validMemo.isPinned = isPinned
                    validMemo.creationDate = Date()
                    validMemo.modificationDate = Date()
                    
                    context.saveCoreData()
                }
            } else { //  contents is not empty, memo is not created yet-> memo is nil
                
                memo = Memo(contents: contents, context: context)
                 
                 guard let memo = memo else { return }
                 
                 memo.saveTitleWithContentsToShow(context: context)
                if memo.titleToShow == "" && memo.contentsToShow == "" {
                    messageVM.message = Messages.showMemosDeletedMsg(1)
                    Memo.delete(memo)
                } else {
                    messageVM.message = LocalizedStringStorage.memoSaved
                memo.isPinned = isPinned
                memo.creationDate = Date()
                memo.modificationDate = Date()
                
                parent.add(memo: memo)
                memo.folder = parent

                context.saveCoreData()
                parent.title += ""
                }
            }
        }
    }
    
    func togglePin() {
        isPinned.toggle()
    }

//    func toggleBookMark() {
//        isBookMarkedTemp.toggle()
//    }
    
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
//                memo!.isBookMarked = isBookMarkedTemp
                memo!.isPinned = isPinned
                memo!.creationDate = Date()
                memo!.modificationDate = Date()
                
                memo!.saveTitleWithContentsToShow(context: context)
//                Memo.makeNotBelongToFolder(memo!, trashBinVM.trashBinFolder)
                messageVM.message = Messages.showMemoMovedToTrash(1)
                Memo.moveToTrashBin(memo!, trashBinVM.trashBinFolder)
                context.saveCoreData()
                
                // memo is not created yet.
            } else {

                memo = Memo(contents: contents, context: context)
                memo!.isPinned = isPinned
                memo!.creationDate = Date()
                memo!.modificationDate = Date()
                
                memo!.saveTitleWithContentsToShow(context: context)
                messageVM.message = Messages.showMemoMovedToTrash(1)
                Memo.moveToTrashBin(memo!, trashBinVM.trashBinFolder)
                context.saveCoreData()
//                parent.title += ""
            }
        }
        isRemoving = true
        presentationMode.wrappedValue.dismiss()
        Folder.updateTopFolders(context: context)
        // how to.. rerender a MainView ? not updated immediately.
    }
    
    var body: some View {
        let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
        
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
            
            VStack {
                HStack {
                    backBtn
                    Spacer()
                    
                    HStack(spacing: 15) {
                        
                        // PIN Button
                        Button(action: togglePin) {
                            SystemImage(
                                isPinned ? "pin.fill" : "pin"
//                                ,size: Sizes.regularButtonSize
                                ,size: 22
                            )
                            .tint(colorScheme == .dark ? .navColorForDark : .black)
                        }
                        .padding(.trailing, 1)
                        
                        // RELOCATE MEMO
                        // 코드 달라져야함. (로직이 달라짐)
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
                            editorFocusState = false
                            
                        } label: {
                            SystemImage(
                                .Icon.relocate
//                                ,size: Sizes.regularButtonSize
//                                , size: 20
                            )
                            .tint(contents == "" ? (.gray) : (colorScheme == .dark ? .navColorForDark : .navColorForLight))
                            .animation(.spring(), value: contents == "")
                        }
                        .disabled(contents == "")
                        
                        // REMOVE
                        Button(action: removeMemo) {
//                            SystemImage(.Icon.trash, size: Sizes.regularButtonSize)
                            SystemImage(.Icon.trash
                                        , size: 24
                            )
                                .tint(Color.red).opacity(0.9)
                        }
                    }
                }
                .padding(.bottom)
                .padding(.trailing, Sizes.overallPadding)
//                .padding(.leading, Sizes.navBtnLeadingSpacing)
                .padding(.leading, Sizes.navBtnLeadingSpacing + 5.0)
                
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
            .padding(.top, 5)
            
            
        }
        .padding(.bottom)
        .navigationBarHidden(true)
        .onAppear(perform: {
            showKeyboardInHalfSec()
        })
        .onDisappear(perform: {
            if !isRemoving {
            saveChanges()
            }
        })
        .onReceive(timer, perform: { input in
            self.autoSave()
        })
        .sheet(isPresented: $isShowingSelectingFolderView) {
            SelectingFolderView(
                fastFolderWithLevelGroup:
                    FastFolderWithLevelGroup(
                        homeFolder: Folder.fetchHomeFolder(context: context)!,
                        archiveFolder: Folder.fetchHomeFolder(context: context,
                                                              fetchingHome: false)!
                    ),
//                selectionEnum: Folder.isBelongToArchive(currentfolder: parent) == true ? FolderTypeEnum.archive : FolderTypeEnum.folder,
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
