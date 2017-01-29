//
//  ViewController.swift
//  MyLastRun
//
//  Created by Mike Mariano on 1/24/17.
//  Copyright © 2017 Mike Mariano. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var BtnNext: UIBarButtonItem!
    
    // title variables
    @IBOutlet weak var BtnTitleCheckbox: UIButton!
    @IBOutlet weak var TitleInput: UITextField!
    
    // distance variables
    @IBOutlet weak var BtnDistanceCheckbox: UIButton!
    @IBOutlet weak var DistanceInput: UITextField!
    
    // time variables
    @IBOutlet weak var BtnTimeCheckbox: UIButton!
    @IBOutlet weak var TimeInput: UITextField!
    
    // location variables
    @IBOutlet weak var BtnLocationCheckbox: UIButton!
    @IBOutlet weak var LocationInput: UITextField!
    
    // date variables
    @IBOutlet weak var DateInput: UITextField!
    @IBOutlet weak var BtnDateCheckbox: UIButton!
    
    // checked variables
    var titleIsChecked: Bool!
    var distanceIsChecked: Bool!
    var timeIsChecked: Bool!
    var locationIsChecked: Bool!
    var dateIsChecked: Bool!
    
    // checkbox variables
    var checkbox = UIImage(named: "Checked")
    var unCheckbox = UIImage(named: "Unchecked")
    
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.title = "STATS"
        
        // Initialize variables
        titleIsChecked = true
        distanceIsChecked = true
        timeIsChecked = true
        locationIsChecked = true
        dateIsChecked = true
        
        // Handle the text field's user input through delegate callbacks.
        TitleInput.delegate = self;
        DistanceInput.delegate = self;
        TimeInput.delegate = self;
        LocationInput.delegate = self;
        DateInput.delegate = self;
        
        // Date picker toolbar customization
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.blackTranslucent
        
        toolBar.tintColor = UIColor.white
        
        toolBar.backgroundColor = UIColor(red:169/255, green: 203/255, blue: 74/255, alpha: 1)
        
        
        let todayBtn = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ViewController.tappedToolBarBtn))
        
        let okBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(ViewController.donePressed))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        toolBar.setItems([todayBtn,flexSpace,flexSpace,okBarBtn], animated: true)
        
        DateInput.inputAccessoryView = toolBar
        DistanceInput.inputAccessoryView = toolBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func donePressed(_ sender: UIBarButtonItem) {
        
        DateInput.resignFirstResponder()
        
    }
    
    func tappedToolBarBtn(_ sender: UIBarButtonItem) {
        
        let dateformatter = DateFormatter()
        
        dateformatter.dateStyle = DateFormatter.Style.medium
        
        dateformatter.timeStyle = DateFormatter.Style.none
        
        DateInput.text = dateformatter.string(from: Date())
        
        DateInput.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func textFieldEditing(_ sender: UITextField) {
        
        let datePickerView: UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        
        sender.inputView = datePickerView
        
        DateInput.addTarget(self, action: #selector(ViewController.datePickerValueChanged(_:)), for: UIControlEvents.valueChanged)
        
    }
    
    @IBAction func distanceFieldEditing(_ sender: UITextField) {
        let distancePickerView: UIDatePicker = UIDatePicker()
        
        distancePickerView.datePickerMode = UIDatePickerMode.countDownTimer
        
        sender.inputView = distancePickerView
        
        DistanceInput.addTarget(self, action: #selector(ViewController.datePickerValueChanged(_:)), for: UIControlEvents.valueChanged)
    }
    
    func datePickerValueChanged(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.full
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        DateInput.text = dateFormatter.string(from: sender.date)
        
    }

    // MARK: Checkboxes
    
    @IBAction func TapTitleCheckbox(_ sender: UIButton) {
        
        if titleIsChecked == true {
            titleIsChecked = false
        }else{
            titleIsChecked = true
        }
        
        if titleIsChecked == true {
            BtnTitleCheckbox.setImage(checkbox, for: UIControlState.normal)
        } else {
            BtnTitleCheckbox.setImage(unCheckbox, for: UIControlState.normal)
        }

    }
    
    @IBAction func TapDistanceCheckbox(_ sender: UIButton) {
        
        if timeIsChecked == true {
            timeIsChecked = false
        }else{
            timeIsChecked = true
        }
        
        if timeIsChecked == true {
            BtnDistanceCheckbox.setImage(checkbox, for: UIControlState.normal)
        } else {
            BtnDistanceCheckbox.setImage(unCheckbox, for: UIControlState.normal)
        }
        
    }
    
    @IBAction func TapTimeCheckbox(_ sender: UIButton) {
        
        if distanceIsChecked == true {
            distanceIsChecked = false
        }else{
            distanceIsChecked = true
        }
        
        if distanceIsChecked == true {
            BtnTimeCheckbox.setImage(checkbox, for: UIControlState.normal)
        } else {
            BtnTimeCheckbox.setImage(unCheckbox, for: UIControlState.normal)
        }
        
    }
    
    @IBAction func TapLocationCheckbox(_ sender: UIButton) {
        
        if locationIsChecked == true {
            locationIsChecked = false
        }else{
            locationIsChecked = true
        }
        
        if locationIsChecked == true {
            BtnLocationCheckbox.setImage(checkbox, for: UIControlState.normal)
        } else {
            BtnLocationCheckbox.setImage(unCheckbox, for: UIControlState.normal)
        }
        
    }
    
    @IBAction func DateInputEdit(_ sender: UITextField) {
        let distancePickerView:UIDatePicker = UIDatePicker()
        
        distancePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        
        sender.inputView = distancePickerView
        
        distancePickerView.addTarget(self, action: #selector(ViewController.datePickerValueChanged(_:)), for: UIControlEvents.valueChanged)
    }
    
    @IBAction func DistanceInputEdit(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.countDownTimer
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(ViewController.datePickerValueChanged(_:)), for: UIControlEvents.valueChanged)
    }
    
    @IBAction func DateLocationCheckbox(_ sender: UIButton) {
        
        if dateIsChecked == true {
            dateIsChecked = false
        }else{
            dateIsChecked = true
        }
        
        if dateIsChecked == true {
            BtnDateCheckbox.setImage(checkbox, for: UIControlState.normal)
        } else {
            BtnDateCheckbox.setImage(unCheckbox, for: UIControlState.normal)
        }
        
    }
    
    @IBAction func unwindToStats(segue: UIStoryboardSegue) {}
    
    // pass the value of the input throught the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPicChooser" {
            let picChooserViewController = segue.destination as? PhotoPickerViewController
            picChooserViewController?.userTitleText = TitleInput.text
        }
    }
    

}

