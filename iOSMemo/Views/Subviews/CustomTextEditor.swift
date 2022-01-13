//
//  CustomTextEditor.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/22.
//

import SwiftUI

struct CustomTextEditor: View {
    
    let placeholder: String
    @Binding var text: String
    let internalPadding: CGFloat = 5
    
    // MARK: - How... Can I add focusState here ? ?
    
//    @Binding var focusState: Hashable
//    let submitActionHandler: () -> Void
//    @Binding var focusState: Hashable
    var body: some View {
        ZStack(alignment: .topLeading, content: {
            if text.isEmpty {
                Text(placeholder)
//                    .foregroundColor(Color.primary.opacity(0.25))
                    .padding(EdgeInsets(top: 7, leading: 4, bottom: 0, trailing: 0))
//                    .padding(internalPadding)
            }
            TextEditor(text: $text)
            // not currently working .. submitLabel .. TT..
//                .submitLabel(.next)
//                .submitLabel(.continue)
//                .focused(<#T##binding: FocusState<Hashable>.Binding##FocusState<Hashable>.Binding#>, equals: <#T##Hashable#>)
                .onAppear {
                    UITextView.appearance().backgroundColor = .clear
                }
                .onDisappear {
                    UITextView.appearance().backgroundColor = nil
                }
                
//                .onSubmit {
//                    submitActionHandler()
//                }
        })
            
        
    }
}

struct CustomTextEditor_Previews: PreviewProvider {
    @State static var bindedText = "bindedText"
    static var previews: some View {
//        CustomTextEditor(placeholder: "it's placeholder", text: $bindedText, submitActionHandler: {})
        CustomTextEditor(placeholder: "it's placeholder", text: $bindedText)
    }
}


//extension View {
//    func placeholder<Content: View>(
//        when shouldShow: Bool,
//        alignment: Alignment = .leading,
//        @ViewBuilder placeholder: () -> Content) -> some View {
//        ZStack(alignment: alignment) {
//            placeholder().opacity(shouldShow ? 1 : 0)
//            self
//        }
//    }
//}
