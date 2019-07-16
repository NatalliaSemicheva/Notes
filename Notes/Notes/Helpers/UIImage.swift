//
//  UIImage.swift
//  Notes
//
//  Created by Natallia Semicheva on 7/12/19.
//  Copyright © 2019 Наталия Семичева. All rights reserved.
//

import UIKit

//extension UIImage {
//    func getPixelColor(point: CGPoint) -> UIColor {
//        guard let cgImage = cgImage else {
//            return .white
//        }
//        
//        let width = Int(size.width)
//        let height = Int(size.height)
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        
//        guard let context = CGContext(data: nil,
//                                      width: width,
//                                      height: height,
//                                      bitsPerComponent: 8,
//                                      bytesPerRow: width * 4,
//                                      space: colorSpace,
//                                      bitmapInfo: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)
//            else {
//                return .white
//        }
//        
//        context.draw(cgImage, in: CGRect(origin: .zero, size: size))
//        
//        guard let pixelBuffer = context.data else {
//            return .white
//        }
//        
//        let pointer = pixelBuffer.bindMemory(to: UInt32.self, capacity: width * height)
//        let pixel = pointer[Int(point.y) * width + Int(point.x)]
//        
//        let r: CGFloat = CGFloat(red(for: pixel))   / 255
//        let g: CGFloat = CGFloat(green(for: pixel)) / 255
//        let b: CGFloat = CGFloat(blue(for: pixel))  / 255
//        let a: CGFloat = CGFloat(alpha(for: pixel)) / 255
//        
//        return UIColor(red: r, green: g, blue: b, alpha: a)
//    }
//    
//    private func alpha(for pixelData: UInt32) -> UInt8 {
//        return UInt8((pixelData >> 24) & 255)
//    }
//    
//    private func red(for pixelData: UInt32) -> UInt8 {
//        return UInt8((pixelData >> 16) & 255)
//    }
//    
//    private func green(for pixelData: UInt32) -> UInt8 {
//        return UInt8((pixelData >> 8) & 255)
//    }
//    
//    private func blue(for pixelData: UInt32) -> UInt8 {
//        return UInt8((pixelData >> 0) & 255)
//    }
//    
//    private func rgba(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) -> UInt32 {
//        return (UInt32(alpha) << 24) | (UInt32(red) << 16) | (UInt32(green) << 8) | (UInt32(blue) << 0)
//    }
//}
