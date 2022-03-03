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
    @EnvironmentObject var trashBinVM: TrashBinViewModel
    
    @ObservedObject var memo: Memo
    
    @State var isShowingSelectingFolderView = false
    
    @State var contents: String = ""
    
    let parent: Folder
    
    var backBtn : some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            SystemImage("chevron.left", size: 18)
                .tint(Color.navBtnColor)
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
//        if memo.folder!.parent == nil && memo.folder!.title == FolderType.getFolderName(type: .trashbin) {
        
        // 이 코드는,, 여기서 필요없음.
//        if memo.folder!.parent == nil && FolderType.compareName(memo.folder!.title, with: .trashbin) {
            
            Memo.delete(memo)
//        } else {
//            Memo.moveToTrashBin(memo, trashBinVM.trashBinFolder)
//        }
        context.saveCoreData()
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        return ZStack(alignment: .topLeading) {
            VStack {
                Rectangle() // 왜 좌측 끝에 약간 삐져나왔지 ?...
                    .frame(width: UIScreen.screenWidth, height: hasSafeBottom ? 90 : 70)
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
                            isShowingSelectingFolderView = true
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

                
                MemoTextView(text: $contents)
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
            contents = memo.contents
            print("initial pin state: \(memo.isPinned)")
            print("memoView has appeared!")
        })
        
        .onDisappear(perform: {
            print("memoView has disappeared!")
            print("data saved!")
        })
        
        .sheet(isPresented: $isShowingSelectingFolderView) {
            SelectingFolderView(
                fastFolderWithLevelGroup:
                    FastFolderWithLevelGroup(
                        homeFolder: Folder.fetchHomeFolder(context: context)!,
                        archiveFolder: Folder.fetchHomeFolder(
                            context: context,
                            fetchingHome: false)!
                    ),
                selectionEnum: Folder.isBelongToArchive(currentfolder: parent) == true ? FolderTypeEnum.archive : FolderTypeEnum.folder, invalidFolderWithLevels: [],
                dismissAction: dismissMemoView
            )
                .environmentObject(folderEditVM)
                .environmentObject(memoEditVM)
        }
    }
}
