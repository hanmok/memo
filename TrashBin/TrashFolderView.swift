
//
//  FolderView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/21.
//

import SwiftUI
import CoreData


struct TrashFolderView: View {
    
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var memoEditVM : MemoEditViewModel
    @EnvironmentObject var trashBinVM: TrashBinViewModel
    
    @State var isShowingDeleteAlert = false
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
    
    var body: some View {
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
                        
                        MemoOrderingMenu(parentFolder: trashBinVM.trashBinFolder)
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
                                    Text(trashBinVM.trashBinFolder.title)
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .lineLimit(1)
                                        .padding(.trailing, 45)
                                    Spacer()
                                }
                            }
                        }
                        .padding(.horizontal, Sizes.overallPadding)
                        .padding(.bottom, 8)
                        
                        ZStack {
                            if !trashBinVM.trashBinFolder.memos.isEmpty {
                                FilteredMemoList(folder: trashBinVM.trashBinFolder, listType: .all)
                                    .environmentObject(trashBinVM)
                                    .padding(.top, 20)
                                    .ignoresSafeArea(edges: .trailing)
                            }
                        }
                    } // end of main VStack
                    .environmentObject(trashBinVM)
                    
                    
                } // end of scrollView
            } // end of VStack
            .padding(.top, 12)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    MemosToolBarViewForTrash(
                        currentFolder: trashBinVM.trashBinFolder,
                        isShowingSelectingFolderView: $isShowingSelectingFolderView,
                        isShowingDeleteAlert: $isShowingDeleteAlert
                    )
                        .padding([.trailing], Sizes.overallPadding)
                        .padding(.bottom,Sizes.overallPadding )
                        .offset(x: memoEditVM.isSelectionMode ? 0 : UIScreen.screenWidth)
                        .animation(.spring(), value: memoEditVM.isSelectionMode)
                }
            }
            
            MsgView(msgToShow: $msgToShow)
                .padding(.top, UIScreen.screenHeight / 1.5 )
            
            CustomSearchView(
                fastFolderWithLevelGroup: FastFolderWithLevelGroup(
                    homeFolder: Folder.fetchHomeFolder(context: context)!,
                    archiveFolder: Folder.fetchHomeFolder(context: context,
                                                          fetchingHome: false)!),
                currentFolder: trashBinVM.trashBinFolder, showingSearchView: $isShowingSearchView)
                .environmentObject(trashBinVM)
                .offset(y: isShowingSearchView ? 0 : -UIScreen.screenHeight)
                .animation(.spring(response: 0.3, dampingFraction: 1, blendDuration: 0.3), value: isShowingSearchView)
        } // end of ZStack
        .frame(maxHeight: .infinity)
        
        // fetch both home Folder and Archive Folder Separately.
        .sheet(isPresented: $isShowingSelectingFolderView,
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
        
        .alert(LocalizedStringStorage.removeAlertMsgMain, isPresented: $isShowingDeleteAlert, actions: {
            // DELETE
            Button(role: .destructive) {
                 memoEditVM.selectedMemos.forEach { Memo.delete($0)}
                msgToShow = Messages.showMemosDeletedMsg(memoEditVM.count)
                context.saveCoreData()
                memoEditVM.initSelectedMemos()

            } label: {
                Text(LocalizedStringStorage.delete)
            }
            
            Button(role: .cancel) {
                // DO NOTHING
            } label: {
                Text(LocalizedStringStorage.cancel)
            }
        }, message: {
            Text(LocalizedStringStorage.removeAlertMsgSub).foregroundColor(.red)
        })
        
        .onDisappear(perform: {
            
            memoEditVM.selectedMemos.removeAll()
            memoEditVM.initSelectedMemos()
        })
        .navigationBarHidden(true)
    }
}
