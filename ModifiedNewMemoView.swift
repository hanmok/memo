//
//  MemoView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/21.
//

import SwiftUI
import Combine
import CoreData

struct ModifiedNewMemoView: View {
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var folderEditVM: FolderEditViewModel
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    
    @FocusState var editorFocusState: Bool
    
    @GestureState var isScrolled = false
    
    @State var contents: String = ""
    
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
            ChangeableImage(imageSystemName: "chevron.left")
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
        let scroll = DragGesture(minimumDistance: 10, coordinateSpace: .local)
            .updating($isScrolled) { _, _, _ in
                editorFocusState = false
            }
        
        return ZStack(alignment: .topLeading) {
            //            Text("Tab1View")
            VStack {
                HStack {
                    backBtn
                    Spacer()
                    
                    HStack(spacing: 15) {
                        Button(action: toggleBookMark) {
                            ChangeableImage(
                                imageSystemName: isBookMarkedTemp ? "bookmark.fill" : "bookmark",
                                width: Sizes.regularButtonSize,
                                height: Sizes.regularButtonSize)
                        }
                        
                        // PIN Button
                        Button(action: togglePinMemo) {
                            ChangeableImage(
                                imageSystemName: isPinned ? "pin.fill" : "pin",
                                width: Sizes.regularButtonSize,
                                height: Sizes.regularButtonSize)
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
                            ChangeableImage(
                                imageSystemName: "folder",
                                width: Sizes.regularButtonSize,
                                height: Sizes.regularButtonSize)
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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




//let preAttributedRange: NSRange = textView.selectedRange
//
//let attributedText = NSMutableAttributedString(string: textView.text, attributes: [.font: UIFont.preferredFont(forTextStyle: .body)])
//
//// cannot find any of \n
//
//if let firstIndex = textView.text.firstIndex(of: "\n") {
//    let distance = textView.text.distance(from: textView.text.startIndex, to: firstIndex)
//    attributedText.addAttributes([.font: UIFont.preferredFont(forTextStyle: .title1)], range: NSRange(location: 0, length: distance))
//    print("distance: \(distance)")
//}
//
//textView.attributedText = attributedText
//
//textView.selectedRange = preAttributedRange
