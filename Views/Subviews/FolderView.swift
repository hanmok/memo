
//
//  FolderView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/21.
//
// Customized Version

import SwiftUI
import CoreData

// Now.. it's Fine.

struct FolderView: View {
    
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var memoEditVM : MemoEditViewModel
//    @EnvironmentObject var folderEditVM : FolderEditViewModel
//    @EnvironmentObject var memoOrder: MemoOrder
    @EnvironmentObject var trashBinVM: TrashBinViewModel
    // TrashBinViewModel
    @ObservedObject var currentFolder: Folder
    
    @FocusState var addFolderFocus: Bool
    
    @State var isShowingSubFolderView = false
    @State var isAddingMemo = false
    @State var isAddingFolder = false
    
    @State var newSubFolderName = ""
    
    @State var isShowingSelectingFolderView = false
    
    @State var allMemos: [Memo] = []
        
    @State var isShowingSearchView = false
    
    @State var msgToShow: String?
    
    
    
    var backBtn : some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            SystemImage("chevron.left", size: 18)
                .tint(Color.navBtnColor)
        }
    }
    
    func toggleFavorite() {
        currentFolder.isFavorite.toggle()
        currentFolder.modificationDate = Date()
        // 업데이트가 바로 안됨. 이럴땐 어떻게 해 ?
        // this line make folder to go back.
//        Folder.updateTopFolders(context: context) // .. topFolder 가 업데이트 되서 그런거야 ?
        context.saveCoreData()
    }

    func showSubFolderView() {
        isShowingSubFolderView = true
    }
    
    func addMemo() {
        if !memoEditVM.isSelectionMode {
            isAddingMemo = true
        }
    }
    
    var body: some View {
        
        if isAddingFolder {
            DispatchQueue.main.async {
//                newSubFolderName = "\(currentFolder.title)'s \(currentFolder.subfolders.count + 1) th \(LocalizedStringStorage.folder)"
                newSubFolderName = ""
            }
        }
        
        return ZStack {
            VStack {
                    Rectangle()
                        .frame(width: UIScreen.screenWidth, height: 90)
                        .foregroundColor(colorScheme == .dark ? .black : .white)
                
                    Spacer()
                
            }.ignoresSafeArea(edges: .top)
                    
            VStack {
                    HStack {
                        backBtn
                        Spacer()
                        
                        HStack(spacing: 16) {
                            
                            // search Button
                            Button(action: {
                                isShowingSearchView = true
                            }, label: {
                                SystemImage("magnifyingglass")
                                    .tint(Color.navBtnColor)
                            })
                            
//                            MemoOrderingMenu(memoOrder: memoOrder, parentFolder: currentFolder)
                            MemoOrderingMenu(parentFolder: currentFolder)
                            // favorite Button
                            Button(action: {
                                toggleFavorite()
                            }, label: {
                                if currentFolder.isFavorite {
                                    SystemImage( "star.fill")
                                        .tint(Color.navBtnColor)
                                } else {
                                    
                                    SystemImage("star")
                                        .tint(Color.navBtnColor)
                                }
                            })
                            
                        }
                    }
                    .padding(.trailing, 10 + Sizes.overallPadding)
                    .padding(.leading, Sizes.navBtnLeadingSpacing)
                    .padding(.bottom, 7.5)
                
                
                ScrollView(.vertical) {
                    VStack(spacing: 0) {
                        
                        // navigationTitle
                        
                        HStack {
                            // NavigationTitle
                            ZStack(alignment: .topLeading) {
                                HStack {
                                    if currentFolder.title.count < 15 {
                                        Text(currentFolder.title)
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                            .lineLimit(1)
                                            .padding(.trailing, 45)
                                    } else {
                                        Text(currentFolder.title)
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .lineLimit(1)
                                            .padding(.trailing, 45)
                                    }
                                    Spacer()
                                }
                                
                                if currentFolder.parent != nil {
                                    HierarchyLabelView(currentFolder: currentFolder)
                                        .font(.caption)
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        .offset(y: 40)
                                }
                            }
                        }
                        .padding(.horizontal, Sizes.overallPadding)
                        .padding(.bottom, 8)
                        
                        ZStack {
                            if !currentFolder.memos.isEmpty {
                                MemoList()
                                    .padding(.top, 20)
                                    .ignoresSafeArea(edges: .trailing)
                            }
                        }
                    } // end of main VStack
                    .environmentObject(currentFolder)
//                    .environmentObject(folderEditVM)
//                    .environmentObject(memoEditVM)
//                    .environmentObject(memoOrder)
                    .environmentObject(trashBinVM)
                } // end of scrollView
            } // end of VStack
            .padding(.top, 12)
            
            // ANOTHER ELEMENT IN ZSTACK
            VStack {
                HStack {
                    Spacer()
                    ZStack(alignment: .topTrailing) {
                        Button(action: {
                            isShowingSubFolderView = true
                        }, label: {
                            SubFolderButtonImage()
                                .offset(x: isShowingSubFolderView ? UIScreen.screenWidth : 0)
                                .animation(.spring(), value: isShowingSubFolderView)
                        })
                            .padding(.trailing, Sizes.overallPadding )
                        
                        SubFolderView(
                            folder: currentFolder,
                            isShowingSubFolderView: $isShowingSubFolderView,
                            isAddingFolder: $isAddingFolder)
//                            .environmentObject(folderEditVM)
//                            .environmentObject(memoEditVM)
//                            .environmentObject(memoOrder)
                            .environmentObject(trashBinVM)
                        
                        // offset x : trailingPadding
                            .offset(x: isShowingSubFolderView ? -Sizes.overallPadding : UIScreen.screenWidth)
                            .animation(.spring(), value: isShowingSubFolderView)
                    } // end of ZStack
                }
                Spacer()
            }
            .padding(.top, 55)

            VStack {
                Spacer()
                ZStack {
                    HStack {
                        Spacer()
                        VStack(spacing: Sizes.minimalSpacing) {
                            
                            Button(action: addMemo) {
                                PlusImage()
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: Sizes.overallPadding, trailing: Sizes.overallPadding))
                                    .offset(x: memoEditVM.isSelectionMode ? UIScreen.screenWidth : 0)
                                    .animation(.spring(), value: memoEditVM.isSelectionMode)
                            }
                        }
                    }
                    HStack {
                        Spacer()
                        MemosToolBarView(
                            currentFolder: currentFolder,
                            showSelectingFolderView: $isShowingSelectingFolderView,
                            msgToShow: $msgToShow
                        )
                            .padding([.trailing], Sizes.overallPadding)
                            .padding(.bottom,Sizes.overallPadding )
                            .offset(x: memoEditVM.isSelectionMode ? 0 : UIScreen.screenWidth)
                            .animation(.spring(), value: memoEditVM.isSelectionMode)
                    }
                }
            } // end of VStack
            
            CustomSearchView(
                fastFolderWithLevelGroup: FastFolderWithLevelGroup(
                    homeFolder: Folder.fetchHomeFolder(context: context)!,
                    archiveFolder: Folder.fetchHomeFolder(context: context,
                                                          fetchingHome: false)!),
                currentFolder: currentFolder, showingSearchView: $isShowingSearchView)
            
                .offset(y: isShowingSearchView ? 0 : -UIScreen.screenHeight)
                .animation(.spring(response: 0.3, dampingFraction: 1, blendDuration: 0.3), value: isShowingSearchView)
            
            //  Present TextFieldAlert when add folder pressed
            PrettyTextFieldAlert(
                type: .newSubFolder,
                isPresented: $isAddingFolder,
                text: $newSubFolderName,
                focusState: _addFolderFocus,
                submitAction: { subfolderName in
                    // when adding new subfolder, navigate to mindmapView. why.. ?'
                    // because of updateTopFolder .
                    currentFolder.add(
                        subfolder: Folder(title: newSubFolderName, context: context)
                    )
                    
                    newSubFolderName = ""
                    isAddingFolder = false
                }, cancelAction: {
                    newSubFolderName = ""
                    isAddingFolder = false
                })
            
            NavigationLink(destination:
                            NewMemoView(parent: currentFolder, presentingNewMemo: .constant(false))
//                            .environmentObject(folderEditVM)
//                            .environmentObject(memoEditVM)
                            .environmentObject(trashBinVM),
                           isActive: $isAddingMemo) {}
                            
            MsgView(msgToShow: $msgToShow)
                .padding(.top, UIScreen.screenHeight / 1.5)
            
        } // end of ZStack
        .frame(maxHeight: .infinity)
        
        // fetch both home Folder and Archive Folder Separately.
        .sheet(isPresented: $isShowingSelectingFolderView,
               onDismiss: {
            
        },
               content: {
            SelectingFolderView(
                fastFolderWithLevelGroup:
                    FastFolderWithLevelGroup(
                        homeFolder: Folder.fetchHomeFolder(context: context)!,
                        archiveFolder: Folder.fetchHomeFolder(context: context,
                                                              fetchingHome: false)!
                    ), invalidFolderWithLevels: [],
                msgToShow: $msgToShow
            )
//                .environmentObject(folderEditVM)
//                .environmentObject(memoEditVM)
        })
        

        .onAppear(perform: {
            print("folderView has Appeared!")
        })
        .onDisappear(perform: {
            print("folderView has disappeared!")
            newSubFolderName = ""
//            memoEditVM.selectedMemos.removeAll()
            memoEditVM.initSelectedMemos()
        })
        .navigationBarHidden(true)
    }
}





