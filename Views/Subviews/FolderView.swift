//
//  FolderView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/21.
//

import SwiftUI
import CoreData

struct FolderView: View {
    
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var memoEditVM : MemoEditViewModel
    @EnvironmentObject var folderEditVM : FolderEditViewModel
    @EnvironmentObject var memoOrder: MemoOrder
    @Environment(\.colorScheme) var colorScheme
    
    @State var isShowingSubFolderView = false
    @State var isAddingMemo = false
    @State var shouldAddFolder = false
    
    @State var showDeleteAlert = false
    
    @State var newSubFolderName = ""
    
    @State var showSelectingFolderView = false
    
    @ObservedObject var currentFolder: Folder
    
    @FocusState var addFolderFocus: Bool
    
    @State var allMemos: [Memo] = []
    
    var btnBack : some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            ChangeableImage(imageSystemName: "chevron.left")
        }
    }
    
    func toggleFavorite() {
        currentFolder.isFavorite.toggle()
    }
    
    func showSubFolderView() {
        isShowingSubFolderView = true
    }
    
    func addMemo() {
        isAddingMemo = true
    }
    
    var body: some View {
        
        if shouldAddFolder {
            DispatchQueue.main.async {
                newSubFolderName = "\(currentFolder.title)'s \(currentFolder.subfolders.count + 1) th Folder"
            }
        }
        
        return ZStack {
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
                            MemoList()
                        }
                       
                    }
                } // end of main VStack
                .environmentObject(currentFolder)
                .environmentObject(folderEditVM)
                .environmentObject(memoEditVM)
                .environmentObject(memoOrder)
            } // end of scrollView
            
            VStack {
                
                HStack {
                    Spacer()
                    
                    // Button Or SubFolderView
                    ZStack(alignment: .topTrailing) {
                        Button(action: {
                            isShowingSubFolderView = true
                        }, label: {
                            SubFolderButtonImage()
                        })
                            .padding(.trailing, Sizes.overallPadding )
                        
                        SubFolderView(
                            folder: currentFolder,
                            isShowingSubFolderView: $isShowingSubFolderView,
                            isAddingFolder: $shouldAddFolder)
                            
                        // offset x : trailingPadding
                            .offset(x: isShowingSubFolderView ? -10 : UIScreen.screenWidth)
                            .animation(.spring(), value: isShowingSubFolderView)
                    } // end of ZStack
//                    .padding(.top, 10)
//                    .offset(y: -40)
                    
                }
                // ANOTHER ELEMENT IN VSTACK
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
                        MemosToolBarView(
                            showSelectingFolderView: $showSelectingFolderView,
                            showDeleteAlert: $showDeleteAlert)
                            .padding([.trailing], Sizes.largePadding)
                            .padding(.bottom,Sizes.overallPadding )
                    }
                } // end of HStack
            } // end of VStack
            
            
            // When add folder pressed
            // overlay white background when Alert show up
            if shouldAddFolder {
                Color(.white)
                    .opacity(0.8)
            }
            
//            if shouldAddFolder {
//                newSubFolderName = ""
//            }
            
            
            // instance. are they different instances ?
            
            //  Present TextFieldAlert when add folder pressed
            PrettyTextFieldAlert(
                //                placeHolderText: "Enter new folder name",
                type: .newSubFolder,
                //                isPresented: $folderEditVM.shouldAddFolder,
                isPresented: $shouldAddFolder,
                text: $newSubFolderName,
                focusState: _addFolderFocus,
                submitAction: { subfolderName in
                    // when adding new subfolder, navigate to mindmapView. why.. ?'
                    // because of updateTopFolder .
                    currentFolder.add(
                        subfolder: Folder(title: newSubFolderName, context: context)
                    )

                    newSubFolderName = ""
                    shouldAddFolder = false
                }, cancelAction: {
                    newSubFolderName = ""
                    shouldAddFolder = false
                })
            // MARK: - ERROR!!!! SOURCE
//            NavigationLink(
//                destination:
//                    MemoView(
//                    memo: Memo(title: "", contents: "", context: context),
//                    parent: currentFolder,
//                    isNewMemo: true),
//                isActive: $isAddingMemo) {}
            
            NavigationLink(destination: NewMemoView(parent: currentFolder, presentingNewMemo: .constant(false)), isActive: $isAddingMemo) {}
            .environmentObject(folderEditVM)
            .environmentObject(memoEditVM)
            
        } // end of ZStack
        .frame(maxHeight: .infinity)
        
        // fetch both home Folder and Archive Folder Separately.
        
        .sheet(isPresented: $showSelectingFolderView,
               content: {

            SelectingFolderView(
                fastFolderWithLevelGroup:
                    FastFolderWithLevelGroup(
                        homeFolder: Folder.fetchHomeFolder(context: context)!,
                        archiveFolder: Folder.fetchHomeFolder(context: context,
                                                              fetchingHome: false)!
                    ), invalidFolderWithLevels: []
            )
                .environmentObject(folderEditVM)
                .environmentObject(memoEditVM)
        })
        .alert(AlertMessages.alertDeleteMain, isPresented: $showDeleteAlert, actions: {
            // delete
            Button(role: .destructive) {
                _ = memoEditVM.selectedMemos.map { Memo.delete($0)}
                
                context.saveCoreData()
                memoEditVM.initSelectedMemos()
            } label: {
                Text(AlertMessages.deleteConfirm)
            }
            
            Button(role: .cancel) {
                // DO NOTHING
            } label: {
                Text(AlertMessages.cancel)
            }
        }, message: {
            Text(AlertMessages.alertDeleteSub).foregroundColor(.red)
        })

        .onDisappear(perform: {
            newSubFolderName = ""
            memoEditVM.selectedMemos.removeAll()
            memoEditVM.initSelectedMemos()
        })
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
        
        .navigationTitle(currentFolder.title)
        .navigationBarItems(trailing:
                                HStack {
            // search Button
            Button(action: {
                
                // This Line makes memos . Why ?
                currentFolder.title += "" // 이거 할 때마다 두개씩 memo 가 생김. 왜 ??
                
                if let validParent = currentFolder.parent {
                    validParent.title += ""
                    print("parent's title has changed")
                }
                
                let validMemos = currentFolder.memos.sorted()
                print("name of each memos: ")
                print("number of memos contained: \(validMemos.count)")
                
//                for eachMemo in validMemos {
//                    eachMemo.title += ""
//
//                    print(eachMemo.title)
//                }
                _ = validMemos.map { $0.title += "" }
                
                print("count : \(currentFolder.memos.count)")
                
                 // does not go back
            }, label: {
                ChangeableImage(imageSystemName: "magnifyingglass")
            })
            // MARK: - FOR TESTING !!
//            Button {
////                            print(Memo.fetchAllmemos(context: context))
//                allMemos = Memo.fetchAllmemos(context: context)
//                print("num of memos:  \(allMemos.count)")
//                print("num of memos that has no parent: \(allMemos.filter { $0.folder == nil}.count)")
//
//            } label: {
//                ChangeableImage(imageSystemName: "folder")
//            }
            
            
            // favorite Button
            Button(action: {
                toggleFavorite()
            }, label: {
                if currentFolder.isFavorite {
                    Image(systemName: "star.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .tint(.yellow)
                } else {
                    Image(systemName: "star")
                        .resizable()
                        .aspectRatio( contentMode: .fit)
                        .tint(colorScheme.adjustBlackAndWhite())
                }
            })
            MemoOrderingMenu(memoOrder: memoOrder, parentFolder: currentFolder)
        })
    }

}
