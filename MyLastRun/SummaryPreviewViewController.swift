//
//  SummaryPreviewViewController.swift
//  My Last Run
//
//  Created by Mike Mariano on 4/1/17.
//  Copyright © 2017 Mike Mariano. All rights reserved.
//

import UIKit

class SummaryPreviewViewController: UIViewController {
    
    @IBOutlet var MileageView: UIView!
    @IBOutlet var dragMileage: UIPanGestureRecognizer!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
