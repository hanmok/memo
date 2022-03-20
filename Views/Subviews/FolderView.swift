
//
//  FolderView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/21.
//
// Customized Version

import SwiftUI
import CoreData

struct FolderView: View {
    
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var memoEditVM : MemoEditViewModel
    @EnvironmentObject var trashBinVM: TrashBinViewModel
    @ObservedObject var currentFolder: Folder
    
    @FocusState var addFolderFocus: Bool
    
    @State var isShowingSubFolderView = false
    @State var isAddingMemo = false
    @State var isAddingFolder = false
    
    @State var newSubFolderName = ""
    
    @State var isShowingSelectingFolderView = false
    
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
                newSubFolderName = ""
            }
        }
        
        var memosToShow: [Memo] {
            return Memo.sortMemos(memos: currentFolder.memos.sorted())
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
                        
                        MemoOrderingMenu(parentFolder: currentFolder)
                    }
                }
                .padding(.trailing, 10 + Sizes.overallPadding)
                .padding(.leading, Sizes.navBtnLeadingSpacing)
                .padding(.bottom, 7.5)
                
                
                ScrollView(.vertical) {
                    VStack(spacing: 0) {
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
                                //                                MemoList()
                                //                                    .padding(.top, 20)
                                //                                    .ignoresSafeArea(edges: .trailing)
                                VStack {
                                    ForEach(memosToShow, id: \.self) { memo in
                                        NavigationLink(destination:
                                                        MemoView(memo: memo, parent: memo.folder!, presentingView: .constant(false))
                                            .environmentObject(trashBinVM)
                                        ) {
                                            MemoBoxView(memo: memo)
                                                .frame(width: UIScreen.screenWidth - 20, alignment: .center)
                                        }
                                    }
                                }
                                .padding(.top, 20)
                                .ignoresSafeArea( edges: .trailing)
                                
                            }
                        }
                    } // end of main VStack
                    .environmentObject(currentFolder)
                    .environmentObject(trashBinVM)
                } // end of scrollView
            } // end of VStack
            .padding(.top, 12)
            
            // ANOTHER ELEMENT IN ZSTACK
            
            SubFolderEditView(
                subButton: Button(action: {
                    isShowingSubFolderView = true
                }, label: {
                    SubFolderButtonImage()
                        .offset(x: isShowingSubFolderView ? UIScreen.screenWidth : 0)
                        .animation(.spring(), value: isShowingSubFolderView)
                }),
                subFolderView: SubFolderView(
                    folder: currentFolder,
                    isShowingSubFolderView: $isShowingSubFolderView,
                    isAddingFolder: $isAddingFolder)
                .environmentObject(trashBinVM)
                
                // offset x : trailingPadding
                    .offset(x: isShowingSubFolderView ? -Sizes.overallPadding : UIScreen.screenWidth)
                    .animation(.spring(), value: isShowingSubFolderView)
            )
            
            .padding(.top, 55)
            
            MemoEditView(
                plusView: Button(action: addMemo) {
                    PlusImage()
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: Sizes.overallPadding, trailing: Sizes.overallPadding))
                        .offset(x: memoEditVM.isSelectionMode ? UIScreen.screenWidth : 0)
                        .animation(.spring(), value: memoEditVM.isSelectionMode)
                },
                toolbarView: MemosToolBarView(
                    currentFolder: currentFolder,
                    showSelectingFolderView: $isShowingSelectingFolderView,
                    msgToShow: $msgToShow
                )
                .padding(.trailing, Sizes.overallPadding)
                .padding(.bottom,Sizes.overallPadding )
                .offset(x: memoEditVM.isSelectionMode ? 0 : UIScreen.screenWidth)
                .animation(.spring(), value: memoEditVM.isSelectionMode)
            )
            .offset(y: isAddingFolder ? UIScreen.screenHeight : 0)
            .animation(.spring().speed(0.5), value: isAddingFolder)
            
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
                .environmentObject(trashBinVM),
                           isActive: $isAddingMemo) {}
            
            MsgView(msgToShow: $msgToShow)
                .padding(.top, UIScreen.screenHeight / 1.5)
            
        } // end of ZStack
        .frame(maxHeight: .infinity)
        
        // fetch both home Folder and Archive Folder Separately.
        .sheet(
            isPresented: $isShowingSelectingFolderView,
            onDismiss: {
                
            },
            content: {
                SelectingFolderView(
                    fastFolderWithLevelGroup:
                        FastFolderWithLevelGroup(
                            homeFolder: Folder.fetchHomeFolder(context: context)!,
                            archiveFolder: Folder.fetchHomeFolder(context: context,
                                                                  fetchingHome: false)!
                        ), msgToShow: $msgToShow, invalidFolderWithLevels: []
                )
            })
        .onDisappear(perform: {
            newSubFolderName = ""
            memoEditVM.initSelectedMemos()
        })
        .navigationBarHidden(true)
    }
}


//struct CustomNavBar<backBtn: View, rightNav: View>: View {
//
//    let backBtnView: backBtn
//    let rightNavView: rightNav
//
//    var body: some View {
////        return EmptyView()
//        return HStack {
//            backBtnView
//            Spacer()
//
//            HStack(spacing: 16) {
//
//                // search Button
//                rightNavView
//            }
//        }
//    }
//}

//protocol myViews:
