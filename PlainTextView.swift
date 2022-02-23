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
        uiTextView.showsVerticalScrollIndicator = true
        uiTextView.keyboardDismissMode = .interactive
        uiTextView.attributedText = NSAttributedString(string: uiTextView.text, attributes: [.font: UIFont.preferredFont(forTextStyle: .title1)])
        return uiTextView
    }
    
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        print("updateUIView triggered")
//        if firstTime {
//            //            uiView.text = text
//            let attributedText = NSMutableAttributedString(
//                string: text,
//                attributes:
//                    [.font: UIFont.preferredFont(forTextStyle: .body),
//                     .foregroundColor: UIColor.memoTextColor])
//
//            // cannot find any of \n
//
//            if let firstIndex = text.firstIndex(of: "\n") {
//                let distance = text.distance(from: text.startIndex, to: firstIndex)
//                attributedText.addAttributes([
//                    .font: UIFont.preferredFont(forTextStyle: .title1),
//                    .foregroundColor: UIColor.memoTextColor],
//                                             range: NSRange(location: 0, length: distance))
//                print("distance: \(distance)")
//            }
//            DispatchQueue.main.async {
//
//                uiView.attributedText = attributedText
//                    firstTime.toggle()
//            }
//        }
//        uiView.text = text
        uiView.attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.preferredFont(forTextStyle: .title1)])
    }
    
    
    final class Coordinator: NSObject, UITextViewDelegate {
        
        var text: Binding<String>
        
        init(_ text: Binding<String>) {
            self.text = text
        }
        
//        func textViewDidChange(_ textView: UITextView) {
//            print("textViewDidChange Triggered")
//
//            DispatchQueue.main.async {
//                self.text.wrappedValue = textView.text
//            }
////            textView.text = text
//
////            textView.selectedRange = preAttributedRange
//        }
        
//        func textViewDidBeginEditing(_ textView: UITextView) {
//            if textView.text == "" {
//            // Initial Setting, make cursor bigger.
//            textView.attributedText = NSMutableAttributedString(string: String(" "), attributes: [.font: UIFont.systemFont(ofSize: 28, weight: .bold)])
//            // retaining bigger Cursor, make it empty.
//            textView.attributedText = NSMutableAttributedString(string: String(""), attributes: [.font: UIFont.systemFont(ofSize: 28, weight: .bold)])
//            print("textViewDidBeginEditingTriggered")
//            }
//        }
        
    }
    
    // simply returns an instance of Coordinator.
    func makeCoordinator() -> Coordinator {
        Coordinator($text)
    }
    
    
    
}
