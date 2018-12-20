//
//  UIImage+ReSize.swift
//
//  Created by Rupesh Kumar on 10/19/15.
//  Copyright © 2015 Rupesh Kumar. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {
    
    // Returns a copy of this image that is cropped to the given bounds.
    // The bounds will be adjusted using CGRectIntegral.
    // This method ignores the image's imageOrientation setting.
    func croppedImage(bounds: CGRect) -> UIImage
    {
        let imageRef: CGImage = self.cgImage!.cropping(to: bounds)!
        let croppedImage: UIImage = UIImage(cgImage:imageRef)
        return croppedImage
    }
    
    // Returns a rescaled copy of the image, taking into account its orientation
    // The image will be scaled disproportionately if necessary to fit the bounds specified by the parameter
    func resizedImage(newSize: CGSize, interpolationQuality quality: CGInterpolationQuality) -> UIImage
    {
        var drawTransposed: Bool
        switch self.imageOrientation
        {
        case UIImageOrientation.left,UIImageOrientation.leftMirrored,UIImageOrientation.right,UIImageOrientation.rightMirrored:
            drawTransposed = true
        default:
            drawTransposed = false
        }
        return self.resizedImage(newSize: newSize, transform: self.transformForOrientation(newSize: newSize), drawTransposed: drawTransposed, interpolationQuality: quality)
    }
    
    // Resizes the image according to the given content mode, taking into account the image's orientation
    func resizedImageWithContentMode(contentMode: UIViewContentMode, bounds: CGSize, interpolationQuality quality: CGInterpolationQuality) -> UIImage
    {
        let horizontalRatio: CGFloat = bounds.width / self.size.width
        let verticalRatio: CGFloat = bounds.height / self.size.height
        var ratio: CGFloat = 0
        let error: NSError = NSError.init(domain: "Error", code: 0, userInfo: nil)

        switch contentMode
        {
        case UIViewContentMode.scaleAspectFill:
            ratio = max(horizontalRatio, verticalRatio)
        case UIViewContentMode.scaleAspectFit:
            ratio = min(horizontalRatio, verticalRatio)
        default:
            NSException.raise(NSExceptionName.invalidArgumentException, format: "Unsupported content mode: \(contentMode)", arguments: getVaList([error]))
        }
        let newSize: CGSize = CGSize(width: self.size.width * ratio, height: self.size.height * ratio)
        return self.resizedImage(newSize: newSize, interpolationQuality: quality)
    }
    
    /**
     scale an image to a new size and still keep ratio of image
     */
    func scaleImageWithSize(size:CGSize, displayMode mode:UIViewContentMode = UIViewContentMode.scaleAspectFit) -> UIImage
    {
        return self.resizedImageWithContentMode(contentMode: mode, bounds: size, interpolationQuality: CGInterpolationQuality.high)
    }
    
    
    // Returns a copy of the image that has been transformed using the given affine transform and scaled to the new size
    // The new image's orientation will be UIImageOrientationUp, regardless of the current image's orientation
    // If the new size is not integral, it will be rounded up
    private func resizedImage(newSize: CGSize, transform: CGAffineTransform, drawTransposed transpose: Bool, interpolationQuality quality: CGInterpolationQuality) -> UIImage
    {
        let newRect: CGRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        let transposedRect: CGRect = CGRect(x: 0, y: 0, width: newRect.size.height, height: newRect.size.width)
        let imageRef: CGImage = self.cgImage!

        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        
        // Build a context that's the same dimensions as the new size
        let bitmap: CGContext = CGContext(data: nil, width: Int(newRect.size.width), height: Int(newRect.size.height), bitsPerComponent: imageRef.bitsPerComponent, bytesPerRow: 0, space: imageRef.colorSpace!,bitmapInfo: bitmapInfo.rawValue)!
        
        // Rotate and/or flip the image if required by its orientation
        bitmap.concatenate(transform)
        
        // Set the quality level to use when rescaling
        bitmap.interpolationQuality = quality
        
        // Draw into the context; this scales the image
//        CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef)
        bitmap.draw(imageRef, in: transpose ? transposedRect : newRect)
        // Get the resized image from the context and a UIImage
        let newImageRef: CGImage = bitmap.makeImage()!
        let newImage: UIImage = UIImage(cgImage:newImageRef)
        
        return newImage
    }
    
    // Returns an affine transform that takes into account the image orientation when drawing a scaled image
   private func transformForOrientation(newSize: CGSize) -> CGAffineTransform
    {
        var transform: CGAffineTransform = CGAffineTransform.identity
        switch self.imageOrientation
        {
        case UIImageOrientation.down,UIImageOrientation.downMirrored:
            transform = transform.translatedBy(x: newSize.width, y: newSize.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
            break;
            
        case UIImageOrientation.left,UIImageOrientation.leftMirrored:
            transform = transform.translatedBy(x: newSize.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi/2))
            break;
            
        case UIImageOrientation.right,UIImageOrientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: newSize.height)
            transform = transform.rotated(by: -CGFloat(Double.pi/2))
            break;
            
        default:
            break;
        }
        
        switch self.imageOrientation
        {
        case UIImageOrientation.upMirrored,UIImageOrientation.downMirrored:
            transform = transform.translatedBy(x: newSize.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break;
            
        case UIImageOrientation.leftMirrored,UIImageOrientation.rightMirrored:
            transform = transform.translatedBy(x: newSize.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break;
            
        default:
            break;
        }
        
        return transform
    }

}
