//
//  MemoClone.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/02/16.
//

import SwiftUI

// 이거, NSAttributedString 의 Extension 으로 기능 제공하는게 낫지 않을까?

class AttributedStringManager {
    
    init() {
        createPattern()
    }
    
    let backingStore = NSMutableAttributedString()
    
    
    private var replacements: [String: [NSAttributedString.Key: Any]] = [:]
    
    func createAttributesForFontStyle(
        _ style: UIFont.TextStyle,
        withTrait trait: UIFontDescriptor.SymbolicTraits) -> [NSAttributedString.Key: Any] {
            let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
            let descriptorWithTrait = fontDescriptor.withSymbolicTraits(trait)
            // force UIFont to return a size that matches the user's current font size preferences.
            let font = UIFont(descriptor: descriptorWithTrait!, size: 0)

            return [.font: font]
        }
    
    func createPattern() {
       let scriptFontDescriptor = UIFontDescriptor(fontAttributes: [.family: "Zapfino"])
//
       let bodyFontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
       let bodyFontSize = bodyFontDescriptor.fontAttributes[.size] as! NSNumber
       let scriptFont = UIFont(descriptor: scriptFontDescriptor, size: CGFloat(bodyFontSize.floatValue))

        let boldAttributes = createAttributesForFontStyle(.body, withTrait: .traitBold)
       let strikeThroughAttributes =  [NSAttributedString.Key.strikethroughStyle: 1]
       let scriptAttributes = [NSAttributedString.Key.font: scriptFont]
       let redTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
       let webSiteAttributes = [
           NSAttributedString.Key.foregroundColor: UIColor.blue
//           ,
//           NSAttributedString.Key.underlineColor: .blue, NSAttributedString.Key.underlineStyle: .blue
       ]
       
       replacements = [
           "(-\\w+(\\s\\w+)*-)": strikeThroughAttributes,
           "(~\\w+(\\s\\w+)*~)": scriptAttributes,
           "\\s([A-Z]{2,})\\s": redTextAttributes,
           "((?:http|https|Http|Https:)://)?(?:www|Www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?": webSiteAttributes,
           "^(.*)$/m": redTextAttributes,
           "^(.*)$": redTextAttributes // this line works.
           ,"(^(.*)$/m)[0]": redTextAttributes // this line works.
           , "^(.*)$\\m": redTextAttributes,
           
         ]
   }
    
    func listMatches(for pattern: String, inString string: String) -> [String] {
//        음.. 괜찮아보이는데 ??
        let webPattern = "((?:http|https|Http|Https:)://)?(?:www|Www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
        
//      guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
//        return []
//      }
        guard let regex = try? NSRegularExpression(pattern: webPattern, options: []) else {
          return []
        }
      
      let range = NSRange(string.startIndex..., in: string)
      let matches = regex.matches(in: string, options: [], range: range)
      
        
      return matches.map {
        let range = Range($0.range, in: string)!
          print("listMatches: \(string[range])")
        return String(string[range])
      }
    }
    
    
    func convertTextIntoAttr(str: String) -> NSMutableAttributedString {
        let bodyFont = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
        let attr = NSMutableAttributedString(string: str, attributes: bodyFont)
//        addAttributes(bodyFont, range: NSMakeRange(0, length))
        
        // apply styles to range
        
        for (pattern2, attributes2) in replacements {
            do {
                let regex = try NSRegularExpression(pattern: pattern2)
                regex.enumerateMatches(in: str, range: NSMakeRange(0, str.count)) { match, flags, stop in
                    
//                    Passing range(at:) the value 0 always returns the value of the range property. Additional ranges, if any, will have indexes from 1 to numberOfRanges-1.
                    
                    if let matchRange = match?.range(at: 0) {
                        print("Matched pattern: \(pattern2), matchedRange: \(matchRange)")
//                        print("string: \(String(str[Range(matchRange)!]))")
//                        print("Matched str: \(str[matchRange])")
//                        print("matchRange: \(matchRange)")
                        
                        attr.addAttributes(attributes2, range: matchRange)
                        
                        let maxRange = matchRange.location + matchRange.length
                        if maxRange + 1 < str.count {
                            attr.addAttributes(bodyFont, range: NSMakeRange(maxRange, 1))
                            
                        }
                    }
                }
            } catch {
                print("error during coverting str into attr str")
            }
        }
        
        return attr
    }
}

