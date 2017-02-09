//
//  PhotoPickerViewController.swift
//  My Last Run
//
//  Created by Mike Mariano on 1/27/17.
//  Copyright © 2017 Mike Mariano. All rights reserved.
//

import UIKit

class PhotoPickerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // reference the Image
    @IBOutlet weak var photoImageView: UIImageView!
    
    var passedImage: UIImage!
    
    @IBOutlet weak var PhotoView: UIView!
    // reference the text fields
    @IBOutlet weak var PhotoTitle: UITextField!
    @IBOutlet weak var PhotoDistance: UITextField!
    @IBOutlet weak var PhotoLocation: UITextField!
    @IBOutlet weak var PhotoMonth: UITextField!
    @IBOutlet weak var PhotoDay: UITextField!
    @IBOutlet weak var PhotoYear: UITextField!
    @IBOutlet weak var PhotoWeatherIcon: UIImageView!
    @IBOutlet weak var PhotoDegrees: UITextField!
    @IBOutlet weak var PhotoDuration: UITextField!
    @IBOutlet weak var PhotoPace: UITextField!
    
    // create variables for the text fields to display
    var userTitleText:String! = ""
    var userDistanceText:String! = ""
    var userDistanceChoice:String! = ""
    var userLocationText:String! = ""
    var userDate:String! = ""
    var userMonth:String! = ""
    var userDay:String! = ""
    var userYear:String! = ""
    var userDegrees:String! = ""
    var userWeatherIcon:String! = ""
    var userDuration:String! = ""
    var userPace:String! = ""
    
    // reference the navigation bar
    var navigationBarAppearace = UINavigationBar.appearance()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // set the title of the view
        navigationItem.title = "PREVIEW"
        
        // set the text fields to the variables
        PhotoTitle.text = userTitleText
        PhotoDistance.text = userDistanceText + " " + userDistanceChoice
        PhotoLocation.text = userLocationText
        PhotoDay.text = userDay
        PhotoMonth.text = userMonth.uppercased()
        PhotoYear.text = userYear
        PhotoDegrees.text = userDegrees + "°"
        PhotoDuration.text = userDuration
        PhotoPace.text = userPace
        
        photoImageView.image = passedImage
        passedImage = resizeImage(image: passedImage, targetSize: CGSize.init(width: 2048, height: 2048))
        
        if(userWeatherIcon == "Sunny"){
            guard let image = passedImage, let cgimg = image.cgImage else {
                print("imageView doesn't have an image!")
                return
            }
            
            guard let imageFilter = UIImage(named: "filter_sun"), let cgimgFilter = imageFilter.cgImage else {
                print("imageView doesn't have an image!")
                return
            }
            print(cgimg.height)
            //print(cgimg.width)
            
            print(cgimgFilter.height)
            
            let openGLContext = EAGLContext(api: .openGLES2)
            let context = CIContext(eaglContext: openGLContext!)
            
            let coreImage = CIImage(cgImage: cgimg)
            let coreImageFilter = CIImage(cgImage: cgimgFilter)
            
            let overlayFilter = CIFilter(name: "CIOverlayBlendMode")
            overlayFilter?.setValue(coreImageFilter, forKey: kCIInputBackgroundImageKey)
            overlayFilter?.setValue(coreImage, forKey: kCIInputImageKey)
            
            if let overlayOutput = overlayFilter?.value(forKey: kCIOutputImageKey) as? CIImage {
                let exposureFilter = CIFilter(name: "CIExposureAdjust")
                exposureFilter?.setValue(overlayOutput, forKey: kCIInputImageKey)
                exposureFilter?.setValue(1, forKey: kCIInputEVKey)
                
                if let exposureOutput = exposureFilter?.value(forKey: kCIOutputImageKey) as? CIImage {
                    let output = context.createCGImage(overlayOutput, from: exposureOutput.extent)
                    let result = UIImage(cgImage: output!)
                    photoImageView?.image = result
                }
            }

            PhotoWeatherIcon.image = #imageLiteral(resourceName: "IconSunny")
        } else if(userWeatherIcon == "Partly Cloudy"){
            PhotoWeatherIcon.image = #imageLiteral(resourceName: "IconLightClouds")
        } else if(userWeatherIcon == "Cloudy"){
            PhotoWeatherIcon.image = #imageLiteral(resourceName: "IconCloudy")
            guard let image = photoImageView?.image, let cgimg = image.cgImage else {
                print("imageView doesn't have an image!")
                return
            }
            
            let openGLContext = EAGLContext(api: .openGLES2)
            let context = CIContext(eaglContext: openGLContext!)
            
            let coreImage = CIImage(cgImage: cgimg)
            
            let sepiaFilter = CIFilter(name: "CISepiaTone")
            sepiaFilter?.setValue(coreImage, forKey: kCIInputImageKey)
            sepiaFilter?.setValue(1, forKey: kCIInputIntensityKey)
            
            if let sepiaOutput = sepiaFilter?.value(forKey: kCIOutputImageKey) as? CIImage {
                let exposureFilter = CIFilter(name: "CIExposureAdjust")
                exposureFilter?.setValue(sepiaOutput, forKey: kCIInputImageKey)
                exposureFilter?.setValue(1, forKey: kCIInputEVKey)
                
                if let exposureOutput = exposureFilter?.value(forKey: kCIOutputImageKey) as? CIImage {
                    let output = context.createCGImage(exposureOutput, from: exposureOutput.extent)
                    let result = UIImage(cgImage: output!)
                    photoImageView?.image = result
                }
            }
        } else if(userWeatherIcon == "Raining"){
            PhotoWeatherIcon.image = #imageLiteral(resourceName: "IconRain")
        } else if(userWeatherIcon == "Snowing"){
            PhotoWeatherIcon.image = #imageLiteral(resourceName: "IconSnow")
        }
        
        
    }
    
    
    @IBAction func SaveToCamaraRoll(_ sender: UIButton) {
        //saveImage()
        shareImage()
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
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
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func saveImage() {
        //Create the UIImage
        //UIGraphicsBeginImageContext(PhotoView.frame.size)
        UIGraphicsBeginImageContextWithOptions(PhotoView.frame.size, false, UIScreen.main.scale)
        PhotoView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Save it to the camera roll
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
    }
    
    func shareImage() {
        // image to share
        //let image = UIImage(named: "Image")
        
        //Create the UIImage
        //UIGraphicsBeginImageContext(PhotoView.frame.size)
        UIGraphicsBeginImageContextWithOptions(PhotoView.frame.size, false, UIScreen.main.scale)
        PhotoView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // set up activity view controller
        let imageToShare = [ image! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        //activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func image(image: UIImage!, didFinishSavingWithError error: NSError!, contextInfo: AnyObject!) {
        if (error != nil) {
            // Something wrong happened.
        } else {
            let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func seletImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = true //or true additional setup required.
        
        self.present(image, animated: true, completion: nil)
    }
    

    
    @IBAction func backToStats(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "unwindToStats", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openCameraButton(sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
