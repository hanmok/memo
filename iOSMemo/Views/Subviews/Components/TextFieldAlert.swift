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
    
    var submitAction: (String) -> Void = { _ in }
    var cancelAction: () -> Void = { }
    
    var body: some View {
        VStack {
            Text("Enter New FolderName")
            TextField("", text: $text)
            
            HStack {
                Button {
                    submitAction(text)
                } label: {
                    Text("Done")
                        .foregroundColor(.black)
                }
                Button {
                    cancelAction()
                } label: {
                    Text("Cancel")
                        .foregroundColor(.red)
                }

            }
        }
        .padding()
        .frame(width: screenSize.width * 0.7, height: screenSize.height * 0.3)
        .background(.green)
//        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
        .offset(y: isPresented ? 0 : screenSize.height)
//        .animation(.spring())
        .animation(.spring().speed(2), value: isPresented)
        .shadow(color: .white, radius: 6, x: -9, y: -9)
    }
}

struct TextFieldAlert_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldAlert(isPresented: .constant(true), text: .constant("Placeholder Text"))
    }
}
