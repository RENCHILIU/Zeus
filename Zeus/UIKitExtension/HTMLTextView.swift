//
//  HTMLTextView.swift
//  Zeus
//
//  Created by Renchi Liu on 3/31/25.
//
import SwiftUI
import UIKit

struct HTMLTextView: UIViewRepresentable {
    let htmlContent: String
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.showsVerticalScrollIndicator = true
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        let styledHTML =
"""
<style>
    body {
        font-family: -apple-system;
        font-size: 16px;
        color: #333333;
    }
</style>
\(htmlContent)
"""
        
        DispatchQueue.main.async {
            if let data = styledHTML.data(using: .utf8) {
                let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ]
                if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
                    uiView.attributedText = attributedString
                }
            }
        }
    }
}
