//
//  FolderView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/21.
//

import SwiftUI
import CoreData

struct FolderView: View {
    
    @EnvironmentObject var memoEditVM : MemoEditViewModel
    @EnvironmentObject var folderEditVM : FolderEditViewModel
    
    @State var isShowingSubFolderView = false
    @State var isAddingMemo = false
    
    @State var newSubFolderName = ""
    @State var isSpreading = true
    @State var shouldHideSubFolders = false
    
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    
    @ObservedObject var currentFolder: Folder
    
    func search() {
        
    }
    
    func editFolder() {
        
    }
    
    func toggleFavorite() {
//        currentFolder.isFavorite.toggle()
    }
    
    func showSubFolderView() {
        isShowingSubFolderView = true
    }
    
    func addMemo() {
//        memoEditVM.shouldAddMemo = true
        isAddingMemo = true
    }
    
    var body: some View {
        ZStack {
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    if currentFolder.parent != nil {
                        HierarchyLabelView(currentFolder: currentFolder)
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .padding(.leading, Sizes.overallPadding)
                    }
                    ZStack {
                        if !currentFolder.memos.isEmpty {
                            
//                            MemoList(
//                                pinViewModel: PinViewModel(
//                                    memos: currentFolder.memos)
//                            )
                            MemoList()
                        }
                        HStack {
                            Spacer()
                            // Button Or SubFolderView
                            ZStack(alignment: .topTrailing) {
            
                                Button(action: showSubFolderView, label: {
                                    SubFolderButtonImage()
                                })
                                .padding(.trailing, Sizes.overallPadding )
                                
                                SubFolderView(folder: currentFolder, isShowingSubFolderView: $isShowingSubFolderView)
                                    .frame(width: UIScreen.screenWidth / 3)
                                    .background(.yellow)
                                    .cornerRadius(5)
                                    .offset(x: isShowingSubFolderView ? 0 : UIScreen.screenWidth)
                                    .animation(.spring(), value: isShowingSubFolderView)
                            } // end of ZStack
                        }
                    }
                } // end of main VStack
                .environmentObject(currentFolder)
                .environmentObject(folderEditVM)
                .environmentObject(memoEditVM)
            } // end of scrollView
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    if memoEditVM.selectedMemos.count == 0 {
                        VStack(spacing: Sizes.minimalSpacing) {
                            Button(action: addMemo) {
                                PlusImage()
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: Sizes.overallPadding, trailing: Sizes.overallPadding))
                            }
                        }
                    } else {
                        MemosToolBarView()
                            .padding([.trailing], Sizes.largePadding)
                            .padding(.bottom,Sizes.overallPadding )
                    }
                } // end of HStack
            } // end of VStack
            
            // When add folder pressed
            // overlay white background when Alert show up
            //            if shouldAddSubFolder {
            if folderEditVM.shouldAddFolder {
                Color(.white)
                    .opacity(0.8)
            }
            
            // When add folder pressed
            // Present TextFieldAlert
            TextFieldAlert(
                //                isPresented: $shouldAddSubFolder,
                isPresented: $folderEditVM.shouldAddFolder,
                text: $newSubFolderName) { subfolderName in
                    currentFolder.add(
                        subfolder: Folder(title: newSubFolderName, context: context)
                    )
                    // setup initial name empty
                    newSubFolderName = ""
                    
                }
            
            NavigationLink(
                destination: MemoView(
                    memo: Memo(title: "", contents: "", context: context),
                    parent: currentFolder,
                    isNewMemo: true),
//                isActive: $memoEditVM.shouldAddMemo) {}
                isActive: $isAddingMemo) {}
            
            
        } // end of ZStack
        .frame(maxHeight: .infinity)
        
        .navigationTitle(currentFolder.title)
        
        .navigationBarItems(trailing:
                                HStack {
            // search Button
            Button(action: {
                print("currentFolder's memos: \(currentFolder.memos)")
                print("currentFolder's memo count : \(currentFolder.memos.count)")
                if let validParent = currentFolder.parent {
                    validParent.title += ""
                    print("parent's title has changed")
                }
            }, label: {
                ChangeableImage(imageSystemName: "magnifyingglass")
            })
            
            // favorite Button
            Button(action: {
                toggleFavorite()
            }, label: {
//                if currentFolder.isFavorite {
//                    Image(systemName: "star.fill")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .tint(.yellow)
//                } else {
//                    ChangeableImage(imageSystemName: "star")
//                }
            })

            Button {
                // open talk View
            } label: {
                ChangeableImage(imageSystemName: "bubble.right")
                
            }

            
        }
        )
    }
}






// Folder Name with.. a little Space
struct FolderView_Previews: PreviewProvider {
    
    static var testFolder = Folder(title: "test Folder", context: PersistenceController.preview.container.viewContext)
    
    static var previews: some View {
        
        FolderView(currentFolder: testFolder)
    }
}
//




