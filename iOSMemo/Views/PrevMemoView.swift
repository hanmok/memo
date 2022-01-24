////
////  MemoView.swift
////  DeeepMemo
////
////  Created by Mac mini on 2021/12/21.
////
//
//import SwiftUI
//import Combine
//
//
///*
// Actions
// 1. 처음 상태는 어떤 것에도 Focus 가 맞추어있지 않은 상태
// 2. Title TextField : 받아온 memo 의 title 이 검정색으로 보임. 누르면 수정 가능,
// 모두 지울 시 기존 title gray 색으로 보임. 그대로 저장시 제목은 ""
// 3. 일단, 저장될 때 title, contents 가 모두 비어있는 경우 삭제하는 것으로 설정.
// 4. 사용자가 뒤로 가지 않고 앱을 갑자기 꺼버리면.. 그땐 어떻게 저장하지 ??
// 5. 내용물이 바뀌는 어떤 지점마다 저장을 해야하나? 근데 그러다가 어느순간 title, contents 를 모두 지워버리면 바로 제거 ? ? 그러면 안되는데..
// */
//
//// error : 빈 메모가 저장됨 ;;
//
//
//// relocate msg of removed memo to the folderView.
//
//
//struct PrevMemoView: View {
//
//    @Environment(\.managedObjectContext) var context
//    @Environment(\.presentationMode) var presentationMode
//    @Environment(\.colorScheme) var colorScheme: ColorScheme
//
//    @ObservedObject var memo: Memo
//    @EnvironmentObject var nav: NavigationStateManager
//
//
//    @FocusState var editorFocusState: Bool
//    @GestureState var isScrolled = false
//
//
//    @State var isShowingMsg = false
//
//    @State var msgType: MemoMsg?
//
//    @State var title: String = ""
//
//    @State var contents: String = ""
//
//    @State private var colorSelected: Color = .white {
//        didSet {
//            memo.colorAsInt = Int64(colorSelected.asRgba)
//            saveChanges()
//        }
//    }
//
//    let parent: Folder
//    let screenSize = UIScreen.main.bounds
//
//    //    @FocusState var focusState: Field?
//
//    let initialTitle: String
//    let initialContents: String
//
//    var isNewMemo = false
//
//    var contentsPlaceholder: String {
//        if memo.contents == "" {
//            return "Contents Placeholder"
//        } else { return memo.contents }
//    }
//
//    var titlePlaceholder: String {
//        if memo.title == "" {
//            return "Title Placeholder"
//        } else {
//            return memo.title
//        }
//    }
//
//
//    init(memo: Memo, parent: Folder, isNewMemo: Bool = false) {
//        self.memo = memo
//        self.parent = parent
//        self.initialTitle = isNewMemo ? "Enter Title" : memo.title
//        self.initialContents = memo.contents
//        // this line make error.
////        self.colorSelected = Color(rgba: Int(memo.colorAsInt))
//        self.isNewMemo = isNewMemo
//    }
//
//    func saveChanges() {
//        print("save changes has triggered")
//        memo.title = title
//
//        memo.contents = contents
//
//        // if both title and contents are empty, delete memo
//        if memo.title == "" && memo.contents == "" {
//            print("memo has deleted! title: \(title), contents: \(contents)")
//            Memo.delete(memo)
//        } else { // if both title and contents are not empty
//            memo.modificationDate = Date()
//            if isNewMemo {
//
//                parent.add(memo: memo) // error.. ?? ??
//                //            parent.modificationDate = Date()
//            }
//        }
//        parent.title += ""
//
//        context.saveCoreData()
//        print("memo has saved, title: \(title)")
//        print("parent's memos: ")
//        print(parent.memos.sorted())
//    }
//
//    func togglePinMemo() {
//
//        memo.pinned.toggle()
//
//        msgType = memo.pinned ? .pinned : .unpinned
//        isShowingMsg = true
//
//        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
//            self.isShowingMsg = false
//        }
//    }
//
//    func removeMemo() {
//        // move it to "trash bin" folder
//
//        msgType = .removed // should be passed to folderView
//        isShowingMsg = true
//
//        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
//            self.isShowingMsg = false
//        }
//
//        Memo.delete(memo)
//        saveChanges()
//        presentationMode.wrappedValue.dismiss()
//    }
//
////    func copyText() {
////
////        msgType = .copied
////        isShowingMsg = true
////
////        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
////            self.isShowingMsg = false
////        }
////
////        UIPasteboard.general.string = memo.title + "\n\n" + memo.contents
////    }
//
////    func saveAsImage() {
////        msgType = .savedAsImage
////        isShowingMsg = true
////
////        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
////            self.isShowingMsg = false
////        }
////
////        //        let image = myTextField.snapshot()
////        //        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
////
////        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
////            let image = self.takeCapture()
////            self.saveInPhoto(img: image)
////        }
////    }
//
//    func relocateMemo() {
//        // show up some.. easy look Folder Map
//    }
//
//    func changeColor() { // change BackgroundColor
//
//    }
//
//
//    var body: some View {
//        let scroll = DragGesture(minimumDistance: 30, coordinateSpace: .local)
//            .updating($isScrolled) { _, _, _ in
//                editorFocusState = false
//
//            }
//
//        return ZStack {
//            //            Color(colorSelected as CGColor ?? CGColor(gray: 1, alpha: 1))
//            Color(rgba: colorSelected.asRgba)
////            Color(rgba: Int(memo.colorAsInt))
////            Color(
//                .ignoresSafeArea()
//            VStack {
//                TextField(initialTitle, text: $title)
//
//                    .font(.title2)
//                    .submitLabel(.continue)
//                //                .focused($focusState, equals: Field.title)
//                    .padding(.bottom, Sizes.largePadding)
//                    .padding(.horizontal, Sizes.overallPadding)
//                // TextField Underline
//                    .overlay {
//                        Divider()
//                            .padding(.init(top: 15 , leading: Sizes.overallPadding, bottom: 0, trailing: Sizes.overallPadding))
//                    }
//
//                // MARK: - Contents
//
////                ZStack {
////                    Color(rgba: colorSelected.asRgba)
//                TextEditor(text: $contents)
//                    .padding(.horizontal, Sizes.overallPadding)
//                                    .colorMultiply(colorSelected)
//                                    .gesture(scroll)
//                                    .focused($editorFocusState)
//
//            }
//            if isShowingMsg {
//                if let validMsg = msgType {
//                    Text(validMsg.rawValue)
//                        .frame(width: screenSize.width * 0.6, height: screenSize.height * 0.05)
//                        .background(Color(.sRGB, white: 0.5, opacity: isShowingMsg ? 1 : 0))
//                        .animation(.easeOut, value: isShowingMsg)
//                        .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
//                        .padding(.bottom, screenSize.height * 0.2)
//                }
//            }
//        }
//
//        .onAppear(perform: {
//            title = memo.title
//            contents = memo.contents
//            print("initial color: \(memo.colorAsInt)")
//            print("initial pin state: \(memo.pinned)")
//            print("PrevMemoView has appeared!")
//        })
//        // triggered after FolderView has appeared
//        .onDisappear(perform: {
//            print("PrevMemoView has disappeared!")
//            saveChanges()
//            print("data saved!")
////            let newMemo = Memo(title: "new One", contents: "", context: context)
//
//        })
//
//        .navigationBarItems(
//            trailing: HStack {
//
//                ColorPicker(selection: $colorSelected) {
//
//                }
//                // pin Button
//                Button(action: togglePinMemo) {
//                    ChangeableImage(colorScheme: _colorScheme, imageSystemName: memo.pinned ? "pin.fill" : "pin", width: Sizes.regularButtonSize, height: Sizes.regularButtonSize)
//                }
//
//                // trash Button
//
//                Button(action: removeMemo) {
//                    ChangeableImage(colorScheme: _colorScheme, imageSystemName: "trash", width: Sizes.regularButtonSize, height: Sizes.regularButtonSize)
//                }
//
//                // more Button
//
//                Menu {
//                    Button(action: copyText) {
//                        Label {
//                            Text("Copy text")
//                            // including title ? or not ?
//                        } icon: {
//                            Image(systemName: "doc.on.doc")
//                        }
//                    }
//
//                    Button(action: saveAsImage) {
//                        Label {
//                            Text("Save as Image")
//                        } icon: {
//                            Image(systemName: "camera.viewfinder")
//                        }
//                    }
//                    Button(action: relocateMemo) {
//                        Label {
//                            Text("Relocate memo")
//                        } icon: {
//                            Image(systemName: "folder")
//                        }
//                    }
//                } label: {
//                    ChangeableImage(colorScheme: _colorScheme, imageSystemName: "ellipsis", width: Sizes.regularButtonSize, height: Sizes.regularButtonSize)
//                }
//            })
//    }
//}
//
//
//struct PrevMemoView_Previews: PreviewProvider {
//
//    static var sampleMemo = Memo(title: "Sample Memo",contents: "sample contents", context: PersistenceController.preview.container.viewContext)
//
//    static var sampleFolder = Folder(title: "Sample Folder", context: PersistenceController.preview.container.viewContext)
//
//    static var previews: some View {
//        PrevMemoView(memo: sampleMemo, parent: sampleFolder)
//            .preferredColorScheme(.dark)
//    }
//}
