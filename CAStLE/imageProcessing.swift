//
//  imageProcessing.swift
//  CAStLE
//
//  Created by Rafi Rizwan on 2/20/16.
//  Copyright © 2016 Firesquad. All rights reserved.
//

import Foundation
import UIKit
import TesseractOCR

class imageProcessing: NSObject {
    func performImageRecognition(image: UIImage) -> String {

        let tesseract = G8Tesseract(language: "eng")
        tesseract.engineMode = .TesseractCubeCombined
        tesseract.pageSegmentationMode = .Auto
        tesseract.maximumRecognitionTime = 120.0
        tesseract.image = image.g8_blackAndWhite()
        tesseract.recognize()
        
        return tesseract.recognizedText
    }
}
