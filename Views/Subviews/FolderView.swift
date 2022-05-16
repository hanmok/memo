
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
    @EnvironmentObject var messageVM: MessageViewModel
    @ObservedObject var currentFolder: Folder
    @State var shouldNavigate = false
    @State var subfolderToNavigate: Folder? = nil { willSet {
        shouldNavigate = true
//        targetFolder = newValue
    }}
    
    @FocusState var addFolderFocus: Bool
    
//    @State var targetFolder: Folder?
    @State var isShowingSubFolderView = false
    @State var isAddingMemo = false
    @State var isAddingFolder = false
    
    @State var newSubFolderName = ""
    
    @State var isShowingSelectingFolderView = false
    
    @State var isShowingSearchView = false
    
    var backBtn : some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            SystemImage("chevron.left", size: 18)
                .tint(colorScheme == .dark ? .navColorForDark : .navColorForLight)
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
            
//            Color(.newBGForDark)
            Color(colorScheme == .dark ? .newBGForDark : .white)
                .ignoresSafeArea()
            
            VStack {
                Rectangle()
                    .frame(width: UIScreen.screenWidth, height: 90)
//                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .foregroundColor(colorScheme == .dark ? .newBGforDark : .white)
                Spacer()
                
            }.ignoresSafeArea(edges: .all)
            
            VStack(spacing: 0) {
                HStack {
                    backBtn
                    Spacer()
                    
                    HStack(spacing: 16) {
                        
                        // search Button
                        Button(action: {
                            isShowingSearchView = true
                        }, label: {
                            SystemImage("magnifyingglass")
                                .tint(colorScheme == .dark ? .navColorForDark : .navColorForLight)
                        })
                        
                        MemoOrderingMenu(parentFolder: currentFolder)
                        
                        FolderMenu(
                            isAddingFolder: $isAddingFolder,
                            shouldNavigate: $shouldNavigate,
                            subfolderToNavigate: $subfolderToNavigate, subFolders: Folder.getSortedSubFolders(folder: currentFolder))
                    }
                }
//                .padding(.trailing, 10 + Sizes.overallPadding)
                .padding(.trailing, Sizes.overallPadding)
//                .padding(.leading, Sizes.navBtnLeadingSpacing)
                .padding(.leading, Sizes.navBtnLeadingSpacing + 5.0)
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
                                    HierarchyLabelView(currentFolder: currentFolder, inFolder: true)
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
                        Rectangle()
                            .frame(height: 70)
                            .foregroundColor(.clear)
                    } // end of main VStack
                    .environmentObject(currentFolder)
                    .environmentObject(trashBinVM)
                } // end of scrollView
            } // end of VStack
            .padding(.top, 5)
            
            // ANOTHER ELEMENT IN ZSTACK
            
            Group {
            
            MemoEditView(
                plusView: Button(action: addMemo) {
                    NewPlusImage()
                        .padding([.trailing, .bottom], Sizes.overallPadding)
                        .offset(x: memoEditVM.isSelectionMode ? UIScreen.screenWidth : 0)
                        .animation(.spring(), value: memoEditVM.isSelectionMode)
                },
                toolbarView: MemosToolBarView(
                    currentFolder: currentFolder,
                    showSelectingFolderView: $isShowingSelectingFolderView
                )
                .padding([.trailing, .bottom], Sizes.overallPadding)
                .offset(x: memoEditVM.isSelectionMode ? 0 : UIScreen.screenWidth)
                .animation(.spring(), value: memoEditVM.isSelectionMode)
            )
            .offset(y: isAddingFolder ? UIScreen.screenHeight : 0)
            .animation(.spring().speed(0.5), value: isAddingFolder)
            
            
            if isShowingSearchView {
                Color(colorScheme == .dark ? .black : .white)
            }
            
            CustomSearchView(
                fastFolderWithLevelGroup: FastFolderWithLevelGroup(
                    homeFolder: Folder.fetchHomeFolder(context: context)!,
                    archiveFolder: Folder.fetchHomeFolder(context: context,
                                                          fetchingHome: false)!),
                currentFolder: currentFolder, showingSearchView: $isShowingSearchView
            )
            .offset(y: isShowingSearchView ? 0 : -UIScreen.screenHeight)
            .animation(.spring(response: 0.3, dampingFraction: 1, blendDuration: 0.3), value: isShowingSearchView)
            
            if isAddingFolder {
                Color(.sRGB, white: colorScheme == .dark ? 0.25 : 0.8, opacity: 0.9)
                    .ignoresSafeArea()
            }
            
            
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
                    messageVM.message = Messages.folderHasMade
                }, cancelAction: {
                    newSubFolderName = ""
                    isAddingFolder = false
                })
            }
            
            Group {
            NavigationLink(destination:
                            NewMemoView(parent: currentFolder, presentingNewMemo: .constant(false)
                                       )
                .environmentObject(trashBinVM),
                           isActive: $isAddingMemo) {}
            
            
//            NavigationLink(destination: FolderView(currentFolder: targetFolder!), isActive: $shouldNavigate) {}
            
            if shouldNavigate {
            NavigationLink(destination:
                            FolderView(currentFolder: subfolderToNavigate!)
                            .environmentObject(trashBinVM)
                           ,
                           isActive: $shouldNavigate) {}
            }
            

            }
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
                            archiveFolder: Folder.fetchHomeFolder(context: context,fetchingHome: false)!
                        ),
                    invalidFolderWithLevels: []
                )
            })
        
        .onDisappear(perform: {
            newSubFolderName = ""
            memoEditVM.initSelectedMemos()
            print("FolderView onDisappear triggered!")
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
