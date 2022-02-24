//
//  MemoView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/21.
//

import SwiftUI
import Combine
import CoreData


struct MemoView: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var folderEditVM: FolderEditViewModel
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    
    @ObservedObject var memo: Memo
    
    @FocusState var editorFocusState: Bool
    @GestureState var isScrolled = false
    
    @State var showSelectingFolderView = false
    
    @State var contents: String = ""
    
    @State var isBookMarkedTemp: Bool?
    
    @Binding var presentingView: Bool
    
    @State var showColorPalette = false
    @State var memoColor = UIColor.magenta
    @State var selectedColorIndex = 0
    
    let parent: Folder
    @State var colorPickerSelection = Color.white
    var btnBack : some View {
        Button(action: {
            self.presentingView = false
            self.presentationMode.wrappedValue.dismiss()
        }) {
            SystemImage( "chevron.left")
                .tint(Color.navBtnColor)
        }
    }
    
    init(memo: Memo, parent: Folder, presentingView: Binding<Bool>) {
        self.memo = memo
        self.parent = parent
        self._presentingView = presentingView
    }
    
    
    func saveChanges() {
        print("save changes has triggered")
        
        memo.contents = contents
        
        memo.isBookMarked = isBookMarkedTemp ?? memo.isBookMarked
        // if contents are empty, delete memo
        if memo.contents == "" {
            Memo.delete(memo)
            // save titleToShow and contentsToShow. to work with memoboxView
        } else {
            memo.saveTitleWithContentsToShow(context: context)
        }
        
        parent.title += "" //
        context.saveCoreData()
    }
    
    func togglePinMemo() {
        memo.pinned.toggle()
    }
    
    func toggleBookMark() {
        
        if isBookMarkedTemp == nil {
            isBookMarkedTemp = memo.isBookMarked ? false : true
        } else {
            isBookMarkedTemp!.toggle()
        }
    }
    
    func removeMemo() {
        Memo.delete(memo)
        context.saveCoreData()
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
//        let scroll = DragGesture(minimumDistance: 10, coordinateSpace: .local)
//            .updating($isScrolled) { _, _, _ in
//                print("is Scrolling : \(isScrolled)")
//                editorFocusState = false
//            }
        
        return ZStack(alignment: .topLeading) {
            //            Text("Tab1View")
            VStack {
                Rectangle()
                    .frame(width: UIScreen.screenWidth, height: 90)
//                    .foregroundColor(Color.pastelColors[selectedColorIndex])
//                    .foregroundColor(colorScheme.adjustMainColors())
//                    .foregroundColor(Color.mainColor)
                    .foregroundColor(colorScheme == .dark ? .black : Color.mainColor)
                Spacer()
            }
            .ignoresSafeArea(edges: .top)
            
            VStack(spacing:0) {
                HStack {
                    btnBack
                    Spacer()
                    
                    HStack(spacing: 15) {
                        

                        
//                        Button {
//                            showColorPalette = true
//                        } label: {
////                            ColorPickerView(selectedIndex: $selectedColorIndex)
//                            ColorPicker("", selection: $colorPickerSelection)
//                        }
                        
                        Button(action: toggleBookMark) {

                            SystemImage( (isBookMarkedTemp ?? memo.isBookMarked) ? "bookmark.fill" : "bookmark", size: Sizes.regularButtonSize)
                                .tint(Color.navBtnColor)
                        }
                        
                        // PIN Button
                        Button(action: togglePinMemo) {
                            SystemImage( memo.pinned ? "pin.fill" : "pin", size: Sizes.regularButtonSize)
                                .tint(Color.navBtnColor)
                        }
                        
                        // RELOCATE
                        Button {
                            showSelectingFolderView = true
                            memoEditVM.dealWhenMemoSelected(memo)
                        } label: {
                            SystemImage( "folder", size: Sizes.regularButtonSize)
                                .tint(Color.navBtnColor)
                        }
                        
                        // REMOVE
                        Button(action: removeMemo) {
                            SystemImage( "trash", size: Sizes.regularButtonSize)
                                .tint(Color.navBtnColor)
                        }
                    }
                }
                .padding(.bottom)

                TextEditor(text: $contents)
                    .font(.body)
                    .accentColor(Color.textViewTintColor)
                    .padding(.top)
                    .focused($editorFocusState)
                    .foregroundColor(Color.memoTextColor)
            }
            .padding(.top, 10)
            .padding(.horizontal, Sizes.overallPadding)
//            .gesture(scroll)
            
//            VStack {
//                HStack {
//                    Spacer()
//                    ColorPaletteView(selectedColorIndex: $selectedColorIndex, showColorPalette: $showColorPalette)
//                        .environmentObject(memoEditVM)
//                        .padding(.top, Sizes.overallPadding)
//                }
//                Spacer()
//            }
//            .offset(y: showColorPalette ? -35 : -300)
//            .animation(.spring(), value: showColorPalette)
            
        }
        .padding(.bottom)
        
        .navigationBarHidden(true)
        .onAppear(perform: {
            presentingView = true
            contents = memo.contents
            print("initial pin state: \(memo.pinned)")
            print("memoView has appeared!")
            selectedColorIndex = memo.colorIndex
        })
        
        .onDisappear(perform: {
            presentingView = false
            memo.colorIndex = selectedColorIndex
            print("memoView has disappeared!")
            saveChanges()
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
                selectionEnum: Folder.isBelongToArchive(currentfolder: parent) == true ? FolderTypeEnum.archive : FolderTypeEnum.folder
            )
                .environmentObject(folderEditVM)
                .environmentObject(memoEditVM)
        }
    }
}




struct HiddenNavigationBar: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
    }
}

//struct

extension View {
    func hiddenNavigationBarStyle() -> some View {
        modifier( HiddenNavigationBar() )
    }
}
