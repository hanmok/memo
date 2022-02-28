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
    
    @FocusState var editorFocusState: Bool
    
    @State var contents: String = ""
    
    @State var keyboardRect: CGRect = CGRect()
    
    @State var isBookMarkedTemp: Bool = false
    @State var isPinned: Bool = false
    @State var showSelectingFolderView = false
    
    @Binding var presentingNewMemo: Bool
    
    @State var memo: Memo? = nil
    

    let parent: Folder

    var backBtn : some View {
        Button(action: {
            self.presentingNewMemo = false
            self.presentationMode.wrappedValue.dismiss()
        }) {
            SystemImage( "chevron.left")
                .tint(Color.navBtnColor)
        }
    }
    
    
    init(parent: Folder, presentingNewMemo: Binding<Bool> ) {
        self.parent = parent
            self._presentingNewMemo = presentingNewMemo
    }
    
    func saveChanges() {
        print("save changes has triggered")
        
        if contents == ""  {
        // none is typed -> Do nothing. Cause memo is not created yet.
        } else {
            if memo != nil {
                if memo!.folder == parent {
                    parent.modificationDate = Date()
                }

                memo!.contents = contents
                memo!.isBookMarked = isBookMarkedTemp
                memo!.pinned = isPinned
                memo!.creationDate = Date()
                memo!.modificationDate = Date()
                
                memo!.saveTitleWithContentsToShow(context: context)
                context.saveCoreData()
                
                // memo is not created yet.
            } else {

                memo = Memo(contents: contents, context: context)
                memo!.isBookMarked = isBookMarkedTemp
                memo!.pinned = isPinned
                memo!.creationDate = Date()
                memo!.modificationDate = Date()
                
                parent.add(memo: memo!)
                memo!.folder = parent
                memo!.saveTitleWithContentsToShow(context: context)
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
        contents = ""
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
//        let scroll = DragGesture(minimumDistance: 10, coordinateSpace: .local)
//            .updating($isScrolled) { _, _, _ in
////                keyboard
////                editorFocusState = false
//                UIApplication.shared.endEditing()
//
//
//            }
        
//        return ZStack(alignment: .topLeading) {
//            VStack {
//                HStack {
//                    backBtn
//                    Spacer()
//
//                    HStack(spacing: 15) {
        
        return ZStack(alignment: .topLeading) {
            VStack {
                Rectangle()
                    .frame(width: UIScreen.screenWidth, height: 90)
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
//                            SystemImage(
//                                isBookMarkedTemp ? "bookmark.fill" : "bookmark",
//                                size: Sizes.regularButtonSize)
                            SystemImage(isBookMarkedTemp ? "bookmark.fill" : "bookmark", size: Sizes.regularButtonSize)
                                .tint(Color.navBtnColor)
                        }
                        
                        // PIN Button
                        Button(action: togglePinMemo) {
                            SystemImage(
                                isPinned ? "pin.fill" : "pin",
                                size: Sizes.regularButtonSize)
                                .tint(Color.navBtnColor)
                        }
                        
                        Button {
                            // RELOCATE MEMO
                            if contents == "" {
                                print("flag1")
                            } else {
                                memo = Memo(contents: contents, context: context)
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
                .padding(.horizontal, Sizes.overallPadding)
                
//                PlainTextView(text: $contents)
                CustomTextView1(text: $contents)
                    .padding(.top)
                    .focused($editorFocusState)
                    .foregroundColor(Color.memoTextColor)
                    .padding(.leading, Sizes.overallPadding)
            }
            .padding(.top, 10)
        }
//        .padding(.vertical)
        .padding(.bottom)
        .navigationBarHidden(true)
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                /// Anything over 0.5 seems to work
                self.editorFocusState = true
            }
        })
        .onDisappear(perform: {
            print("memoView has disappeared!")
            saveChanges()
            print("data saved!")
        })
        .sheet(isPresented: $showSelectingFolderView) {
            SelectingFolderView(
                fastFolderWithLevelGroup:
                    FastFolderWithLevelGroup(
                        homeFolder: Folder.fetchHomeFolder(context: context)!,
                        archiveFolder: Folder.fetchHomeFolder(context: context,
                                                              fetchingHome: false)!
                    ), invalidFolderWithLevels: [],
                selectionEnum: Folder.isBelongToArchive(currentfolder: parent) == true ? FolderTypeEnum.archive : FolderTypeEnum.folder
            )
                .environmentObject(folderEditVM)
                .environmentObject(memoEditVM)
        }
    }
}


//extension UIApplication {
//    func endEditing() {
//        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//
//
//    }
//
//    func startEditing() {
//        sendAction(#selector(UIResponder.becomeFirstResponder), to: nil, from: nil, for: nil)
//    }
//}


