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
    
    @EnvironmentObject var memoEditVM : MemoEditViewModel
    @EnvironmentObject var folderEditVM : FolderEditViewModel
    @EnvironmentObject var memoOrder: MemoOrder
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var isShowingSubFolderView = false
    @State var isAddingMemo = false
    @State var shouldAddFolder = false
    
    @State var newSubFolderName = ""
    
    @State var showSelectingFolderView = false
    
    @ObservedObject var currentFolder: Folder
    
    @FocusState var addFolderFocus: Bool
    
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
                            SubFolderButtonImage() })
                            .padding(.trailing, Sizes.overallPadding )
                        
                        SubFolderView(
                            folder: currentFolder,
                            isShowingSubFolderView: $isShowingSubFolderView,
                            isAddingFolder: $shouldAddFolder)
                            
                        // offset x : trailingPadding
                            .offset(x: isShowingSubFolderView ? -10 : UIScreen.screenWidth)
                            .animation(.spring(), value: isShowingSubFolderView)
                    } // end of ZStack
                    .padding(.top, 10)
                    
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
                        MemosToolBarView(showSelectingFolderView: $showSelectingFolderView)
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
            
            NavigationLink(
                destination:
                    MemoView(
                    memo: Memo(title: "", contents: "", context: context),
                    parent: currentFolder,
                    isNewMemo: true),
                isActive: $isAddingMemo) {}
            
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
                    )
            )
                .environmentObject(folderEditVM)
                .environmentObject(memoEditVM)
        })

        .onDisappear(perform: {
            newSubFolderName = ""
            memoEditVM.selectedMemos.removeAll()
            memoEditVM.initSelectedMemos()
        })
        
        .navigationTitle(currentFolder.title)
        .navigationBarItems(trailing:
                                HStack {
            // search Button
            Button(action: {
                currentFolder.title += ""
                if let validParent = currentFolder.parent {
                    validParent.title += ""
                    print("parent's title has changed")
                }
                
                let validMemos = currentFolder.memos.sorted()
                print("name of each memos: ")
                
                for eachMemo in validMemos {
                    eachMemo.title += ""
                    
                    print(eachMemo.title)
                }
                
                print("count : \(currentFolder.memos.count)")
                
                 // does not go back
            }, label: {
                ChangeableImage(imageSystemName: "magnifyingglass")
            })
            
            
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
