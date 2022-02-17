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
    //        return CustomTextView(text: $message, textStyle: $textStyle)
            return CustomTextView(text: $message)
        }
    
    var body: some View {
        //        ScrollView {
        VStack {
            //            TextField("Title", text: $title)
            CustomTextView(text: $message)
//            customTextView
//                .onAppear {
//                    customTextView.something()
//                }
            //            CustomTextView(text: $message, textStyle: $textStyle)
            //            customTextView
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
    //    @Binding var textStyle: UIFont.TextStyle
    
    func makeUIView(context: Context) -> UITextView {
        print("makeUIView has triggered")
        let uiTextView = UITextView()
        //        uiTextView.font = UIFont.preferredFont(forTextStyle: textStyle)
        uiTextView.autocapitalizationType = .sentences
        uiTextView.isSelectable = true
        uiTextView.isUserInteractionEnabled = true
        uiTextView.delegate = context.coordinator
        uiTextView.attributedText = NSAttributedString(string: uiTextView.text, attributes: [.font: UIFont.systemFont(ofSize: 28, weight: .bold)])
        uiTextView.text += ""
//        uiTextView.text = "asjdi"
        return uiTextView
    }
    
    func something() {
        
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        // should apply page pattern into this text. and make hyperlink with blue foreground Color and underline.
        let preAttributedRange: NSRange = uiView.selectedRange
        // apply attributed string
//        let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: text)
        
        print("updateUIView has triggered")
        if let firstIndex = text.firstIndex(of: "\n") {
            let index = text.distance(from: text.startIndex, to: firstIndex)
            print("index: ", index)   //index: 2
            let newIndex = text.index(text.startIndex, offsetBy: index)

            let title = text[..<newIndex]
            print("title : \(title)")

            let endIndex = text.endIndex

            let others = text[newIndex ..< endIndex ]
            print("others: \(others)")

            let attributedText = NSMutableAttributedString(
                string: String(title),
                attributes:
                    [.font: UIFont.preferredFont(forTextStyle: .title1),
                     NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,
                     NSAttributedString.Key.underlineColor: UIColor(white: 0.8, alpha: 0.5)])
    
            attributedText.append(NSAttributedString(string: String(others), attributes: [.font: UIFont.preferredFont(forTextStyle: .body)]))
            
            uiView.attributedText = attributedText

        }
        else {
//            let attribtedText = NSMutableAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 28, weight: .bold)])
            
            let attributedText = NSMutableAttributedString(
                string: uiView.text,
                attributes:
                    [.font: UIFont.preferredFont(forTextStyle: .title1),
                     NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,
                     NSAttributedString.Key.underlineColor: UIColor(white: 0.8, alpha: 0.5)])
            
            uiView.attributedText = attributedText
        }
        
        uiView.selectedRange = preAttributedRange
    }
    
    
    final class Coordinator: NSObject, UITextViewDelegate {
        
        var text: Binding<String>
        
        init(_ text: Binding<String>) {
            self.text = text
        }
        
        func textViewDidChange(_ textView: UITextView) {
            DispatchQueue.main.async {
                self.text.wrappedValue = textView.text
            }
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.text == "" {
            // Initial Setting, make cursor bigger.
            textView.attributedText = NSMutableAttributedString(string: String(" "), attributes: [.font: UIFont.systemFont(ofSize: 28, weight: .bold)])
            // retaining bigger Cursor, make it empty.
            textView.attributedText = NSMutableAttributedString(string: String(""), attributes: [.font: UIFont.systemFont(ofSize: 28, weight: .bold)])
            print("textViewDidBeginEditingTriggered")
            }
        }

    }
    
    // simply returns an instance of Coordinator.
    func makeCoordinator() -> Coordinator {
        Coordinator($text)
    }
    
    
    
}
