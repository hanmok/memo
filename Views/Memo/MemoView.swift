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
    
    @EnvironmentObject var folderEditVM: FolderEditViewModel
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    @EnvironmentObject var trashBinVM: TrashBinViewModel
    
    @ObservedObject var memo: Memo
    
    let parent: Folder
    
    @FocusState var editorFocusState: Bool
    
    @State var isShowingSelectingFolderView = false
    
    @State var contents: String = ""
    @State var isBookMarkedTemp: Bool?
    
    @Binding var isPresentingView: Bool
    
    var backBtn : some View {
        Button(action: {
            self.isPresentingView = false
            self.presentationMode.wrappedValue.dismiss()
        }) {
            SystemImage("chevron.left", size: 18)
                .tint(Color.navBtnColor)
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
    
    init(memo: Memo, parent: Folder, presentingView: Binding<Bool>) {
        self.memo = memo
        self.parent = parent
        self._isPresentingView = presentingView
    }
    
    
    func saveChanges() {
        print("save changes has triggered")
        
        if memo.contents != contents {
            memo.modificationDate = Date()
        }
        
        memo.contents = contents
        
        memo.isBookMarked = isBookMarkedTemp ?? memo.isBookMarked
        // if contents are empty, delete memo
        
        // two step confirmatio for empty contents.
        if memo.contents == "" {
            Memo.delete(memo)
            // save titleToShow and contentsToShow. to work with memoboxView
        } else {
            memo.saveTitleWithContentsToShow(context: context)
            if memo.contentsToShow == "" && memo.titleToShow == "" {
                Memo.delete(memo)
            }
        }
        
        parent.title += "" //
        
        print("savedContents: \(memo.contents)")
        context.saveCoreData()
    }
    
    func togglePin() {
        memo.isPinned.toggle()
    }
    
    func toggleBookMark() {
        
        if isBookMarkedTemp == nil {
            isBookMarkedTemp = memo.isBookMarked ? false : true
        } else {
            isBookMarkedTemp!.toggle()
        }
    }
    
    func removeMemo() {
//        memo.modificationDate = Date()
            Memo.moveToTrashBin(memo, trashBinVM.trashBinFolder)
        context.saveCoreData()
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        print("has Safebottom ? \(UIScreen.hasSafeBottom)")
        
        return ZStack(alignment: .topLeading) {
            VStack {
                Rectangle() // 왜 좌측 끝에 약간 삐져나왔지 ?...
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

                            SystemImage( (isBookMarkedTemp ?? memo.isBookMarked) ? "bookmark.fill" : "bookmark", size: Sizes.regularButtonSize)
                                .tint(Color.navBtnColor)
                        }
                        
                        // PIN Button
                        Button(action: togglePin) {
                            SystemImage( memo.isPinned ? "pin.fill" : "pin", size: Sizes.regularButtonSize)
                                .tint(Color.navBtnColor)
                        }
                        
                        // RELOCATE
                        Button {
                            isShowingSelectingFolderView = true
                            memoEditVM.dealWhenMemoSelected(memo)
                        } label: {
                            SystemImage("folder", size: Sizes.regularButtonSize)
                                .tint(Color.navBtnColor)
                        }
                        
                        // REMOVE
                        Button(action: removeMemo) {
                            SystemImage("trash", size: Sizes.regularButtonSize)
                                .tint(Color.navBtnColor)
                        }
                    }
                }
                .padding(.bottom)
                .padding(.trailing, Sizes.overallPadding)
                .padding(.leading, Sizes.navBtnLeadingSpacing)

                
                MemoTextView(text: $contents)
//                PlainTextView(text: $contents)
                    .padding(.top)
                    .focused($editorFocusState)
                    .foregroundColor(Color.memoTextColor)
                    .padding(.leading, Sizes.overallPadding)
            }
            .padding(.top, 10)
            
        }
        .padding(.bottom)
        
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
            Folder.updateTopFolders(context: context)
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
                selectionEnum: Folder.isBelongToArchive(currentfolder: parent) == true ? FolderTypeEnum.archive : FolderTypeEnum.folder, invalidFolderWithLevels: []
            )
                .environmentObject(folderEditVM)
                .environmentObject(memoEditVM)
        }
    }
}



