//
//  PhotoPickerViewController.swift
//  My Last Run
//
//  Created by Mike Mariano on 1/27/17.
//  Copyright © 2017 Mike Mariano. All rights reserved.
//

import UIKit

class PhotoPickerViewController: UIViewController {
    
    // reference the new text field
    @IBOutlet weak var PhotoTitle: UITextField!
    
    // create variable for new text field to display
    var userTitleText:String! = ""
    var navigationBarAppearace = UINavigationBar.appearance()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "CHOOSE PICTURE"
        navigationItem.hidesBackButton = true
        
        PhotoTitle.text = userTitleText
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backToStats(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "unwindToStats", sender: self)
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
