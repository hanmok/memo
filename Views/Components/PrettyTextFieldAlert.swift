//
//  TextFieldAlert.swift
//  DeeepMemo (iOS)
//
//  Created by Mac mini on 2022/01/13.
//

import SwiftUI


enum TextFieldAlertType: String {
    case rename = "Rename Folder"
    case newSubFolder = "New Sub Folder"
    case newTopFolder = "New Folder"
    case newTopArchive = "New Archive"
}

struct TextFieldStruct {
    
    var textEnum: TextFieldAlertType
    
    // Not Curretly using
    var placeHolder: String {
        switch textEnum {
        case .rename: return "Enter New Folder Name!"
        case .newSubFolder: return "Enter New SubFolder Name"
        case .newTopFolder: return "Enter New TopFolder Name"
        case .newTopArchive: return "Enter New Top Archive Name"
        }
    }
}

struct PrettyTextFieldAlert: View {
    
    let type: TextFieldAlertType
    
    @Environment(\.colorScheme) var colorScheme
    
    let screenSize = UIScreen.main.bounds
    
    @Binding var isPresented: Bool
    @Binding var text: String
    
    @FocusState var focusState: Bool
    
    var submitAction: (String) -> Void = { _ in }
    var cancelAction: () -> Void = { }
    
    var body: some View {
        ZStack{
            VStack(spacing: 0) {
                Text(type.rawValue)
                    .font(.headline)
                    .padding(.vertical, 15)
                
                TextField(TextFieldStruct(textEnum: type).placeHolder, text: $text)
                    .disableAutocorrection(true)
                    .font(.callout)
                    .focused($focusState)
                    .background(colorScheme == .dark ? .black : .white)
                    .accentColor(colorScheme == .dark ? Color.cream : Color.bookmarkBarColor)
                    .foregroundColor(Color.blackAndWhite)
                    .cornerRadius(5)
                    .padding(.horizontal, Sizes.overallPadding)
                    .padding(.bottom, 15)
                    .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { obj in
                        if let textField = obj.object as? UITextField {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.52) {  /// Anything over 0.5 seems to work
                                textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
                            }
                        }
                    }
                
                    .onChange(of: isPresented) { newValue in
                        if newValue == true {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {  /// Anything over 0.5 seems to work
                                print("newValue is turned to true")
                                self.focusState = true
                            }
                        }
                    }
                    .onAppear {
                        print("text: \(text)")
                    }
                
                // Cancel and Done Button
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(colorScheme == .dark ? Color(white: 80 / 255) : Color(white: 205 / 255))
                
                HStack(alignment: .center) {
                    
                    Button {
                        cancelAction()
                        isPresented = false
                        focusState = false
                    } label: {
                        Text("Cancel")
                            .foregroundColor(.red)
                            .frame(alignment: .center)
                           
                    }
                    .frame(width: screenSize.width * 0.32, alignment: .center)

                    Rectangle()
                        .frame(width: 1)
                        .foregroundColor(colorScheme == .dark ? Color(white: 80 / 255) : Color(white: 205 / 255))
                    
                    
                    Button {
                        submitAction(text)
                        isPresented = false
                        focusState = false
                    } label: {
                        Text("Done")
                            .foregroundColor(colorScheme == .dark ? Color.cream : .black)
                            .frame(alignment: .center)
                    }
                    .frame(width: screenSize.width * 0.32, alignment: .center)
                } // end of HStack
            }

            .frame(width: screenSize.width * 0.65, height: 132)
            .background(colorScheme == .dark ? Color(white: 50 / 255) : Color(white: 240 / 255))
            .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
            .offset(y: isPresented ? 0 : screenSize.height)
            .animation(.spring(), value: isPresented)
        }
    }
}
