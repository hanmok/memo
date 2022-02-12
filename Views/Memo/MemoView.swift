//
//  MemoView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/21.
//

import SwiftUI
import Combine
import CoreData

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
//    @State var isBookMarkedTemp: Bool = false
     @State var isBookMarkedTemp: Bool?

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
    
    
    init(memo: Memo, parent: Folder, isNewMemo: Bool = false ) {
        self.memo = memo
        self.parent = parent
        self.initialTitle = isNewMemo ? "Enter Title" : memo.title
        self.initialContents = memo.contents
        // this line make error.
        //        self.colorSelected = Color(rgba: Int(memo.colorAsInt))
        self.isNewMemo = false
        self.isNewMemo = isNewMemo
        
    }
    
    // Initializer For New Memo
    // It should not be used !!!!
//    init(parent: Folder, context2: NSManagedObjectContext) {
//
//        let newMemo = Memo(context: context2)
//        self.memo = newMemo
//        parent.add(memo: newMemo)
//        self.isNewMemo = true
//        self.initialTitle = "Enter Title"
//        self.initialContents = ""
//        self.parent = parent // redundant.
////        self.isBookMarkedTemp = memo.isBookMarked
////        self.isBookMarkedTemp = false
//    }
    
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
                    .focused($focusState, equals: .title)
                    .onAppear(perform: {
                        print("BookMarked!!!!!!!! : \(isBookMarkedTemp)")
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
                    .focused($editorFocusState)
                    .focused($focusState, equals: .contents)
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
                    parent.add(memo: memo) // error.. ?? ??
                    parent.modificationDate = Date()
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



struct MemoView_Previews: PreviewProvider {
    
    static var sampleMemo = Memo(title: "Sample Memo",contents: "sample contents", context: PersistenceController.preview.container.viewContext)
    
    static var sampleFolder = Folder(title: "Sample Folder", context: PersistenceController.preview.container.viewContext)
    
    static var previews: some View {
        MemoView(memo: sampleMemo, parent: sampleFolder)
            .preferredColorScheme(.dark)
    }
}
