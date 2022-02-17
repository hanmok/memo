////
////  MemoView.swift
////  DeeepMemo
////
////  Created by Mac mini on 2021/12/21.
////
//
//import SwiftUI
//import Combine
//import CoreData
//
//enum Field: Hashable {
//    case title
//    case contents
//}
//
//struct MemoView: View {
//    @Environment(\.managedObjectContext) var context
//    @Environment(\.presentationMode) var presentationMode
//
//    @EnvironmentObject var folderEditVM: FolderEditViewModel
//    @EnvironmentObject var memoEditVM: MemoEditViewModel
//
//    @ObservedObject var memo: Memo
//
//    @FocusState var editorFocusState: Bool
//    @FocusState var focusState: Field?
//    @GestureState var isScrolled = false
//
//    @State var showSelectingFolderView = false
//
//    @State var title: String = ""
//    @State var contents: String = ""
//
//    @State var isBookMarkedTemp: Bool?
//
//    let parent: Folder
//
//    let initialTitle: String
//
//    var btnBack : some View {
//        Button(action: {
//            self.presentationMode.wrappedValue.dismiss()
//        }) {
//            ChangeableImage(imageSystemName: "chevron.left")
//        }
//    }
//
//    init(memo: Memo, parent: Folder) {
//        self.memo = memo
//        self.parent = parent
////        self.initialTitle = memo.title
//    }
//
//
//    func saveChanges() {
//        print("save changes has triggered")
////        memo.title = title
//
//        memo.contents = contents
//        memo.isBookMarked = isBookMarkedTemp ?? memo.isBookMarked
//        // if both title and contents are empty, delete memo
//        if memo.title == "" && memo.contents == "" {
//            print("memo has deleted! title: \(title), contents: \(contents)")
//            Memo.delete(memo)
//        } else { // if both title and contents are not empty
//            //            memo.modificationDate = Date()
//
//        }
//        parent.title += "" //
//        
//        context.saveCoreData()
//        print("memo has saved, title: \(title)")
//        print("parent's memos: ")
//
//    }
//
//    func togglePinMemo() {
//        memo.pinned.toggle()
//    }
//
//    func toggleBookMark() {
//
//        if isBookMarkedTemp == nil {
//            isBookMarkedTemp = memo.isBookMarked ? false : true
//        } else {
//            isBookMarkedTemp!.toggle()
//        }
//    }
//
//    func removeMemo() {
//        Memo.delete(memo)
//        context.saveCoreData()
//        presentationMode.wrappedValue.dismiss()
//    }
//
//    var body: some View {
//        let scroll = DragGesture(minimumDistance: 10, coordinateSpace: .local)
//            .updating($isScrolled) { _, _, _ in
//                editorFocusState = false
//            }
//
//        return VStack(spacing: 0) {
//
//            TextField(initialTitle, text: $title)
//                .font(.title2)
//                .submitLabel(.continue)
//                .disableAutocorrection(true)
//                .focused($focusState, equals: .title)
//                .padding(.bottom, Sizes.largePadding)
//                .padding(.horizontal, Sizes.overallPadding)
//                .submitLabel(.continue)
//                .onSubmit {
//                    focusState = .contents
//                }
//
//
//            // TextField Underline
//                .overlay {
//                    Divider()
////                        .padding(.init(top: 15 , leading: Sizes.overallPadding, bottom: 0, trailing: Sizes.overallPadding))
//                        .padding(.top, 15)
//                        .padding(.horizontal, Sizes.overallPadding)
//                }
//
//            // MARK: - Contents
//
//            TextEditor(text: $contents)
//                .frame(maxHeight: .infinity, alignment: .bottom)
//                .disableAutocorrection(true)
//                .padding(.horizontal, Sizes.overallPadding)
//                .focused($editorFocusState)
//                .focused($focusState, equals: .contents)
//
//        } // end of VStack
//
//        .frame(maxHeight: .infinity, alignment: .bottom)
//        .gesture(scroll)
//        // How..
//        .onAppear(perform: {
//            title = memo.title
//            contents = memo.contents
////            print("initial color: \(memo.colorAsInt)")
//            print("initial pin state: \(memo.pinned)")
//            print("memoView has appeared!")
//            print("title or memoView : \(title)")
//        })
//        // triggered after FolderView has appeared
//        .onDisappear(perform: {
//            print("memoView has disappeared!")
//            saveChanges()
//            print("data saved!")
//        })
//
//        .navigationBarItems(
//            trailing: HStack {
//
//
//
//                Button(action: toggleBookMark) {
//                    ChangeableImage(
//                        imageSystemName: (isBookMarkedTemp ?? memo.isBookMarked) ? "bookmark.fill" : "bookmark",
//                        width: Sizes.regularButtonSize,
//                        height: Sizes.regularButtonSize)
//                }
//
//                // PIN Button
//                Button(action: togglePinMemo) {
//                    ChangeableImage(
//                        imageSystemName: memo.pinned ? "pin.fill" : "pin",
//                        width: Sizes.regularButtonSize,
//                        height: Sizes.regularButtonSize)
//                }
//
//                // RELOCATE
//                Button {
//                    showSelectingFolderView = true
//                    memoEditVM.dealWhenMemoSelected(memo)
//                } label: {
//                    ChangeableImage(imageSystemName: "folder", width: Sizes.regularButtonSize, height: Sizes.regularButtonSize)
//                }
//
//                // REMOVE
//                Button(action: removeMemo) {
//                    ChangeableImage(
//                        imageSystemName: "trash",
//                        width: Sizes.regularButtonSize,
//                        height: Sizes.regularButtonSize)
//                }
//            })
//        .navigationBarBackButtonHidden(true)
//        .navigationBarItems(leading: btnBack)
//        .sheet(isPresented: $showSelectingFolderView) {
//            SelectingFolderView(
//                fastFolderWithLevelGroup:
//                    FastFolderWithLevelGroup(
//                        homeFolder: Folder.fetchHomeFolder(context: context)!,
//                        archiveFolder: Folder.fetchHomeFolder(
//                            context: context,
//                            fetchingHome: false)!
//                    ),
//                invalidFolderWithLevels: [],
//                selectionEnum: Folder.isBelongToArchive(currentfolder: parent) == true ? FolderTypeEnum.archive : FolderTypeEnum.folder
//            )
//                .environmentObject(folderEditVM)
//                .environmentObject(memoEditVM)
//        }
//    }
//}
//
//
