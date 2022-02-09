//
//  MemoView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/21.
//

import SwiftUI
import Combine


enum Field: Hashable {
    case title
    case contents
}

struct MemoView: View {
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode
//    @Environment(\.colorScheme) var colorScheme: ColorScheme

    // better not being implemented.
    //    @Environment(\.scenePhase) var scenePhase
    
    @ObservedObject var memo: Memo
    
    @FocusState var editorFocusState: Bool
    @FocusState var focusState: Field?
    
    @GestureState var isScrolled = false
    
    @State var title: String = ""
    @State var contents: String = ""
    
    let parent: Folder
    let screenSize = UIScreen.main.bounds
    
    let initialTitle: String
    let initialContents: String
    
    var isNewMemo: Bool
    
    var contentsPlaceholder: String {
        if memo.contents == "" {
            return "Contents Placeholder"
        } else { return memo.contents }
    }
    
    var titlePlaceholder: String {
        if memo.title == "" {
            return "Title Placeholder"
        } else {
            return memo.title
        }
    }
    
    
    init(memo: Memo, parent: Folder, isNewMemo: Bool = false) {
        self.memo = memo
        self.parent = parent
        self.initialTitle = isNewMemo ? "Enter Title" : memo.title
        self.initialContents = memo.contents
        // this line make error.
        //        self.colorSelected = Color(rgba: Int(memo.colorAsInt))
        self.isNewMemo = isNewMemo
    }
    
    func saveChanges() {
        print("save changes has triggered")
        memo.title = title

        memo.contents = contents

        // if both title and contents are empty, delete memo
        if memo.title == "" && memo.contents == "" {
            print("memo has deleted! title: \(title), contents: \(contents)")
            Memo.delete(memo)
        } else { // if both title and contents are not empty
            //            memo.modificationDate = Date()
            if isNewMemo {

                parent.add(memo: memo) // error.. ?? ??
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
        memo.isBookMarked.toggle()
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
                    .focused($focusState, equals: .title)
                    .onAppear(perform: {
                        if self.isNewMemo == true {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {  /// Anything over 0.5 seems to work
                                self.focusState = .title
                            }
                        }
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
//                    .gesture(scroll)
//                    .background(.yellow )
                    .focused($editorFocusState)
                    .focused($focusState, equals: .contents)
//                    .frame(alignment: .leading)
                 
                 // make auto focus to the end when open the memo
//                    .onAppear(perform: {
//                        if self.isNewMemo == false {
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {  /// Anything over 0.5 seems to work
//                                self.focusState = .contents
//                            }
//                        }
//                    })
                 
                 
            } // end of VStack
             .frame(maxHeight: .infinity, alignment: .bottom)
             
//        } // end of ScrollView

        .gesture(scroll)
        // How..
        .onAppear(perform: {
            title = memo.title
            contents = memo.contents
            print("initial color: \(memo.colorAsInt)")
            print("initial pin state: \(memo.pinned)")
            print("memoView has appeared!")
            print("title or memoView : \(title)")
            print("isNewMemo ? \(isNewMemo)")
            
            if isNewMemo == true {
                self.focusState = .title
                print("isNewMemo == true, focusState = .title ")
            }
        })
        
        // triggered after FolderView has appeared
        .onDisappear(perform: {
            print("memoView has disappeared!")
            saveChanges()
            print("data saved!")
        })
        .navigationBarItems(
            trailing: HStack {
                
                Button(action: toggleBookMark) {
                    ChangeableImage(
                        imageSystemName: memo.isBookMarked ? "bookmark.fill" : "bookmark",
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



struct MemoView_Previews: PreviewProvider {
    
    static var sampleMemo = Memo(title: "Sample Memo",contents: "sample contents", context: PersistenceController.preview.container.viewContext)
    
    static var sampleFolder = Folder(title: "Sample Folder", context: PersistenceController.preview.container.viewContext)
    
    static var previews: some View {
        MemoView(memo: sampleMemo, parent: sampleFolder)
            .preferredColorScheme(.dark)
    }
}
