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
//    @ObservedObject var trashbinFolder: Folder
    @EnvironmentObject var trashBinVM: TrashBinViewModel
    @ObservedObject var memo: Memo
    
    @FocusState var editorFocusState: Bool
    
    @State var showSelectingFolderView = false
    
    @State var contents: String = ""
    
    @State var isBookMarkedTemp: Bool?
    
    @Binding var presentingView: Bool
    
    @State var showColorPalette = false
    @State var memoColor = UIColor.magenta
    @State var selectedColorIndex = 0
    
    let parent: Folder
    @State var colorPickerSelection = Color.white
    var backBtn : some View {
        Button(action: {
            self.presentingView = false
            self.presentationMode.wrappedValue.dismiss()
        }) {
//            SystemImage( "chevron.left")
            SystemImage("chevron.left", size: 18)
                .tint(Color.navBtnColor)
//                .background(.green)
        }
    }
    
//    var hasSafeBottom: Bool {
//        if #available(iOS 13.0, *),
//           UIApplication.shared.windows[0].safeAreaInsets.bottom > 0 {
////           (UIApplication.UIWindowScene.window?.safeAreaInsets.bottom)! > 0 {
//            return true
//        } else {
//            return false
//        }
//    }
    var hasSafeBottom: Bool {
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        if (window?.safeAreaInsets.bottom)! > 0 {
            print("has safeArea!")
            return true
        } else {
            print("does not have safeArea!")
            return false
        }
    }
    
    init(memo: Memo, parent: Folder, presentingView: Binding<Bool>) {
        self.memo = memo
        self.parent = parent
        self._presentingView = presentingView
//        self.trashbinFolder = trashbinFolder
    }
    
    
    func saveChanges() {
        print("save changes has triggered")
        
        if memo.contents != contents {
            memo.modificationDate = Date()
        }
        
        memo.contents = contents
        
        memo.isBookMarked = isBookMarkedTemp ?? memo.isBookMarked
        // if contents are empty, delete memo
        if memo.contents == "" {
            Memo.delete(memo)
            // save titleToShow and contentsToShow. to work with memoboxView
        } else {
            memo.saveTitleWithContentsToShow(context: context)
        }
        
        parent.title += "" //
        
        print("savedContents: \(memo.contents)")
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
        
// if it is memo in Trash Bin, delete!
        if memo.folder!.parent == nil && memo.folder!.title == FolderType.getFolderName(type: .trashbin) {
            Memo.delete(memo)
        } else {
            Memo.moveToTrashBin(memo, trashBinVM.trashBinFolder)
        }
        context.saveCoreData()
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
//        let scroll = DragGesture(minimumDistance: 10, coordinateSpace: .local)
//            .updating($isScrolled) { _, _, _ in
//                print("is Scrolling : \(isScrolled)")
////                editorFocusState = false
//
//            }
        print("has Safebottom ? \(hasSafeBottom)")
        
        return ZStack(alignment: .topLeading) {
            VStack {
                Rectangle() // 왜 좌측 끝에 약간 삐져나왔지 ?...
//                    .frame(width: UIScreen.screenWidth, height: 90)
                    .frame(width: UIScreen.screenWidth, height: hasSafeBottom ? 90 : 70)
//                    .frame(width: UIScreen.screenWidth, height: hasSafeBottom ? 5 : 30)
                // what the frame height does here ?  ?
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
                        Button(action: togglePinMemo) {
                            SystemImage( memo.pinned ? "pin.fill" : "pin", size: Sizes.regularButtonSize)
                                .tint(Color.navBtnColor)
                        }
                        
                        // RELOCATE
                        Button {
                            showSelectingFolderView = true
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

                
//                PlainTextView(text: $contents)
                CustomTextView1(text: $contents)
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
            presentingView = true
            contents = memo.contents
            print("initial pin state: \(memo.pinned)")
            print("memoView has appeared!")
//            selectedColorIndex = memo.colorIndex
        })
        
        .onDisappear(perform: {
            presentingView = false
//            memo.colorIndex = selectedColorIndex
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

//struct

extension View {
    func hiddenNavigationBarStyle() -> some View {
        modifier( HiddenNavigationBar() )
    }
}



extension UIApplication {
    
    var keyWindow: UIWindow? {
        // Get connected scenes
        return UIApplication.shared.connectedScenes
            // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
            // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
            // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
            // Finally, keep only the key window
            .first(where: \.isKeyWindow)
    }
    
}
