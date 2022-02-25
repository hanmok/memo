//
//  MemoClone.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/02/16.
//

import SwiftUI


struct PlainTextView: UIViewRepresentable {
    @Environment(\.colorScheme) var colorSchme
    @Binding var text: String
    //    @Binding var textStyle: UIFont.TextStyle

    func makeUIView(context: Context) -> UITextView {
        print("makeUIView has triggered")
        let uiTextView = UITextView()
        //        uiTextView.font = UIFont.preferredFont(forTextStyle: textStyle)
        uiTextView.autocapitalizationType = .sentences
        uiTextView.autocorrectionType = .no
        uiTextView.isSelectable = true
        uiTextView.isUserInteractionEnabled = true
        uiTextView.delegate = context.coordinator
        uiTextView.showsVerticalScrollIndicator = true
        uiTextView.keyboardDismissMode = .interactive
//        uiTextView.attributedText = NSAttributedString(string: uiTextView.text, attributes: [.font: UIFont.preferredFont(forTextStyle: .title1)])
        uiTextView.attributedText = NSAttributedString(string: uiTextView.text, attributes: [.font: UIFont.preferredFont(forTextStyle: .body)])
        return uiTextView
    }
    
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        print("updateUIView triggered")
//        uiView.attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.preferredFont(forTextStyle: .title1)])
        uiView.attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.preferredFont(forTextStyle: .body)])
    }
    
    
    final class Coordinator: NSObject, UITextViewDelegate {
        
        var text: Binding<String>
        
        init(_ text: Binding<String>) {
            self.text = text
        }
        
    }
    
    // simply returns an instance of Coordinator.
    func makeCoordinator() -> Coordinator {
        Coordinator($text)
    }
    
    
    
}
