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
    // add save when done pressed ? ? ?
//    var doneButtonAction: () -> Void = { }
    
    @State var firstTime = true
    func makeUIView(context: Context) -> UITextView {
        print("makeUIView has triggered")
        let uiTextView = UITextView()
        //        uiTextView.font = UIFont.preferredFont(forTextStyle: textStyle)
        uiTextView.autocapitalizationType = .sentences
        uiTextView.autocorrectionType = .no
        uiTextView.isSelectable = true
        uiTextView.isUserInteractionEnabled = true
        uiTextView.delegate = context.coordinator
        
        uiTextView.text += ""
//                uiTextView.showsVerticalScrollIndicator = true
        uiTextView.showsVerticalScrollIndicator = false
        //        uiTextView.keyboardDismissMode = .interactive
        //        uiTextView.keyboardDismissMode = .interactive
        uiTextView.keyboardDismissMode = .onDrag
//        uiTextView.foreg
        
//        uiTextView.tintColor = UIColor.textViewTintColor
        uiTextView.tintColor = UIColor.swipeBtnColor2
        //        uiTextView.attributedText = NSAttributedString(string: uiTextView.text, attributes: [.font: UIFont.preferredFont(forTextStyle: .title1)])
        uiTextView.attributedText = NSAttributedString(string: uiTextView.text, attributes: [.font: UIFont.preferredFont(forTextStyle: .title3), .foregroundColor: UIColor.memoTextColor])
        //        uiTextView.addd
        uiTextView.addDoneButtonOnKeyboard()
        return uiTextView
    }
    
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        //        print("updateUIView triggered")
        if firstTime {
            //        uiView.attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.preferredFont(forTextStyle: .title1)])
            DispatchQueue.main.async {
                uiView.attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.preferredFont(forTextStyle: .title3), .foregroundColor: UIColor.memoTextColor])
                firstTime.toggle()
            }
        }
    }
    
    
    final class Coordinator: NSObject, UITextViewDelegate {
        
        var text: Binding<String>
        
        init(_ text: Binding<String>) {
            self.text = text
        }
        
        // This line ..
        func textViewDidChange(_ textView: UITextView) {
            DispatchQueue.main.async {
                self.text.wrappedValue = textView.text
                textView.attributedText = NSAttributedString(string: textView.text, attributes: [.font: UIFont.preferredFont(forTextStyle: .title3), .foregroundColor: UIColor.memoTextColor])
            }
        }
    }
    
    // simply returns an instance of Coordinator.
    func makeCoordinator() -> Coordinator {
        Coordinator($text)
    }
}

extension UITextView {
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x:0, y:0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        DispatchQueue.main.async {
            self.resignFirstResponder()
        }
//        doneButtonAction()
    }
}
