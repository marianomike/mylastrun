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
    var currentLayout = 1
    
    @IBOutlet weak var PhotoView: UIView!
    @IBOutlet weak var Layout1: UIView!
    @IBOutlet weak var Layout2: UIView!
    @IBOutlet weak var Layout3: UIView!
    @IBOutlet weak var Layout4: UIView!
    @IBOutlet weak var Layout5: UIView!
    @IBOutlet weak var Layout6: UIView!
    @IBOutlet weak var Layout7: UIView!
    
    
    @IBOutlet weak var btnLayout1: UIButton!
    @IBOutlet weak var btnLayout2: UIButton!
    @IBOutlet weak var btnLayout3: UIButton!
    @IBOutlet weak var btnLayout4: UIButton!
    @IBOutlet weak var btnLayout5: UIButton!
    @IBOutlet weak var btnLayout6: UIButton!
    @IBOutlet weak var btnLayout7: UIButton!
    
    
    // Layout 1
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
    
    // Layout 2
    @IBOutlet weak var PhotoTitle2: UITextField!
    @IBOutlet weak var PhotoDistance2: UITextField!
    @IBOutlet weak var PhotoLocation2: UITextField!
    @IBOutlet weak var PhotoDate2: UITextField!
    @IBOutlet weak var PhotoWeatherIcon2: UIImageView!
    @IBOutlet weak var PhotoDuration2: UITextField!
    @IBOutlet weak var PhotoPace2: UITextField!
    
    // Layout 3
    @IBOutlet weak var PhotoTitle3: UITextField!
    @IBOutlet weak var PhotoDistance3: UITextField!
    @IBOutlet weak var PhotoMetrics3: UITextField!
    @IBOutlet weak var PhotoDate3: UITextField!
    @IBOutlet weak var PhotoDuration3: UITextField!
    @IBOutlet weak var PhotoPace3: UITextField!
    @IBOutlet weak var PhotoLocation3: UITextField!
    
    // Layout 4
    @IBOutlet weak var PhotoTitle4: UITextField!
    @IBOutlet weak var PhotoDistance4: UITextField!
    @IBOutlet weak var PhotoDate4: UITextField!
    @IBOutlet weak var PhotoTime4: UITextField!
    @IBOutlet weak var PhotoLocation4: UITextField!
    
    // Layout 5
    @IBOutlet weak var PhotoTitle5: UITextField!
    @IBOutlet weak var PhotoDistance5: UITextField!
    @IBOutlet weak var PhotoDate5: UITextField!
    @IBOutlet weak var PhotoTime5: UITextField!
    @IBOutlet weak var PhotoLocation5: UITextField!
    
    // Layout 6
    @IBOutlet weak var PhotoLocation6: UITextField!
    @IBOutlet weak var PhotoDate6: UITextField!
    @IBOutlet weak var PhotoTime6: UITextField!
    @IBOutlet weak var PhotoTitle6: UITextField!
    @IBOutlet weak var PhotoDistance6: UITextField!
    
    // Layout 7
    @IBOutlet weak var PhotoLocation7: UITextField!
    @IBOutlet weak var PhotoDate7: UITextField!
    @IBOutlet weak var PhotoTitle7: UITextField!
    @IBOutlet weak var PhotoDistance7: UITextField!
    @IBOutlet weak var PhotoMetrics7: UITextField!
    @IBOutlet weak var PhotoTime7: UITextField!
    @IBOutlet weak var PhotoPace7: UITextField!
    
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
        
        navigationController?.delegate = self
        
        //hide layouts
        hideLayouts()
        
        // set the title of the view
        navigationItem.title = "PREVIEW"
        
        // populate layout 1 text
        // set the text fields to the variables
        PhotoTitle.text = userTitleText
        PhotoDistance.text = userDistanceText + " " + userDistanceChoice
        PhotoLocation.text = userLocationText
        PhotoDay.text = userDay
        PhotoMonth.text = userMonth.uppercased()
        PhotoYear.text = userYear
        if(userDegrees == ""){
            PhotoDegrees.text = ""
        }else{
            PhotoDegrees.text = userDegrees + "°"
        }
        PhotoDuration.text = userDuration
        PhotoPace.text = userPace
        
        // populate layout 2
        PhotoTitle2.text = userTitleText.uppercased()
        if(userTitleText == ""){
            PhotoTitle2.alpha = 0
        }
        PhotoDistance2.text = userDistanceText + " " + userDistanceChoice
        PhotoLocation2.text = userLocationText
        PhotoDate2.text = userMonth + " " + userDay + ", " + userYear
        PhotoDuration2.text = userDuration
        PhotoPace2.text = userPace
        
        // populate layout 3
        PhotoTitle3.text = userTitleText.uppercased()
        PhotoDistance3.text = userDistanceText
        PhotoLocation3.text = userLocationText
        PhotoDate3.text = userMonth + " " + userDay + ", " + userYear
        PhotoDuration3.text = userDuration
        PhotoPace3.text = userPace
        
        if(userDistanceChoice == "Miles"){
            PhotoMetrics3.text = "M"
        }else if(userDistanceChoice == "Kilometers"){
            PhotoMetrics3.text = "K"
        }
        
        
        // populate layout 4
        PhotoTitle4.text = userTitleText.uppercased()
        PhotoDistance4.text = userDistanceText + " " + userDistanceChoice
        PhotoLocation4.text = userLocationText
        PhotoDate4.text = userMonth + " " + userDay + ", " + userYear
        PhotoTime4.text = "Duration: " + userDuration + "・" + "Pace: " + userPace
        
        // populate layout 5
        PhotoTitle5.text = userTitleText
        if(userDistanceChoice == "Miles"){
            PhotoDistance5.text = userDistanceText + " M"
        }else if(userDistanceChoice == "Kilometers"){
            PhotoDistance5.text = userDistanceText + " K"
        }
        PhotoLocation5.text = userLocationText
        PhotoDate5.text = userMonth + " " + userDay + ", " + userYear
        PhotoTime5.text = "Duration: " + userDuration + "・" + "Pace: " + userPace
        
        // populate layout 6
        PhotoTitle6.text = userTitleText
        if(userDistanceChoice == "Miles"){
            PhotoDistance6.text = userDistanceText + " M"
        }else if(userDistanceChoice == "Kilometers"){
            PhotoDistance6.text = userDistanceText + " K"
        }
        PhotoLocation6.text = userLocationText
        PhotoDate6.text = userMonth + " " + userDay + ", " + userYear
        PhotoTime6.text = "Duration: " + userDuration + "・" + "Pace: " + userPace
        
        // populate layout 7
        PhotoTitle7.text = userTitleText
        if(userDistanceChoice == "Miles"){
            PhotoMetrics7.text = "M"
        }else if(userDistanceChoice == "Kilometers"){
            PhotoMetrics7.text = "K"
        }
        PhotoDistance7.text = userDistanceText
        PhotoLocation7.text = userLocationText
        PhotoDate7.text = userMonth + " " + userDay + ", " + userYear
        PhotoTime7.text = userDuration
        PhotoPace7.text = userPace
        
        
        //print(passedImage.size.width)
        //print(passedImage.size.height)
        //passedImage = resizeImage(image: passedImage, targetSize: CGSize.init(width: 3072, height: 3072))
        if(passedImage != nil){
            photoImageView.image = passedImage
        }
        
        if(currentLayout == 1){
            Layout1.alpha = 1
            currentLayout = 1
            btnLayout1.isSelected = true
        }else if(currentLayout == 2){
            Layout2.alpha = 1
            currentLayout = 2
            btnLayout2.isSelected = true
        }else if(currentLayout == 3){
            Layout3.alpha = 1
            currentLayout = 3
            btnLayout3.isSelected = true
        }else if(currentLayout == 4){
            Layout4.alpha = 1
            currentLayout = 4
            btnLayout4.isSelected = true
        }else if(currentLayout == 5){
            Layout5.alpha = 1
            currentLayout = 5
            btnLayout5.isSelected = true
        }else if(currentLayout == 6){
            Layout6.alpha = 1
            currentLayout = 6
            btnLayout6.isSelected = true
        }else if(currentLayout == 7){
            Layout7.alpha = 1
            currentLayout = 7
            btnLayout7.isSelected = true
        }
        
        // set weather icons
        if(userWeatherIcon == "None"){
            PhotoWeatherIcon.image = nil
            PhotoWeatherIcon2.image = nil

        } else if(userWeatherIcon == "Sunny"){
            PhotoWeatherIcon.image = #imageLiteral(resourceName: "IconSunny")
            PhotoWeatherIcon2.image = #imageLiteral(resourceName: "IconSunny")
        } else if(userWeatherIcon == "Partly Cloudy"){
            PhotoWeatherIcon.image = #imageLiteral(resourceName: "IconLightClouds")
            PhotoWeatherIcon2.image = #imageLiteral(resourceName: "IconLightClouds")
        } else if(userWeatherIcon == "Cloudy"){
            PhotoWeatherIcon.image = #imageLiteral(resourceName: "IconCloudy")
            PhotoWeatherIcon2.image = #imageLiteral(resourceName: "IconCloudy")
        } else if(userWeatherIcon == "Raining"){
            PhotoWeatherIcon.image = #imageLiteral(resourceName: "IconRain")
            PhotoWeatherIcon2.image = #imageLiteral(resourceName: "IconRain")
        } else if(userWeatherIcon == "Snowing"){
            PhotoWeatherIcon.image = #imageLiteral(resourceName: "IconSnow")
            PhotoWeatherIcon2.image = #imageLiteral(resourceName: "IconSnow")
        }
        
    }
    
    
    @IBAction func SaveToCamaraRoll(_ sender: UIButton) {
        //saveImage()
        shareImage()
    }
    
    func hideLayouts(){
        Layout1.alpha = 0
        Layout2.alpha = 0
        Layout3.alpha = 0
        Layout4.alpha = 0
        Layout5.alpha = 0
        Layout6.alpha = 0
        Layout7.alpha = 0
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
    
    func deselectButtons(){
        btnLayout1.isSelected = false
        btnLayout2.isSelected = false
        btnLayout3.isSelected = false
        btnLayout4.isSelected = false
        btnLayout5.isSelected = false
        btnLayout6.isSelected = false
        btnLayout7.isSelected = false
    }
    
    @IBAction func showLayout1(_ sender: UIButton) {
        hideLayouts()
        Layout1.alpha = 1
        currentLayout = 1
        deselectButtons()
        sender.isSelected = true
    }
    
    @IBAction func showLayout2(_ sender: UIButton) {
        hideLayouts()
        Layout2.alpha = 1
        currentLayout = 2
        deselectButtons()
        sender.isSelected = true
    }
    
    @IBAction func showLayout3(_ sender: UIButton) {
        hideLayouts()
        Layout3.alpha = 1
        currentLayout = 3
        deselectButtons()
        sender.isSelected = true
    }
    
    @IBAction func showLayout4(_ sender: UIButton) {
        hideLayouts()
        Layout4.alpha = 1
        currentLayout = 4
        deselectButtons()
        sender.isSelected = true
    }
    
    @IBAction func showLayout5(_ sender: UIButton) {
        hideLayouts()
        Layout5.alpha = 1
        currentLayout = 5
        deselectButtons()
        sender.isSelected = true
    }
    
    @IBAction func showLayout6(_ sender: UIButton) {
        hideLayouts()
        Layout6.alpha = 1
        currentLayout = 6
        deselectButtons()
        sender.isSelected = true
    }
    
    @IBAction func showLayout7(_ sender: UIButton) {
        hideLayouts()
        Layout7.alpha = 1
        currentLayout = 7
        deselectButtons()
        sender.isSelected = true
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
        //let imageSize = CGSize(width: 1024, height: 1024)
        UIGraphicsBeginImageContextWithOptions(PhotoView.frame.size, false, UIScreen.main.scale)
        PhotoView.layer.render(in: UIGraphicsGetCurrentContext()!)
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
    
    func image(image: UIImage!, didFinishSavingWithError error: NSError!, contextInfo: AnyObject!) {
        if (error != nil) {
            // Something wrong happened.
        } else {
            let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? ViewController {
            controller.photoLayout = currentLayout
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
    
    @IBAction func backToStats(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "unwindToStats", sender: self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let mainViewController = segue.destination as? ViewController
        print (currentLayout)
        mainViewController?.photoLayout = currentLayout
    }
    */

}
