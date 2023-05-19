//
//  MyModel.swift
//  macos_Camera
//
//  Created by Peter Rogers on 15/05/2023.
//

import Foundation
import Vision
import AppKit

@MainActor class MyModel: ObservableObject, SerialPortDelegate, JSONDelegate{
    func didReceiveJSON(_ data: String) {
      
        doThatThing(inString: data)
        arduino.sendData(string: "b")
    }
    
    func didReceiveData(_ data: String) {
       
        
        
        if(sentence.isLoading == false){
            sentence.generateSentence(qrcodes: score)
            sentence.makeQuery(myQuery: sentence.sentences)
            arduino.sendData(string: "a")
            
        }
       
    }
    
    @Published var sentence = SentenceCreator()
    @Published var score:[VNBarcodeObservation] = []
    var arduino = ArduinoConnector()
    init(){
        arduino.delegate = self
        sentence.delegate = self
    }
    
    func doThatThing(inString:String){
        let paragraphStyle = NSMutableParagraphStyle()
        //paragraphStyle.lineBreakMode = .byCharWrapping
        paragraphStyle.alignment = .left
        paragraphStyle.hyphenationFactor = 0.0
        paragraphStyle.lineSpacing = 0.0
        paragraphStyle.maximumLineHeight = 12.0
        paragraphStyle.lineHeightMultiple = 0.0
        paragraphStyle.paragraphSpacing = 0.0
//        let tin = "Once upon a time, there was a desolate place where no one wanted to live. It was filled with abandoned cars, rusty pipes, and broken buildings. The only sign of life was the occasional bird flying overhead.\n\nBut one day, something strange happened. Like fireworks, birds exploded in a dance of grace amidst the chaos. They swooped and swirled, picking up old bombs and defusing them with care. The people who lived nearby were amazed and grateful.\n\nThe birds became heroes, and everyone wanted to know more about them. Why were they brave enough to help the people in that desolate place? Where did they come from, and how did they learn to defuse bombs?\n\nThe people searched high and low, but they couldn't find any answers. They asked the birds, but they simply chirped and flew away. The mystery only deepened, and everyone was left wondering.\n\nYears went by, and the birds continued to defuse bombs and save lives. They had become a symbol of hope and courage in that desolate place. And even though no one knew their secrets, everyone felt grateful that they were there.\n\nEventually, the birds flew away, leaving behind only memories and a ghostly reminder of a once-joyous place. But the people never forgot what they had done, and they hoped that one day the birds would return and reveal their secrets.\n\nThe end."
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 8),
            .paragraphStyle: paragraphStyle
        ]
        let textView = NSTextView(frame: NSRect(x: 0, y: 0, width: 300, height: 10))
        
        let breakString = createStringWithNewLines(text: inString)
        //let breakString = createStringWithNewLines(text: tin)
        // Set the text and other properties
        let attributedString = NSAttributedString(string: breakString, attributes: attributes)

        textView.textStorage?.setAttributedString(attributedString)
    

        let printInfo = NSPrintInfo.shared
        print(printInfo.paperSize.height)
        let paperSize = NSMakeSize(300, printInfo.paperSize.height) // Set width to 80 points
              printInfo.paperSize = paperSize
       // printInfo.isHorizontallyCentered = true
       
        printInfo.leftMargin = 4
        //printInfo.topMargin = 100
        printInfo.isVerticallyCentered = false
        print(NSPrinter.printerNames)
        let printOperation = NSPrintOperation(view: textView, printInfo: printInfo)
        printOperation.showsPrintPanel = false
        
        printOperation.run()
        
    }
    
    func createStringWithNewLines(text: String) -> String {
        var result = ""
        var currentLineLength = 0
        let replacedString = text.replacingOccurrences(of: "\n\n", with: " \n")
        let words = replacedString.components(separatedBy: .whitespaces)
        
        for word in words {
            let wordLength = word.count
           
            if !result.isEmpty {
                result += " "  // Add a space between words
                currentLineLength += 1
            }
            
           
            if(word.contains("\n") || currentLineLength + wordLength > 45){
                result += "\n"  // Add a new line
                currentLineLength = 0
            }
           
           
            result += word
            currentLineLength += wordLength
            
        }
        result+="\n\n\n..."
        return result
    }
    
    
    func removeLeadingNewlines(from string: String) -> String {
        let pattern = "^\\n+"
        let regex = try! NSRegularExpression(pattern: pattern)
        
        let range = NSRange(location: 0, length: string.utf16.count)
        let modifiedString = regex.stringByReplacingMatches(
            in: string,
            options: [],
            range: range,
            withTemplate: ""
        )
        
        return modifiedString
    }
    
}
