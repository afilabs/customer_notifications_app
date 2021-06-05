

import Foundation
import UIKit

extension UIImage{
    func getPixelColor(point: CGPoint) -> UIColor {
        
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let pixelInfo: Int = ((Int(self.size.width) * Int(point.y)) + Int(point.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color1.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func encodeToBase64String(quality:CGFloat = 0.7) -> String? {
        let imageData = self.jpegData(compressionQuality: quality)
        let strBase64 = imageData?.base64EncodedString(options: .lineLength64Characters)
        return strBase64
    }
    
    func resizeImage(targetSize: CGSize) -> UIImage {
           let size = self.size

           let widthRatio  = targetSize.width  / size.width
           let heightRatio = targetSize.height / size.height

           // Figure out what our orientation is, and use that to form the rectangle
           var newSize: CGSize
           if(widthRatio > heightRatio) {
               newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
           } else {
               newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
           }

           // This is the rect that we've calculated out and this is what is actually used below
           let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

           // Actually do the resizing to the rect using the ImageContext stuff
           UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
           self.draw(in: rect)
           let newImage = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()

           return newImage!
       }
       
       func imageWithImage (sourceImage:UIImage, scaledToWidth: CGFloat) -> UIImage {
           let oldWidth = sourceImage.size.width
           let scaleFactor = scaledToWidth / oldWidth

           let newHeight = sourceImage.size.height * scaleFactor
           let newWidth = oldWidth * scaleFactor

           UIGraphicsBeginImageContext(CGSize(width:newWidth, height:newHeight))
           sourceImage.draw(in: CGRect(x:0, y:0, width:newWidth, height:newHeight))
           let newImage = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()
           return newImage!
       }
    
        func fixImageOrientation()->UIImage {
            UIGraphicsBeginImageContext(self.size)
            self.draw(at: .zero)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage ?? self
        }
    
    func fixedImageOrientation() -> UIImage? {
        
        guard imageOrientation != UIImage.Orientation.up else {
            //This is default orientation, don't need to do anything
            return self.copy() as? UIImage
        }
        
        guard let cgImage = self.cgImage else {
            //CGImage is not available
            return nil
        }

        guard let colorSpace = cgImage.colorSpace, let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil //Not able to create CGContext
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
            break
        default:
            break
        }
        
        //Flip image one more time if needed to, this is to prevent flipped image
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }
        
        guard let newCGImage = ctx.makeImage() else { return nil }
        return UIImage.init(cgImage: newCGImage, scale: 1, orientation: .up)
    }
}
