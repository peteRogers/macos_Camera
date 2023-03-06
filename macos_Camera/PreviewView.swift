//
//  PreviewView.swift
//  Image_Pixelator
//
//  Created by Peter Rogers on 06/03/2023.
//

import Cocoa
import AVFoundation

class PreviewView: NSView {
    
    
    
     
      var previewLayer: AVCaptureVideoPreviewLayer {
        // swiftlint:disable:next force_cast
        layer as! AVCaptureVideoPreviewLayer
      }

    
    


}
