//
//  UIImage+features.swift
//  PhotoEraser
//
//  Created by Kazi Muhammad Tawsif Jamil on 11/6/21.
//

import Foundation
import UIKit

extension UIImage {

    func saveToDocuments(filename:String) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        if let data = self.jpegData(compressionQuality: 1.0) {
            do {
                try data.write(to: fileURL)
            } catch {
                print("error saving file to documents:", error)
            }
        }
    }
    
    func getFromDocuments(filename:String) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        
    }
    
    func rotated(byDegrees degrees: CGFloat) -> UIImage? {
        // 1. Convert degrees to radians
        let radians = degrees * .pi / 180
        
        // 2. Calculate the bounding size required for the rotated canvas
        let rotatingRect = CGRect(origin: .zero, size: self.size)
        let transform = CGAffineTransform(rotationAngle: radians)
        let rotatedRect = rotatingRect.applying(transform)
        
        // 3. Create the renderer format matching the original image attributes
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = self.scale
        
        let renderer = UIGraphicsImageRenderer(size: rotatedRect.size, format: format)
        
        // 4. Draw into the new context centered around the pivot point
        let newImage = renderer.image { context in
            let cgContext = context.cgContext
            
            // Move origin to the absolute center of the canvas
            cgContext.translateBy(x: rotatedRect.width / 2, y: rotatedRect.height / 2)
            // Apply canvas rotation
            cgContext.rotate(by: radians)
            
            // Draw image mirrored vertically because Core Graphics relies on a flipped Y-axis layout
            cgContext.scaleBy(x: 1.0, y: -1.0)
            
            let drawRect = CGRect(
                x: -self.size.width / 2,
                y: -self.size.height / 2,
                width: self.size.width,
                height: self.size.height
            )
            
            if let cgImage = self.cgImage {
                cgContext.draw(cgImage, in: drawRect)
            }
        }
        
        return newImage
    }
}

