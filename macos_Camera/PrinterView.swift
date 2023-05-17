//
//  PrinterView.swift
//  macos_Camera
//
//  Created by Peter Rogers on 16/05/2023.
//

import Foundation
import Cocoa

class PrinterView: NSView {
    var text: String = "" {
        didSet {
            // Call setNeedsDisplay to trigger a redraw when the text is updated
            setNeedsDisplay(bounds)
        }
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Draw the text onto the view
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 10),
            .foregroundColor: NSColor.black
        ]
        let attributedString = NSAttributedString(string: text, attributes: textAttributes)
        print("foofoo")
        print(dirtyRect.height)
        print(dirtyRect.midY)
        attributedString.draw(at: NSPoint(x: 0, y: dirtyRect.height-300))
    }
}
