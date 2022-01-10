//
//  MemoView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/21.
//

import SwiftUI

struct MemoView: View {
    
    @FocusState var focusState: Field?
    //    @Environment(\.colorScheme)
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject var memo: Memo
    
    let parent: Folder
    
    //    @Binding var memo: MemoViewModel.currentMemo
    //    @ObservedObject var memoViewModel: MemoViewModel
    
    enum Field: Hashable {
        case title
        case contents
    }
    
    @State var isPinned: Bool = false
    
    func navigateBack() {
        // save memo, and move back
        // save
        submit()
        // move back
    }
    
    func pinMemo() {
        // change it to pin.fill
        isPinned.toggle()
        // pin it ( to the very latest )
    }
    
    func removeMemo() {
        // move it to "trash bin" folder
    }
    
    func submit() {
        // save all
    }
    
    func moreActions() {
        
    }
    
    func changeColor() {
        
    }
    
    func changeBackgroundColor() {
        
    }
    func changeTitleColor() {
        
    }
    func changeContentsColor() {
        
    }
    
    func saveChanges() {
        memo.title = title
        memo.overview = overview
        memo.contents = contents
        context.saveCoreData()
    }
    
    var titlePlaceholder: String {
        if memo.title == "" {
            return "Title Placeholder"
        } else { return memo.title }
    }
    
    var contentsPlaceholder: String {
        if memo.contents == "" {
            return "Contents Placeholder"
        } else { return memo.contents }
    }
    
    @State var title: String = ""
    //    @Binding var myTitle: String
    //    @State var myTitle: String = "" // 이거.. Binding 으로 와야함..@ObservedObject
    // MVVM
    //    @State var myText: String = "initial text editor"
    @State var contents: String = ""
    @State var overview: String = ""
    //    @Binding var myText: String
    
    //    @Binding var memo: Memo
    
    var body: some View {
        VStack {
            
            // MARK: - Navigation Bar
            
            // MARK: - Title
            
            TextField(titlePlaceholder, text: $title)
                .font(.title2)
                .submitLabel(.continue)
                .focused($focusState, equals: Field.title)
            //                .padding(.top, Sizes.largePadding) // 20
                .padding(.bottom, Sizes.largePadding)
                .padding(.horizontal, Sizes.overallPadding)
            
                .overlay {
                    Divider()
                        .padding(.init(top: 15 , leading: Sizes.overallPadding, bottom: 0, trailing: Sizes.overallPadding))
                }
            
            // MARK: - Contents
            
            CustomTextEditor(placeholder: contentsPlaceholder, text: $contents)
                .padding(.horizontal, Sizes.overallPadding)
            
        }
        .onDisappear(perform: {
            saveChanges()
        })
        .navigationBarItems(
            trailing: HStack {
                
                // pin Button
                Button(action: pinMemo) {
                    ChangeableImage(colorScheme: _colorScheme, imageSystemName: isPinned ? "pin.fill" : "pin", width: Sizes.regularButtonSize, height: Sizes.regularButtonSize)
                }
                
                // trash Button
                
                Button(action: removeMemo) {
                    ChangeableImage(colorScheme: _colorScheme, imageSystemName: "trash", width: Sizes.regularButtonSize, height: Sizes.regularButtonSize)
                }
                
                // more Button
                
                Menu {
                    
                    Button(action: changeColor) {
                        Label {
                            Text("Copy text")
                        } icon: {
                            Image(systemName: "doc.on.doc")
                        }
                    }
                    Button(action: changeColor) {
                        Label {
                            Text("Save as Image")
                        } icon: {
                            Image(systemName: "camera.viewfinder")
                        }
                    }
                    Button(action: changeColor) {
                        Label {
                            Text("Relocate memo")
                        } icon: {
                            Image(systemName: "folder")
                        }
                    }
                    
                    // Inner Menu, change Color
                    Menu {
                        Button(action: changeBackgroundColor) {
                            Label {
                                Text("Background Color")
                            } icon: {
                                Image(systemName: "eyedropper")
                            }
                        }
                        Button(action: changeContentsColor) {
                            Label {
                                Text("Contents Color")
                            } icon: {
                                Image(systemName: "eyedropper")
                            }
                        }
                        Button(action: changeTitleColor) {
                            Label {
                                Text("Title Color")
                            } icon: {
                                Image(systemName: "eyedropper")
                            }
                        }
                    }label: {
                        Label {
                            Text("Change color")
                        } icon: {
                            Image(systemName: "eyedropper")
                        }
                    }
                    // end of Inner Menu (changing Color
                    
                } label: {
                    ChangeableImage(colorScheme: _colorScheme, imageSystemName: "ellipsis", width: Sizes.regularButtonSize, height: Sizes.regularButtonSize)
                }
            })
    }
}


struct MemoView_Previews: PreviewProvider {
    
    static var sampleMemo = Memo(title: "Sample Memo",contents: "sample contents", context: PersistenceController.preview.container.viewContext)
    
    static var sampleFolder = Folder(title: "Sample Folder", context: PersistenceController.preview.container.viewContext)
    
    static var previews: some View {
        MemoView(memo: sampleMemo, parent: sampleFolder)
            .preferredColorScheme(.dark)
    }
}




// MARK: - TODO
/*
 focus to memo contents (show keyboard )
 
 */

