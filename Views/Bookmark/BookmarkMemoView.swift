//
//  MemoView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/21.
//

import SwiftUI
import Combine
import CoreData


struct BookmarkMemoView: View {
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var memo: Memo
    
    @FocusState var editorFocusState: Bool
    @FocusState var focusState: Field?
    
    @GestureState var isScrolled = false
    
    @State var title: String = ""
    @State var contents: String = ""
    
    @State var isBookMarkedTemp: Bool?
    @Binding var presentingView: Bool
    
    
    let parent: Folder
    let screenSize = UIScreen.main.bounds
    
    let initialTitle: String
//    let initialContents: String
    
    let isNewMemo: Bool
    
    func saveChanges() {
        print("save changes has triggered")
        memo.title = title
        
        memo.contents = contents
        memo.isBookMarked = isBookMarkedTemp ?? memo.isBookMarked
        // if both title and contents are empty, delete memo
        if memo.title == "" && memo.contents == "" {
            print("memo has deleted! title: \(title), contents: \(contents)")
            Memo.delete(memo)
        } else { // if both title and contents are not empty
            //            memo.modificationDate = Date()
            
            // This block..
            if isNewMemo {
                parent.add(memo: memo) // error.. ?? ?? um...
                parent.modificationDate = Date()
            }
        }
        
        parent.title += "" //
        
        context.saveCoreData()
        print("memo has saved, title: \(title)")
        print("parent's memos: ")
        //        print(parent.memos.sorted())
    }
    
    func togglePinMemo() {
        memo.pinned.toggle()
    }
    //    toggleBookMark
    func toggleBookMark() {
        //        memo.isBookMarked.toggle()
        //         memo.isBookMarked
        // initial
        if isBookMarkedTemp == nil {
            isBookMarkedTemp = memo.isBookMarked ? false : true
        } else {
            isBookMarkedTemp!.toggle()
        }
        
        
    }
    
    func removeMemo() {
        
        Memo.delete(memo)
        //        saveChanges()
        context.saveCoreData()
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        let scroll = DragGesture(minimumDistance: 10, coordinateSpace: .local)
            .updating($isScrolled) { _, _, _ in
                editorFocusState = false
            }
        
        //        return ScrollView {
        return VStack(spacing: 0) {
            //                ScrollViewProxy
            TextField(initialTitle, text: $title)
            
                .font(.title2)
                .submitLabel(.continue)
                .disableAutocorrection(true)
                .focused($focusState, equals: .title)
                .onAppear(perform: {

                    presentingView = true
                    print("presentingView: \(presentingView)")
                    // MARK: - In case of New Memo -> FOCUS TO TITLE !
//                    if self.isNewMemo == true {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {  /// Anything over 0.5 seems to work
//                            self.focusState = .title
//                        }
//                    }
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
        .onAppear(perform: {
            title = memo.title
            contents = memo.contents
            print("initial color: \(memo.colorAsInt)")
            print("initial pin state: \(memo.pinned)")
            print("memoView has appeared!")
            print("title or memoView : \(title)")
            print("isNewMemo ? \(isNewMemo)")
        })
        
        // triggered after FolderView has appeared
        .onDisappear(perform: {
            presentingView = false

            print("memoView has disappeared!")
            saveChanges()
            print("data saved!")

        })
        .navigationBarItems(
            trailing: HStack {
                
                Button(action: toggleBookMark) {
                    ChangeableImage(
                        imageSystemName: (isBookMarkedTemp ?? memo.isBookMarked) ? "bookmark.fill" : "bookmark",
                        width: Sizes.regularButtonSize,
                        height: Sizes.regularButtonSize)
                }
                
                // pin Button
                Button(action: togglePinMemo) {
                    ChangeableImage(
                        imageSystemName: memo.pinned ? "pin.fill" : "pin",
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
    }
}
