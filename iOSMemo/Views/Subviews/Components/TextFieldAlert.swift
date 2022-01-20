//
//  TextFieldAlert.swift
//  DeeepMemo (iOS)
//
//  Created by Mac mini on 2022/01/13.
//

import SwiftUI

struct TextFieldAlert: View {
    
    let screenSize = UIScreen.main.bounds
    
    @Binding var isPresented: Bool
    @Binding var text: String
    @FocusState var focusState: Bool
    // working find..
    var submitAction: (String) -> Void = { _ in }
    var cancelAction: () -> Void = { }
    
    var body: some View {
        ZStack{
            VStack {
                TextField("Enter New FolderName", text: $text)
                    .focused($focusState)
                    .padding(.top, 5)
                    .background(.white)
                    .cornerRadius(5)
                    .padding(.horizontal, Sizes.overallPadding)
                
                HStack(spacing: 15) {
                    Button {
                        submitAction(text)
                        isPresented = false
                        focusState = false
                    } label: {
                        Text("Done")
                            .foregroundColor(.black)
                            .padding(.horizontal, Sizes.overallPadding)
                    }
                    .padding(5)
                    .background(Color.white)
                    .cornerRadius(5)
                    
                    Button {
                        cancelAction()
                        isPresented = false
                        focusState = false
                    } label: {
                        Text("Cancel")
                            .foregroundColor(.red)
                            .padding(.horizontal, Sizes.overallPadding)
                    }
                    .padding(5)
                    .background(Color.white)
                    .cornerRadius(5)
                }
                .padding(.horizontal, Sizes.overallPadding)
            }
            .padding(10)
            .frame(width: screenSize.width * 0.65, height: screenSize.height * 0.15)
            .background(Color(.sRGB, white: 0.8))
            .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
            .offset(y: isPresented ? 0 : screenSize.height)
            .animation(.spring().speed(2), value: isPresented)
            .shadow(color: .white, radius: 6, x: -9, y: -9)
        }
    }
}

struct TextFieldAlert_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldAlert(isPresented: .constant(true), text: .constant("Placeholder Text"))
    }
}
