////
////  MemoClone.swift
////  DeeepMemo
////
////  Created by Mac mini on 2022/02/16.
////
//
//import SwiftUI
//
//
//// TextView .
//// UIView Representable
//// A wrapper for a UIKit view that you use to integrate that view into your SwiftUI view hierarchy.
//
//struct CustomTextView1: UIViewRepresentable {
//
//    @Environment(\.colorScheme) var colorSchme
//    @Binding var text: String
//    //    @Binding var textStyle: UIFont.TextStyle
//    @State var firstTime = true
//    func makeUIView(context: Context) -> UITextView {
//        print("makeUIView has triggered")
//        let uiTextView = UITextView()
//        //        uiTextView.font = UIFont.preferredFont(forTextStyle: textStyle)
//        uiTextView.autocapitalizationType = .sentences
//        uiTextView.autocorrectionType = .no
//        uiTextView.isSelectable = true
//        uiTextView.isUserInteractionEnabled = true
//        uiTextView.delegate = context.coordinator
//        // this line looks weird..
//
//        uiTextView.text += ""
//        uiTextView.showsVerticalScrollIndicator = false
//        uiTextView.tintColor = UIColor.textViewTintColor
//        //        uiTextView.tintColor = .red
//
//        uiTextView.attributedText = NSAttributedString(string: uiTextView.text, attributes: [.font: UIFont.systemFont(ofSize: 28, weight: .bold)])
//
//        //        uiTextView.keyboardDismissMode = .interactive
//        uiTextView.keyboardDismissMode = .onDrag
//        //        uiTextView.inputAccessoryView = uiView
//        //        uiTextView.allowsEditingTextAttributes = true
//
//        return uiTextView
//    }
//
//    func something() {
//
//    }
//
//    func updateUIView(_ uiView: UITextView, context: Context) {
//        print("updateUIView triggered")
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
//                uiView.attributedText = attributedText
//                firstTime.toggle()
//            }
//        }
//    }
//
//
//    final class Coordinator: NSObject, UITextViewDelegate {
//
//        var text: Binding<String>
//
//        init(_ text: Binding<String>) {
//            self.text = text
//        }
//
//        func textViewDidChange(_ textView: UITextView) {
//
//            print("textViewDidChange Triggered")
//
//            DispatchQueue.main.async {
//                self.text.wrappedValue = textView.text
//            }
//
//            let preAttributedRange: NSRange = textView.selectedRange
//
//
//            // Set initial font .body
//            let attributedText = NSMutableAttributedString(
//                string: textView.text,
//                attributes: [
//                    .font: UIFont.preferredFont(forTextStyle: .body),
//                    .foregroundColor: UIColor.memoTextColor//                    .foregroundColor: UIColor.red
//                ])
//
//            // are they.. included ? or not ?
//            if let firstIndex = textView.text.firstIndex(of: "\n") {
//                print("flagggg ")
//                let distance = textView.text.distance(from: textView.text.startIndex, to: firstIndex)
//                print("flagggg distance: \(distance)")
//                attributedText.addAttributes([
//                    .font: UIFont.preferredFont(forTextStyle: .title1),
//                    .foregroundColor: UIColor.memoTextColor],
//                                             range: NSRange(location: 0, length: distance))
//
//                print("flagggg range: \(NSRange(location:0, length: distance))")
//            } else {
//                let startToEndDistance = textView.text.distance(from: textView.text.startIndex, to: textView.text.endIndex)
//
//                attributedText.addAttributes(
//                    [.font: UIFont.preferredFont(forTextStyle: .title1),
//                     .foregroundColor: UIColor.memoTextColor],
//                    range: NSRange(location: 0, length: startToEndDistance))
//            }
//
//            textView.attributedText = attributedText
//
//            textView.selectedRange = preAttributedRange
//        }
//
//        func textViewDidBeginEditing(_ textView: UITextView) {
//            if textView.text == "" {
//                // Initial Setting, make cursor bigger.
//                textView.attributedText = NSMutableAttributedString(string: String(" "), attributes: [.font: UIFont.systemFont(ofSize: 28, weight: .bold)])
//                // retaining bigger Cursor, make it empty.
//                textView.attributedText = NSMutableAttributedString(string: String(""), attributes: [.font: UIFont.systemFont(ofSize: 28, weight: .bold)])
//                print("textViewDidBeginEditingTriggered")
//            }
//        }
//
//    }
//
//    // simply returns an instance of Coordinator.
//    func makeCoordinator() -> Coordinator {
//        Coordinator($text)
//    }
//}
