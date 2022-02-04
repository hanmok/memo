//
//  TextFieldAlert.swift
//  DeeepMemo (iOS)
//
//  Created by Mac mini on 2022/01/13.
//

import SwiftUI

//enum TextFieldAlertType: String {
//    case rename = "Rename Folder"
//    case newSubFolder = "New Subfolder"
//    case newTopFolder = "New Topfolder"
//}

enum TextFieldAlertType: String {
    case rename = "Rename Folder"
    case newSubFolder = "New Subfolder"
    case newTopFolder = "New Topfolder"
}

struct TextFieldStruct {
    
    
    var textEnum: TextFieldAlertType
    
    var placeHolder: String {
        switch textEnum {
        case .rename: return "Enter New Folder Name!"
        case .newSubFolder: return "Enter New SubFolder Name"
        case .newTopFolder: return "Enter New TopFolder Name"
        }
    }
}

struct PrettyTextFieldAlert: View {
//    let placeHolderText: String
    let type: TextFieldAlertType
    
    let screenSize = UIScreen.main.bounds
    
    @Binding var isPresented: Bool
    @Binding var text: String
    
    @FocusState var focusState: Bool
    // working find..
    var submitAction: (String) -> Void = { _ in }
    var cancelAction: () -> Void = { }
    
    var body: some View {
        ZStack{
            VStack(spacing: 0) {
                Text(type.rawValue)
                    .font(.headline)
                    .padding(.vertical, 15)
                // placeHolder ..
//                TextField("Enter New FolderName", text: $text)
//                TextField(placeHolderText, text: $text)
                TextField(TextFieldStruct(textEnum: type).placeHolder, text: $text)
                    .font(.callout)
                    .focused($focusState)
                    .background(.white)
                    .cornerRadius(5)
                    .padding(.horizontal, Sizes.overallPadding)
                    .padding(.bottom, 15)
                    .onChange(of: isPresented) { newValue in
                        if newValue == true {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {  /// Anything over 0.5 seems to work
                                print("newValue is turned to true")
                                self.focusState = true
                            }
                        }
                    }
                
                // Cancel and Done Button
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color(white: 225 / 255))
                
//                HStack(spacing: 15) {
                HStack(alignment: .center) {
                    
                    Button {
                        cancelAction()
                        isPresented = false
                        focusState = false
                    } label: {
                        Text("Cancel")
                            .foregroundColor(.red)
//                            .padding(.horizontal, Sizes.overallPadding)
                            .frame(alignment: .center)
                           
                    }
                    .frame(width: screenSize.width * 0.32, alignment: .center)

                    Rectangle()
                        .frame(width: 1)
                        .foregroundColor(Color(white: 225 / 255))
                    
//                        .padding(.vertical, 0)
                    
                    Button {
                        submitAction(text)
                        isPresented = false
                        focusState = false
                    } label: {
                        Text("Done")
                            .foregroundColor(.black)
//                            .padding(.horizontal, Sizes.overallPadding)
                            .frame(alignment: .center)
                    }
                    .frame(width: screenSize.width * 0.32, alignment: .center)
                } // end of HStack

            }

            .frame(width: screenSize.width * 0.65, height: 132)
//            .background(Color(.sRGB, white: 0.8))
            .background(Color(.sRGB, white: 241/255))
            .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
            .offset(y: isPresented ? 0 : screenSize.height)
            .animation(.spring(), value: isPresented)
            .shadow(color: .white, radius: 6, x: -9, y: -9)
        }
    }
}

//struct PrettyTextFieldAlert_Previews: PreviewProvider {
//    static var previews: some View {
//        PrettyTextFieldAlert(type: .rename, isPresented: .constant(true), text: .constant("Placeholder Text"))
//    }
//}
