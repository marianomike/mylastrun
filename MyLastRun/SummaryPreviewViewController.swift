//
//  SummaryPreviewViewController.swift
//  My Last Run
//
//  Created by Mike Mariano on 4/1/17.
//  Copyright © 2017 Mike Mariano. All rights reserved.
//

import UIKit

class SummaryPreviewViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet var MileageView: UIView!
    @IBOutlet var dragMileage: UIPanGestureRecognizer!
    @IBOutlet weak var PhotoSummary: UIImageView!
    @IBOutlet weak var PhotoImage: UIView!
    
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
    
    var passedImage: UIImage!
    
    // reference the navigation bar
    var navigationBarAppearace = UINavigationBar.appearance()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        
        // set the title of the view
        navigationItem.title = "PREVIEW"

        // Do any additional setup after loading the view.
        
        if(passedImage != nil){
            PhotoSummary.image = passedImage
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dragMileage(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        
        sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
        
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
    func shareImage() {
        
        UIGraphicsBeginImageContextWithOptions(PhotoImage.frame.size, false, UIScreen.main.scale)
        PhotoImage.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let imageSize = CGSize(width: 2048, height: 2048)
        let resizedImage = resizeImage(image: image!, targetSize: imageSize)
        
        
        // set up activity view controller
        let imageToShare = [ resizedImage ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        //activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
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
    
    @IBAction func ShareImage(_ sender: UIButton) {
        shareImage()
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
