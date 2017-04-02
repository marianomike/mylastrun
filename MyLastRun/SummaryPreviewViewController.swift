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
    @IBOutlet weak var PhotoSummary: UIImageView!
    @IBOutlet weak var PhotoImage: UIView!
    
    @IBOutlet weak var Layout1: UIView!
    @IBOutlet weak var Layout2: UIView!
    @IBOutlet weak var Layout3: UIView!
    @IBOutlet weak var Layout4: UIView!
    
    @IBOutlet weak var btnLayout1: UIButton!
    @IBOutlet weak var btnLayout2: UIButton!
    @IBOutlet weak var btnLayout3: UIButton!
    @IBOutlet weak var btnLayout4: UIButton!
    
    @IBOutlet weak var ToggleDurationPace: UIButton!
    
    // layout 1
    @IBOutlet weak var summaryTitle1: UILabel!
    @IBOutlet weak var summaryDuration1: UILabel!
    @IBOutlet weak var summaryPace1: UILabel!
    @IBOutlet weak var summaryDistance1: UILabel!
    @IBOutlet weak var summaryDistance1b: UILabel!
    @IBOutlet weak var summaryTitle1b: UILabel!
    
    // layout 2
    @IBOutlet weak var summaryTitle2: UILabel!
    @IBOutlet weak var summaryDistance2: UILabel!
    @IBOutlet weak var summaryDuration2: UILabel!
    @IBOutlet weak var summaryPace2: UILabel!
    
    // layout 3
    @IBOutlet weak var summaryTitle3: UILabel!
    @IBOutlet weak var summaryDuration3: UILabel!
    @IBOutlet weak var summaryDistance3: UILabel!
    @IBOutlet weak var summaryPace3: UILabel!
    
    // layout 4
    @IBOutlet weak var summaryTitle4: UILabel!
    @IBOutlet weak var summaryDistance4: UILabel!
    @IBOutlet weak var summaryDuration4: UILabel!
    @IBOutlet weak var summaryPace4: UILabel!
    @IBOutlet weak var summaryDistance4b: UILabel!
    @IBOutlet weak var summaryTitle4b: UILabel!
    
    
    // create variables for the text fields to display
    var userTitleText:String! = ""
    var userDistanceText:String! = ""
    var userDistanceChoice:String! = ""
    var userDuration:String! = ""
    var userPace:String! = ""
    
    var durationString:String = "TOTAL DURATION: "
    var paceString:String = "AVERAGE PACE: "
    
    var passedImage: UIImage!
    var showStats:Bool! = true
    var currentLayout = 1
    
    // reference the navigation bar
    var navigationBarAppearace = UINavigationBar.appearance()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        
        //hide layouts
        hideLayouts()
        
        // set the title of the view
        navigationItem.title = "PREVIEW"

        // Do any additional setup after loading the view.
        
        // populate layout 1
        summaryTitle1.text = userTitleText.uppercased() + " " + userDistanceChoice.uppercased()
        summaryTitle1b.text = userTitleText.uppercased() + " " + userDistanceChoice.uppercased()
        summaryDistance1.text = userDistanceText
        summaryDistance1b.text = userDistanceText
        summaryDuration1.text = durationString + userDuration
        summaryPace1.text = paceString + userPace
        
        // populate layout 2
        summaryTitle2.text = userTitleText.uppercased() + " " + userDistanceChoice.uppercased()
        summaryDistance2.text = userDistanceText
        summaryDuration2.text = durationString + userDuration
        summaryPace2.text = paceString + userPace
        
        // populate layout 3
        summaryTitle3.text = userTitleText.uppercased() + " " + userDistanceChoice.uppercased()
        summaryDistance3.text = userDistanceText
        summaryDuration3.text = durationString + userDuration
        summaryPace3.text = paceString + userPace
        
        // populate layout 4
        summaryTitle4.text = userTitleText.uppercased() + " " + userDistanceChoice.uppercased()
        summaryTitle4b.text = userTitleText.uppercased() + " " + userDistanceChoice.uppercased()
        summaryDistance4.text = userDistanceText
        summaryDistance4b.text = userDistanceText
        summaryDuration4.text = durationString + userDuration
        summaryPace4.text = paceString + userPace
        
        if(passedImage != nil){
            PhotoSummary.image = passedImage
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
        }
        if (showStats == true){
            showStats = false
        }else if (showStats == false){
            showStats = true
        }
        toggleStats(isShowing: showStats)
    }
    
    func hideLayouts(){
        Layout1.alpha = 0
        Layout2.alpha = 0
        Layout3.alpha = 0
        Layout4.alpha = 0
    }
    
    func deselectButtons(){
        btnLayout1.isSelected = false
        btnLayout2.isSelected = false
        btnLayout3.isSelected = false
        btnLayout4.isSelected = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    @IBAction func dragMileage(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        
        sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
        
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
 */
    
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
    
    @IBAction func toggleDurationAndPace(_ sender: UIButton) {
        toggleStats(isShowing: showStats)
    }
    
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? ViewController {
            controller.photoSummaryLayout = currentLayout
            controller.showSummaryStats = showStats
        }
    }
    
    func toggleStats(isShowing: Bool){
        if (isShowing == true){
            showStats = false
            ToggleDurationPace.setImage(#imageLiteral(resourceName: "Unchecked"), for: UIControlState.normal)
            
            // layout 1
            summaryDuration1.alpha = 0
            summaryPace1.alpha = 0
            summaryDistance1.alpha = 0
            summaryTitle1.alpha = 0
            summaryDistance1b.alpha = 1
            summaryTitle1b.alpha = 1
            
            // layout 2
            summaryDuration2.alpha = 0
            summaryPace2.alpha = 0
            
            // layout 3
            summaryDuration3.alpha = 0
            summaryPace3.alpha = 0
            
            // layout 4
            summaryDuration4.alpha = 0
            summaryPace4.alpha = 0
            summaryDistance4.alpha = 0
            summaryTitle4.alpha = 0
            summaryDistance4b.alpha = 1
            summaryTitle4b.alpha = 1
            
        }else if (isShowing == false){
            showStats = true
            ToggleDurationPace.setImage(#imageLiteral(resourceName: "Checked"), for: UIControlState.normal)
            
            // layout 1
            summaryDuration1.alpha = 1
            summaryPace1.alpha = 1
            summaryDistance1.alpha = 1
            summaryTitle1.alpha = 1
            summaryDistance1b.alpha = 0
            summaryTitle1b.alpha = 0
            
            // layout 2
            summaryDuration2.alpha = 1
            summaryPace2.alpha = 1
            
            // layout 3
            summaryDuration3.alpha = 1
            summaryPace3.alpha = 1
            
            // layout 4
            summaryDuration4.alpha = 1
            summaryPace4.alpha = 1
            summaryDistance4.alpha = 1
            summaryTitle4.alpha = 1
            summaryDistance4b.alpha = 0
            summaryTitle4b.alpha = 0
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
