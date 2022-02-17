//
//  MemoView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/21.
//

import SwiftUI
import Combine
import CoreData


struct ModifiedMemoView: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var folderEditVM: FolderEditViewModel
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    @ObservedObject var memo: Memo
    
    @FocusState var editorFocusState: Bool
    @GestureState var isScrolled = false
    
    @State var showSelectingFolderView = false
    
    @State var contents: String = ""
    
    @State var isBookMarkedTemp: Bool?
    
    let parent: Folder
    
    var btnBack : some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            ChangeableImage(imageSystemName: "chevron.left")
        }
    }
    
    init(memo: Memo, parent: Folder) {
        self.memo = memo
        self.parent = parent
    }
    
    
    func saveChanges() {
        print("save changes has triggered")
        
        memo.contents = contents
        memo.isBookMarked = isBookMarkedTemp ?? memo.isBookMarked
        // if contents are empty, delete memo
        if memo.contents == "" {
            Memo.delete(memo)
        }

        parent.title += "" //
        context.saveCoreData()
    }
    
    func togglePinMemo() {
        memo.pinned.toggle()
    }
    
    func toggleBookMark() {
        
        if isBookMarkedTemp == nil {
            isBookMarkedTemp = memo.isBookMarked ? false : true
        } else {
            isBookMarkedTemp!.toggle()
        }
    }
    
    func removeMemo() {
        Memo.delete(memo)
        context.saveCoreData()
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        let scroll = DragGesture(minimumDistance: 10, coordinateSpace: .local)
            .updating($isScrolled) { _, _, _ in
                editorFocusState = false
            }
        
        return ZStack(alignment: .topLeading) {
            //            Text("Tab1View")
            VStack {
                HStack {
                    btnBack
                    Spacer()
                    
                    HStack(spacing: 15) {
                        Button(action: toggleBookMark) {
                            ChangeableImage(
                                imageSystemName: (isBookMarkedTemp ?? memo.isBookMarked) ? "bookmark.fill" : "bookmark",
                                width: Sizes.regularButtonSize,
                                height: Sizes.regularButtonSize)
                        }
                        
                        // PIN Button
                        Button(action: togglePinMemo) {
                            ChangeableImage(
                                imageSystemName: memo.pinned ? "pin.fill" : "pin",
                                width: Sizes.regularButtonSize,
                                height: Sizes.regularButtonSize)
                        }
                        
                        // RELOCATE
                        Button {
                            showSelectingFolderView = true
                            memoEditVM.dealWhenMemoSelected(memo)
                        } label: {
                            ChangeableImage(imageSystemName: "folder", width: Sizes.regularButtonSize, height: Sizes.regularButtonSize)
                        }
                        
                        // REMOVE
                        Button(action: removeMemo) {
                            ChangeableImage(
                                imageSystemName: "trash",
                                width: Sizes.regularButtonSize,
                                height: Sizes.regularButtonSize)
                        }
                    }
                }
                
                CustomTextView(text: $contents)
                    .padding(.top)
                    .focused($editorFocusState)
            }
            .padding(.horizontal, Sizes.overallPadding)
            .gesture(scroll)
        }
        .padding(.vertical)
        
        .navigationBarHidden(true)
        .onAppear(perform: {
            contents = memo.contents
            print("initial color: \(memo.colorAsInt)")
            print("initial pin state: \(memo.pinned)")
            print("memoView has appeared!")
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
                        archiveFolder: Folder.fetchHomeFolder(
                            context: context,
                            fetchingHome: false)!
                    ),
                invalidFolderWithLevels: [],
                selectionEnum: Folder.isBelongToArchive(currentfolder: parent) == true ? FolderTypeEnum.archive : FolderTypeEnum.folder
            )
                .environmentObject(folderEditVM)
                .environmentObject(memoEditVM)
        }
    }
}




struct HiddenNavigationBar: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
    }
}

extension View {
    func hiddenNavigationBarStyle() -> some View {
        modifier( HiddenNavigationBar() )
    }
}


