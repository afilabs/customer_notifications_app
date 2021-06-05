
import Foundation
import UIKit
import SDWebImage

extension UIImageView {
    
    func setImageWithURL(url:String?,
                         placeHolderImage:UIImage? = nil,
                         maxWidth:CGFloat? = nil,
                         complateDownload:((UIImage?,Error?,CGSize? )-> Void)? = nil)  {
        
        if let _url = url {
//            SDWebImageDownloader.shared.setValue("Bearer \(E(Caches().token))",
//                                            forHTTPHeaderField: "Authorization")

            self.sd_setImage(with: URL(string: _url),
                             placeholderImage: placeHolderImage,
                             options: [.allowInvalidSSLCertificates ,
                                       .progressiveLoad,
                                       .continueInBackground,
                                       .retryFailed],
                             progress: nil) {(image, error, cacheType, url) in
                                var newSize = CGSize()
                                if let _image  = image{
                                    let sizeImage:CGSize = CGSize(width: _image.size.width, height: _image.size.height)
                                    
                                    var newWidth:CGFloat = 0.0;
                                    var newHeight:CGFloat = 0.0;
                                    let MAX_WIDTH = (maxWidth != nil) ? maxWidth! : ScreenSize.SCREEN_WIDTH

                                    newWidth = MIN(sizeImage.width, MAX_WIDTH)
                                    newHeight = (sizeImage.height / sizeImage.width) * newWidth;

                                    newSize = CGSize(width: newWidth, height: newHeight)
                                }
                                
                                complateDownload?(image,error,newSize)
                               
            }
            
        }else {
            self.image = placeHolderImage
        }
    }
}
