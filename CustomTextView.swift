import SwiftUI
import Combine

struct CustomTextView: UIViewRepresentable {
    @Binding var text: String
    @Binding var keyboardRect: CGRect
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        
        textView.delegate = context.coordinator
        
        textView.font = UIFont.preferredFont(forTextStyle: .title3)
        textView.keyboardDismissMode = .interactive
        textView.showsVerticalScrollIndicator = false
        textView.alwaysBounceVertical = true
        textView.isScrollEnabled = true
        textView.becomeFirstResponder()
        textView.autocorrectionType = .no
        return textView
    }
 
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardRect.height, right: 0)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator($text)
    }
     
    class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<String>
     
        init(_ text: Binding<String>) {
            self.text = text
        }
     
        func textViewDidChange(_ textView: UITextView) {
            self.text.wrappedValue = textView.text
        }
    }
}


extension Publishers {
    static var keyboardRect: AnyPublisher<CGRect, Never> {
        
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification).map {$0.keyboardRect}
        
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification).map { _ in CGRect(x: 0, y: 0, width: 0, height: 0)}
        
        return MergeMany(willShow, willHide).eraseToAnyPublisher()
        
    }
}

extension Notification {
    var keyboardRect: CGRect {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect) ?? .zero
    }
}
