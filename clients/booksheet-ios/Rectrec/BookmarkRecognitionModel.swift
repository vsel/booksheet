//
//  BookmarkRecognitionModel.swift
//  Rectrec
//
//  Created by Volodymyr Selyukh on 21.03.15.
//  Copyright (c) 2015 D4F. All rights reserved.
//

import Foundation
import UIKit
import GPUImage

class BookmarkRecognition {
    
    var image: UIImage
    
    init(image: UIImage) {
        //old tesseract filter
        //self.image = image.g8_blackAndWhite()
        
        //new GPUImage Filter
        let startTestDate = NSDate()
        //TESSERACT OFFICIAL BEST PRACTICE
        //let filter = GPUImageAdaptiveThresholdFilter()
        //filter.blurRadiusInPixels = 4.0
        //MY OWN OFFICIAL BEST PRACTISE
        let filter = GPUImageLuminanceThresholdFilter()
        filter.threshold = 0.39
        filter.useNextFrameForImageCapture()
        let picture = GPUImagePicture(image: image)
        picture.addTarget(filter)
        picture.processImage()
        println(image.size)
        println(NSDate().timeIntervalSinceDate(startTestDate))
        self.image = filter.imageFromCurrentFramebuffer()
        
        //no filter
        //self.image = image
}

    func detectFromRectangle(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> String {
        // TODO: Implement function
        let testRect = CGRect(x: x, y: y, width: width, height: height)
        let tesseract = G8Tesseract()
        tesseract.language = "eng"
        //tesseract.engineMode = .TesseractCubeCombined
        tesseract.engineMode = .TesseractOnly
        tesseract.charBlacklist = "-_"
        //tesseract.engineMode = .CubeOnly
        //tesseract.pageSegmentationMode = .SparseTextOSD
        tesseract.maximumRecognitionTime = 600.0
        //Time Test Start
        //let startTestDate = NSDate()
        tesseract.image = self.image
        tesseract.recognize()
        let allText = tesseract.recognizedText
        print(allText)
        tesseract.rect = testRect
        tesseract.recognize()
        let rectText = tesseract.recognizedText
        print("this is the rect text \(rectText)")
        //Time Test End
        //println(NSDate().timeIntervalSinceDate(startTestDate))
        return rectText
    }

    
    
}