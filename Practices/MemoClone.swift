//
//  MemoClone.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/02/16.
//

import SwiftUI

struct MemoClone: View {
    @State private var title = "Title"
    @State private var message = ""
    @State private var textStyle = UIFont.TextStyle.body
    
    var customTextView: CustomTextView {
        return CustomTextView(text: $message, textStyle: $textStyle)
    }
    var body: some View {
//        ScrollView {
        VStack {
            TextField("Title", text: $title)
            
//            CustomTextView(text: $message, textStyle: $textStyle)
            customTextView
//                .fixedSize(horizontal: false, vertical: true)
        }
//        .fixedSize(horizontal: false, vertical: true)
//        }
    }
}

// TextView .
// UIView Representable
// A wrapper for a UIKit view that you use to integrate that view into your SwiftUI view hierarchy.

struct CustomTextView: UIViewRepresentable {
    
    @Binding var text: String
    @Binding var textStyle: UIFont.TextStyle
    
    func makeUIView(context: Context) -> UITextView {
        let uiTextView = UITextView()
        uiTextView.font = UIFont.preferredFont(forTextStyle: textStyle)
        uiTextView.autocapitalizationType = .sentences
        uiTextView.isSelectable = true
        uiTextView.isUserInteractionEnabled = true
        uiTextView.delegate = context.coordinator
        
        return uiTextView
    }
    
    func something() {
        
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.font = UIFont.preferredFont(forTextStyle: textStyle)
        
        let newPosition = uiView.endOfDocument
        uiView.selectedTextRange = uiView.textRange(from: newPosition, to: newPosition)
        
        
//        if let newPosition = textField.position(from: , offset: -1) {
//            uiView.selectedTextRange = uiView.textRange(from: newPosition, to: newPosition)
//        }
        
    }
    

    final class Coordinator: NSObject, UITextViewDelegate {
        
        var text: Binding<String>
        
        init(_ text: Binding<String>) {
            self.text = text
        }

        func textViewDidChange(_ textView: UITextView) {
            self.text.wrappedValue = textView.text
        }
    }
    
    // simply returns an instance of Coordinator.
    func makeCoordinator() -> Coordinator {
//        return Coordinator(customTextView: self)
        Coordinator($text)
    }
    
//    typealias UIViewType = UITextView
    
    
}
