
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
    @EnvironmentObject var memoEditVM : MemoEditViewModel
    @EnvironmentObject var folderEditVM : FolderEditViewModel
    @EnvironmentObject var memoOrder: MemoOrder
    @Environment(\.colorScheme) var colorScheme
//    @ObservedObject var trashBin: Folder
    @EnvironmentObject var  trashBinVM: TrashBinViewModel
    @State var isShowingSubFolderView = false
    @State var isAddingMemo = false
    @State var shouldAddFolder = false
    
//    @State var showDeleteAlert = false
    
    @State var newSubFolderName = ""
    
    @State var showSelectingFolderView = false
    
    @ObservedObject var currentFolder: Folder
    
    @FocusState var addFolderFocus: Bool
    
    @State var allMemos: [Memo] = []
    
    @State var showColorPalette = false
    @State var selectedColorIndex = -1
    
    @State var showingSearchView = false
    
    var backBtn : some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
//            SystemImage("chevron.left")
//            Image(systemName: "chevron.left")
            SystemImage("chevron.left", size: 18)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 18, height: 18)
                .tint(Color.navBtnColor)
        }
    }
    
    func toggleFavorite() {
        currentFolder.isFavorite.toggle()
        currentFolder.modificationDate = Date()
        // 업데이트가 바로 안됨. 이럴땐 어떻게 해 ?
        Folder.updateTopFolders(context: context) // 다시 잘되네..? ㅅㅂ;;  무슨..,, 이게 공학이냐....
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
        
        if shouldAddFolder {
            DispatchQueue.main.async {
                newSubFolderName = "\(currentFolder.title)'s \(currentFolder.subfolders.count + 1) th \(LocalizedStringStorage.folder)"
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
                                showingSearchView = true
                            }, label: {
                                SystemImage("magnifyingglass")
                                    .tint(Color.navBtnColor)
                            })
                            

                            
                            MemoOrderingMenu(memoOrder: memoOrder, parentFolder: currentFolder)
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
//                    .padding(.horizontal, Sizes.overallPadding)
//                    .padding(.horizontal, 10)
//                    .padding(.horizontal, 10 + Sizes.overallPadding)
                    .padding(.trailing, 10 + Sizes.overallPadding)
//                    .padding(.leading, Sizes.overallPadding)
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
//                                            .padding(.leading, 10)
                                            .padding(.trailing, 45) // 80 .. 이 맞나 ??
                                    } else {
                                        Text(currentFolder.title)
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .lineLimit(1)
//                                            .padding(.leading, 10)
                                            .padding(.trailing, 45) // 80 .. 이 맞나 ??
                                    }
                                    Spacer()
                                }
                                
                                if currentFolder.parent != nil {
                                    HierarchyLabelView(currentFolder: currentFolder)
                                        .font(.caption)
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
//                                        .padding(.leading, 10)
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
                    .environmentObject(folderEditVM)
                    .environmentObject(memoEditVM)
                    .environmentObject(memoOrder)
                    .environmentObject(trashBinVM)
                } // end of scrollView
            } // end of VStack
            .padding(.top, 12)
//            .padding(.horizontal, Sizes.overallPadding)
            
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
                            isAddingFolder: $shouldAddFolder)
                        
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
                            showSelectingFolderView: $showSelectingFolderView
//                            , showDeleteAlert: $showDeleteAlert
//                            showColorPalette: $showColorPalette
                        )
                            .padding([.trailing], Sizes.overallPadding)
                            .padding(.bottom,Sizes.overallPadding )
                            .offset(x: memoEditVM.isSelectionMode ? 0 : UIScreen.screenWidth)
                            .animation(.spring(), value: memoEditVM.isSelectionMode)
                    }
                }
            } // end of VStack
            
//            VStack {
//                Spacer()
//                HStack {
//                    Spacer()
//                    ColorPaletteView(
//                        showColorPalette: $showColorPalette)
//                        .environmentObject(memoEditVM)
//                        .offset(y: showColorPalette ? 0 : 200)
//                        .animation(.spring(), value: showColorPalette)
//                        .padding(.trailing, Sizes.overallPadding)
//                        .padding(.bottom, Sizes.overallPadding)
//                }
//            }
            
            CustomSearchView(
                fastFolderWithLevelGroup: FastFolderWithLevelGroup(
                    homeFolder: Folder.fetchHomeFolder(context: context)!,
                    archiveFolder: Folder.fetchHomeFolder(context: context,
                                                          fetchingHome: false)!),
                currentFolder: currentFolder, showingSearchView: $showingSearchView)
            
                .offset(y: showingSearchView ? 0 : -UIScreen.screenHeight)
                .animation(.spring(response: 0.3, dampingFraction: 1, blendDuration: 0.3), value: showingSearchView)
//                .padding(.horizontal, Sizes.properSpacing)
            
            
            
            
            //  Present TextFieldAlert when add folder pressed
            PrettyTextFieldAlert(
                type: .newSubFolder,
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
            
            NavigationLink(destination:
                            NewMemoView(parent: currentFolder, presentingNewMemo: .constant(false)), isActive: $isAddingMemo) {}
                            .environmentObject(folderEditVM)
                            .environmentObject(memoEditVM)
                            .environmentObject(trashBinVM)
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
        
//        .alert(LocalizedStringStorage.removeAlertMsgMain, isPresented: $showDeleteAlert, actions: {
//            // DELETE
//            Button(role: .destructive) {
////                _ = memoEditVM.selectedMemos.map { Memo.delete($0)}
//                _ = memoEditVM.selectedMemos.map {  Memo.moveToTrashBin($0, trashBin)}
//
//                context.saveCoreData()
//                memoEditVM.initSelectedMemos()
//            } label: {
//                Text(LocalizedStringStorage.delete)
//            }
//
//            Button(role: .cancel) {
//                // DO NOTHING
//            } label: {
//                Text(LocalizedStringStorage.cancel)
//            }
//        }, message: {
//            Text(LocalizedStringStorage.removeAlertMsgSub).foregroundColor(.red)
//        })
        
        .onDisappear(perform: {
            newSubFolderName = ""
            memoEditVM.selectedMemos.removeAll()
            memoEditVM.initSelectedMemos()
        })
        .navigationBarHidden(true)
    }
}





