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
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @ObservedObject var memo: Memo
//    @EnvironmentObject var nav: NavigationStateManager
    
    // Binding 이 하나 필요할 것 같은데 ??
    @FocusState var editorFocusState: Bool
    @FocusState var focusState: Field?
    
    @GestureState var isScrolled = false
//    @Binding var isAddingMemo: Bool
    
    @State var isShowingMsg = false
    
    @State var msgType: MemoMsg?
    
    @State var title: String = ""
    
    @State var contents: String = ""
    
//    @State var showFoldersToSelect = false
    
    @State private var colorSelected: Color = .white {
        didSet {
            memo.colorAsInt = Int64(colorSelected.asRgba)
            saveChanges()
        }
    }
    
    let parent: Folder
    let screenSize = UIScreen.main.bounds
    

    
    let initialTitle: String
    let initialContents: String
    
//    var isNewMemo = false
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
            memo.modificationDate = Date()
            if isNewMemo {

                parent.add(memo: memo) // error.. ?? ??
                parent.modificationDate = Date()
            }
        }
        parent.title += ""

        context.saveCoreData()
        print("memo has saved, title: \(title)")
        print("parent's memos: ")
        print(parent.memos.sorted())
    }
    
    func togglePinMemo() {
        
        memo.pinned.toggle()
        
        msgType = memo.pinned ? .pinned : .unpinned
        isShowingMsg = true
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            self.isShowingMsg = false
        }
    }
    
    func removeMemo() {
        msgType = .removed // should be passed to folderView
        isShowingMsg = true
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            self.isShowingMsg = false
        }
        
        Memo.delete(memo)
        saveChanges()
        presentationMode.wrappedValue.dismiss()
    }
    
    
//    func relocateMemo() {
//        // show up some.. easy look Folder Map
//        self.showFoldersToSelect = true
//    }
    
    
    var body: some View {
        let scroll = DragGesture(minimumDistance: 30, coordinateSpace: .local)
            .updating($isScrolled) { _, _, _ in
                editorFocusState = false
                
            }
        
        return ZStack {
            //            Color(colorSelected as CGColor ?? CGColor(gray: 1, alpha: 1))
            Color(rgba: colorSelected.asRgba)
            //            Color(rgba: Int(memo.colorAsInt))
            //            Color(
                .ignoresSafeArea()
            VStack {
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
                    .padding(.horizontal, Sizes.overallPadding)
                    .colorMultiply(colorSelected)
                    .gesture(scroll)
                    .focused($editorFocusState)
                    .focused($focusState, equals: .contents)
                    .onAppear(perform: {
                        if self.isNewMemo == false {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {  /// Anything over 0.5 seems to work
                                self.focusState = .contents
                            }
                        }
                    })
            }
            if isShowingMsg {
                if let validMsg = msgType {
                    Text(validMsg.rawValue)
                        .frame(width: screenSize.width * 0.6, height: screenSize.height * 0.05)
                        .background(Color(.sRGB, white: 0.5, opacity: isShowingMsg ? 1 : 0))
                        .animation(.easeOut, value: isShowingMsg)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                        .padding(.bottom, screenSize.height * 0.2)
                }
            }
        }

        
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
                
                // pin Button
                Button(action: togglePinMemo) {
                    ChangeableImage(colorScheme: _colorScheme, imageSystemName: memo.pinned ? "pin.fill" : "pin", width: Sizes.regularButtonSize, height: Sizes.regularButtonSize)
                }
                
                // trash Button
                
                Button(action: removeMemo) {
                    ChangeableImage(colorScheme: _colorScheme, imageSystemName: "trash", width: Sizes.regularButtonSize, height: Sizes.regularButtonSize)
                }
                
                
//                Button(action: relocateMemo) {
//                    ChangeableImage(colorScheme: _colorScheme, imageSystemName: "folder", width: Sizes.regularButtonSize, height: Sizes.regularButtonSize)
//                }
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
