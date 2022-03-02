//
//  MemoView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/21.
//

import SwiftUI
import Combine
import CoreData


struct TrashMemoView: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var folderEditVM: FolderEditViewModel
    @EnvironmentObject var memoEditVM: MemoEditViewModel
//    @ObservedObject var trashbinFolder: Folder
    @EnvironmentObject var trashBinVM: TrashBinViewModel
    @ObservedObject var memo: Memo
    
//    @FocusState var editorFocusState: Bool
    
    @State var showSelectingFolderView = false
    
    @State var contents: String = ""
    
    @State var showColorPalette = false
    @State var memoColor = UIColor.magenta
    @State var selectedColorIndex = 0
    
    let parent: Folder
    @State var colorPickerSelection = Color.white
    var backBtn : some View {
        Button(action: {
//            self.presentingView = false
            self.presentationMode.wrappedValue.dismiss()
        }) {
//            SystemImage( "chevron.left")
            SystemImage("chevron.left", size: 18)
                .tint(Color.navBtnColor)
//                .background(.green)
        }
    }
    
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
    
    init(memo: Memo, parent: Folder) {
        self.memo = memo
        self.parent = parent
    }
    
    
    func saveChanges() {
        print("save changes has triggered")

    }
    
    func dismissMemoView() {
        presentationMode.wrappedValue.dismiss()
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

                
                CustomTextView1(text: $contents)
                    .disabled(true)
                    .padding(.top)
                    .foregroundColor(Color.memoTextColor)
                    .padding(.leading, Sizes.overallPadding)
            }
            .padding(.top, 10)
            
        }
        .padding(.bottom)
        
        .navigationBarHidden(true)
        .onAppear(perform: {
//            presentingView = true
            contents = memo.contents
            print("initial pin state: \(memo.pinned)")
            print("memoView has appeared!")
//            selectedColorIndex = memo.colorIndex
        })
        
        .onDisappear(perform: {
//            presentingView = false
//            memo.colorIndex = selectedColorIndex
            print("memoView has disappeared!")
//            saveChanges()
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
                selectionEnum: Folder.isBelongToArchive(currentfolder: parent) == true ? FolderTypeEnum.archive : FolderTypeEnum.folder,
                dismissAction: dismissMemoView
            )
                .environmentObject(folderEditVM)
                .environmentObject(memoEditVM)
        }
    }
}
