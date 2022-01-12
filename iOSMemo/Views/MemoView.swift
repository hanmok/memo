//
//  MemoView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/21.
//

import SwiftUI
import Combine


struct MemoView: View {
    
    @FocusState var focusState: Field?
    //    @Environment(\.colorScheme)
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject var memo: Memo
    
    @EnvironmentObject var nav: NavigationStateManager
    // 업데이트가.. 어떻게 이상한거야 ??
    // CoreData 를 업데이트 해도 nav 가 업데이트 되지는 않아. 그런 것 같아.
    // 음.. EnvironmentObject 에서, nav 자체를 업데이트 할 수는 없나?
    // 할 수 있다고 쳐도, 받는건 Memo Object 로 받아야해
    // Memo Object 로 받았는데, 왜이러지... ??
    let parent: Folder
    
    //    @Binding var memo: MemoViewModel.currentMemo
    //    @ObservedObject var memoViewModel: MemoViewModel
    
    enum Field: Hashable {
        case title
        case contents
    }
    
    @State var isPinned: Bool = false
    
    
    // navigation.selectedFolder 를 어떻게 업데이트 시켜줄 수는 없을까 ??
    func saveChanges() {
        print("save changes has triggered")
        memo.title = title
        memo.contents = contents
        memo.overview = overview
        context.saveCoreData()
        print("nav: \(nav.selectedFolder!.getFolderInfo())")
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
    

//    init(memo: Memo, parent: Folder) {
//        title = memo.title
//        overview = memo.overview
//        contents = memo.contents
//    }
    // should be bindings
//    @Binding var titleBinded: String
    @State var title: String = ""
    @State var contents: String = ""
    @State var overview: String = ""
    
    //    @Binding var myTitle: String
    //    @State var myTitle: String = "" // 이거.. Binding 으로 와야함..@ObservedObject
    // MVVM
    //    @State var myText: String = "initial text editor"
    
    
    //    @Binding var myText: String
    
    //    @Binding var memo: Memo
    
    var body: some View {
        
        let binding = Binding<String>(get: {
            self.title
        }, set: {
            self.title = $0
            // do whatever you want here
            memo.title = title
            saveChanges()
        })
        
        return VStack {
            
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
                .onChange(of: memo.contents, perform: { _ in
                    saveChanges()
                })
                .padding(.horizontal, Sizes.overallPadding)
               
            
        }
        // triggered after FolderView has appeared
        .onDisappear(perform: {
            print("memoView has disappeared!")
            saveChanges()
            print("data saved!")
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
        
        saveChanges()
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