struct MemoTextViewTest1: UIViewRepresentable {
    
    @Environment(\.colorScheme) var colorSchme
    @Binding var text: String
    //    @Binding var textStyle: UIFont.TextStyle
    @State var didNotTriggerYet = true
    
    public var attrManager = AttributedStringManager()
    
    
    func makeUIView(context: Context) -> UITextView {
//        createPattern()
        print("makeUIView has triggered")
        let uiTextView = UITextView()
        //        uiTextView.font = UIFont.preferredFont(forTextStyle: textStyle)
        uiTextView.autocapitalizationType = .sentences
        uiTextView.autocorrectionType = .no
        uiTextView.isSelectable = true
        uiTextView.isUserInteractionEnabled = true
        uiTextView.delegate = context.coordinator
        // this line looks weird..
        
        uiTextView.text += ""
        uiTextView.showsVerticalScrollIndicator = false
        uiTextView.tintColor = UIColor.textViewTintColor
        
        uiTextView.attributedText = NSAttributedString(string: uiTextView.text, attributes: [.font: UIFont.systemFont(ofSize: 28, weight: .bold)])
        
        uiTextView.keyboardDismissMode = .onDrag
        uiTextView.addDoneButtonOnKeyboard()
        return uiTextView
    }
    
     
    
    func something() {
        
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        print("updateUIView triggered")
        if didNotTriggerYet {
            //            uiView.text = text
            let attributedText = NSMutableAttributedString(
                string: text,
                attributes:
                    [.font: UIFont.preferredFont(forTextStyle: .body),
                     .foregroundColor: UIColor.memoTextColor])
            
            // cannot find any of \n
            
            if let firstIndex = text.firstIndex(of: "\n") {
                let distance = text.distance(from: text.startIndex, to: firstIndex)
                attributedText.addAttributes([
                    .font: UIFont.preferredFont(forTextStyle: .title1),
                    .foregroundColor: UIColor.memoTextColor],
                                             range: NSRange(location: 0, length: distance))
                print("distance: \(distance)")
            }
//            DispatchQueue.main.async {
//                uiView.attributedText = attributedText
//                didNotTriggerYet.toggle()
//            }
            let attrText = attrManager.convertTextIntoAttr(str: text)
//            attrManager.listMatches(for: "", inString: text)
            DispatchQueue.main.async {
                uiView.attributedText = attrText
                didNotTriggerYet.toggle()
            }
            
            // find matching pattern and update
//            attributedT

        }
    }
    
    
    final class Coordinator: NSObject, UITextViewDelegate {
        
        var text: Binding<String>
        
        init(_ text: Binding<String>) {
            self.text = text
        }
        
        func textViewDidChange(_ textView: UITextView) {
            
            print("textViewDidChange Triggered")
            
            DispatchQueue.main.async {
                self.text.wrappedValue = textView.text
            }
            
            let preAttributedRange: NSRange = textView.selectedRange
            
            
            // Set initial font .body
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
//                attributedText.addAttributes(m
//                    [.font: UIFont.preferredFont(forTextStyle: .title1),
//                     .foregroundColor: UIColor.memoTextColor],
//                    range: NSRange(location: 0, length: startToEndDistance))
//            }
            
            let attributedText = AttributedStringManager().convertTextIntoAttr(str: textView.text)
            
            let _ = AttributedStringManager().listMatches(for: "", inString: textView.text)
            
            textView.attributedText = attributedText
            
            textView.selectedRange = preAttributedRange
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
