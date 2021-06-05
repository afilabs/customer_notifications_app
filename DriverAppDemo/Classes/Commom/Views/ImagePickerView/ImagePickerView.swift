
import UIKit
import Photos

typealias ImagePickerViewCallback = (_ success:Bool, _ data: UIImage?) -> Void

class ImagePickerView: UIImagePickerController {
    
    fileprivate var callback:ImagePickerViewCallback?
    static var imagePickerView:ImagePickerView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func shared() -> ImagePickerView  {
        if imagePickerView == nil {
            imagePickerView = ImagePickerView()
        }
        
        return imagePickerView!
    }
}

//MARK : - Support methods
extension ImagePickerView {
    func showImageGallaryOrCameraPicker(atVC:UIViewController ,
                                        buttomItem:UIView? = nil,
                                        callback:@escaping ImagePickerViewCallback){
        
        setCallback(callback);
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet);
        
        let actionGallery = UIAlertAction(title: "Album Gallery", style: .default) {[weak self] (action) in
            self?.getAllGallery(vc: atVC)
        }
        
        let actionCamera = UIAlertAction(title: "Take photo", style: .default) { (action) in
            self.getCamera(vc:atVC)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            //
        }
        
        alert.addAction(actionGallery);
        alert.addAction(actionCamera);
        alert.addAction(cancel);
        
        if let popoverController = alert.popoverPresentationController {
            
            let frame = atVC.view.convert(buttomItem?.bounds ?? CGRect.zero, from: buttomItem)
            popoverController.sourceView = atVC.view
            popoverController.sourceRect = frame
        }
        
        atVC.present(alert, animated: true, completion: nil)
        
    }
    
    func showImageGallary(atVC:UIViewController ,
                          buttomItem:UIView? = nil,
                          callback:@escaping ImagePickerViewCallback){
        
        setCallback(callback);
        self.getAllGallery(vc: atVC)
    }
    
    func showCameraOnly(atVC:UIViewController ,
                        callback:@escaping ImagePickerViewCallback){
        
        setCallback(callback);
        self.getCamera(vc:atVC)
    }
}


//MARK: - Fileprivate Funtion
extension ImagePickerView {
    fileprivate  func getAllGallery(vc:UIViewController)  {
        self.allowsEditing = true;
        self.delegate = self;
        self.sourceType = .photoLibrary;
        vc.present(self, animated: true, completion: nil)
    }
    
    fileprivate  func getCamera(vc:UIViewController)  {
        if !Platform.isSimulator {
            self.sourceType = .camera
            //self.allowsEditing = true
            self.delegate = self
            vc.present(self, animated: true, completion: nil)
        }else {
            print("Simulator is do not support!")
        }
    }
    
    fileprivate func setCallback(_ callback:@escaping ImagePickerViewCallback) {
        self.callback = callback;
    }
    
    fileprivate func getAssetThumbnail(asset: PHAsset, size: CGFloat) -> UIImage {
        let retinaScale = UIScreen.main.scale
        let retinaSquare = CGSize(width: size * retinaScale, height: size * retinaScale)
        
        let cropSizeLength = min(asset.pixelWidth, asset.pixelHeight)
        let square = CGRect(x: 0, y: 0, width: CGFloat(cropSizeLength), height:  CGFloat(cropSizeLength))
        
        let cropRect = square.applying(CGAffineTransform(scaleX: 1.0/CGFloat(asset.pixelWidth), y: 1.0/CGFloat(asset.pixelHeight)))
        
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        var thumbnail = UIImage()
        
        options.isSynchronous = true
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        options.normalizedCropRect = cropRect
        
        manager.requestImage(for: asset, targetSize: retinaSquare, contentMode: .aspectFit, options: options, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
}


//MARK: - UIImagePickerControllerDelegate,UINavigationControllerDelegate
extension ImagePickerView:UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //print(info)
        if  let image = info[UIImagePickerController.InfoKey.originalImage]{
            picker.dismiss(animated: true) {[weak self] in
                self?.handleComplationPickImage(data: image)
            }
        }
    }
    
    func handleComplationPickImage(data:Any?) {
        if let image = data as? UIImage {
            self.callback?(true,image)
            
        }else {
                self.callback?(false, nil)
                print("Invalid data.")
        }
    }
}

