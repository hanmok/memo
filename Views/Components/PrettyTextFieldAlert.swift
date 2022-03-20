//
//  TextFieldAlert.swift
//  DeeepMemo (iOS)
//
//  Created by Mac mini on 2022/01/13.
//

import SwiftUI

enum ButtonType {
    case cancel
    case done
}

enum TextFieldAlertType: String {
    case rename = "Rename Folder"
    case newSubFolder = "New Sub Folder"
    case newTopFolder = "New Folder"
    case newTopArchive = "New Archive"
}

struct TextFieldStruct {

    var textEnum: TextFieldAlertType

    // place space before text, to make it more prettier.
    var placeHolder: String {
        switch textEnum {
        case .rename: return ""
//        case .newSubFolder: return "Folder Name"
        case .newSubFolder: return LocalizedStringStorage.newFolderPlaceHolder
//        case .newTopFolder: return "Folder Name"
        case .newTopFolder: return LocalizedStringStorage.newFolderPlaceHolder
//        case .newTopArchive: return "Folder Name"
        case .newTopArchive: return LocalizedStringStorage.newFolderPlaceHolder
        }
    }
}



struct PrettyTextFieldAlert: View {
    
    let type: TextFieldAlertType
    
    @Environment(\.colorScheme) var colorScheme
    
    let screenSize = UIScreen.main.bounds
    @State var selectedColor = Color.cream
    @State var selectedButton: ButtonType? = nil
    @Binding var isPresented: Bool
    @Binding var text: String
    
    @FocusState var focusState: Bool
    
    var submitAction: (String) -> Void = { _ in }
    var cancelAction: () -> Void = { }
    
    func some() {
        focusState = true
    }
    
    func showKeyboardInHalfSecond() {
        var increasedSeconds = 0.0
        for _ in 0 ... 5 {
            increasedSeconds += 0.1
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + increasedSeconds) {
                focusState = true
            }
        }
    }
    
    
    
    var body: some View {

        VStack(spacing: 0) {

                Text(LocalizedStringStorage.convertTypeToStorage(type: type))
                    .font(.headline)
                    .padding(.vertical, 15)
                Spacer()

                
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
            
                    .onSubmit {
                        submitAction(text)
                        isPresented = false
                        focusState = false
                        selectedButton = .done
                    }
                
                    .onChange(of: isPresented) { newValue in
                        if newValue == true {
                            showKeyboardInHalfSecond()
                        }
                    }
                    .onAppear {
                        print("text: \(text)")
                    }
                
                // Cancel and Done Button
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(colorScheme == .dark ? Color(white: 80 / 255) : Color(white: 205 / 255))
                
                HStack(alignment: .center, spacing: 0){
                    
                    // CANCEL
                    Button {
                        cancelAction()
                        isPresented = false
                        focusState = false
                        selectedButton = .cancel
                    } label: {
                        Text(LocalizedStringStorage.cancel)
                            .foregroundColor(.red)
                            .frame(width: screenSize.width * 0.32, alignment: .center)
                            .frame(height: 50)
                    }
                    .frame(width: screenSize.width * 0.32, alignment: .center)
                    .frame(height: 50)
                    
                    
                    Rectangle()
                        .frame(width: 1)
                        .foregroundColor(colorScheme == .dark ? Color(white: 80 / 255) : Color(white: 205 / 255))
                    
                    // DONE
                    Button {
                        submitAction(text)
                        isPresented = false
                        focusState = false
                        selectedButton = .done
                    } label: {
                        Text(LocalizedStringStorage.done)
                            .foregroundColor(colorScheme == .dark ? Color.cream : .black)
                            .frame(width: screenSize.width * 0.32, alignment: .center)
                            .frame(height: 50)
                    }
                    .frame(width: screenSize.width * 0.32, alignment: .center)
                    .frame(height: 50)
                } // end of HStack
                
                .frame(height: 50)
            } // end of VStack
            .frame(width: screenSize.width * 0.64, height: 150)
            .background(colorScheme == .dark ? Color(white: 50 / 255) : Color(white: 240 / 255))
            .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
            .offset(y: isPresented ? 0 : screenSize.height)
            .animation(.spring(), value: isPresented)
    }
}
