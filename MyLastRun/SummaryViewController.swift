//
//  SummaryViewController.swift
//  My Last Run
//
//  Created by Mike Mariano on 3/25/17.
//  Copyright © 2017 Mike Mariano. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController {
    
    @IBOutlet weak var SummaryCategory: UILabel!
    @IBOutlet weak var SummaryCategoryInput: UITextField!
    @IBOutlet weak var TotalDistanceInput: UITextField!
    @IBOutlet weak var TotalMetricInput: UITextField!
    @IBOutlet weak var TotalDurationInput: UITextField!
    @IBOutlet weak var AveragePaceInput: UITextField!
    @IBOutlet weak var CommentsInput: UITextField!
    
    var typeChoice:String! = ""
    var parentVC:ViewController!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SummaryCategory.text = typeChoice
        //parentVC = self.parent as! ViewController!
        //SummaryCategory.text = parentVC.typeChoice
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //SummaryCategory.text = parentVC.typeChoice
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
