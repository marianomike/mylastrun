//
//  ViewController.swift
//  MyLastRun
//
//  Created by Mike Mariano on 1/24/17.
//  Copyright © 2017 Mike Mariano. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var BtnNext: UIBarButtonItem!
    @IBOutlet weak var MetricsInput: UITextField!
    
    
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
    
    // date
    var dateMonth: String!
    var dateDay: String!
    var dateYear: String!
    var dateHour: String!
    var dateMinutes: String!
    var dateSeconds: String!
    var dateTimePeriod: String!
    
    var picker = UIPickerView()
    var datePicker = UIDatePicker()
    
    // time picker
    var metricsOptions = ["M", "KM"]
    
    var hourOptions = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24"]
    var minuteOptions = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13"]
    
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
        
        /*
        for family: String in UIFont.familyNames
        {
            print("\(family)")
            for names: String in UIFont.fontNames(forFamilyName: family)
            {
                print("== \(names)")
            }
        }
 */
        picker.delegate = self
        picker.dataSource = self
        MetricsInput.inputView = picker
        MetricsInput.tintColor = UIColor.clear
        
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.title = "ENTER STATS"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 169/255, green: 203/255, blue: 74/255, alpha: 1.0)]
        
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
        
        // populate date input with today's date
        let currentDate = Date()
        let currentDateFormatter = DateFormatter()
        currentDateFormatter.dateStyle = DateFormatter.Style.medium
        currentDateFormatter.timeStyle = DateFormatter.Style.short
        DateInput.text = currentDateFormatter.string(from: currentDate)
        DateInput.tintColor = UIColor.clear
        
        
        // Date picker toolbar customization
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.blackTranslucent
        
        toolBar.tintColor = UIColor.white
        
        toolBar.backgroundColor = UIColor(red:169/255, green: 203/255, blue: 74/255, alpha: 1)
        
        
        let todayBtn = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ViewController.tappedToolBarBtn))
        
        let okBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(ViewController.donePressed))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(ViewController.donePressed))
        
        let spaceBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        toolBar.setItems([spaceBtn,doneBtn], animated: true)
        
        // Date picker toolbar customization
        let toolBarToday = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBarToday.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBarToday.barStyle = UIBarStyle.blackTranslucent
        
        toolBarToday.tintColor = UIColor.white
        
        toolBarToday.backgroundColor = UIColor(red:169/255, green: 203/255, blue: 74/255, alpha: 1)
        
        toolBarToday.setItems([todayBtn,flexSpace,flexSpace,okBarBtn], animated: true)
        
        DateInput.inputView = datePicker
        datePicker.setDate(currentDate, animated: true)
        DateInput.inputAccessoryView = toolBarToday
        DistanceInput.inputAccessoryView = toolBar
        MetricsInput.inputAccessoryView = toolBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func donePressed(_ sender: UIBarButtonItem) {
        
        DateInput.resignFirstResponder()
        DistanceInput.resignFirstResponder()
        MetricsInput.resignFirstResponder()
        
    }
    
    func tappedToolBarBtn(_ sender: UIBarButtonItem) {
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMM"
        let convertedMonth: String  = monthFormatter.string(from: Date())
        dateMonth = convertedMonth
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "d"
        let convertedDay: String  = dayFormatter.string(from: Date())
        dateDay = convertedDay
        
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        let convertedYear: String  = yearFormatter.string(from: Date())
        dateYear = convertedYear
        
        
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "h"
        let convertedHour: String  = hourFormatter.string(from: Date())
        dateHour = convertedHour
        
        let minuteFormatter = DateFormatter()
        minuteFormatter.dateFormat = "mm"
        let convertedMinute: String  = minuteFormatter.string(from: Date())
        dateMinutes = convertedMinute
        
        let timePeriodFormatter = DateFormatter()
        timePeriodFormatter.dateFormat = "a"
        let convertedTimePeriod: String  = timePeriodFormatter.string(from: Date())
        dateTimePeriod = convertedTimePeriod
        
        DateInput.text = dateMonth + " " + dateDay + ", " + dateYear + ", " + dateHour + ":" + dateMinutes + " " + dateTimePeriod
        
        DateInput.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func datePickerValueChanged(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        DateInput.text = dateFormatter.string(from: sender.date)
        
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMM"
        let convertedMonth: String  = monthFormatter.string(from: sender.date)
        dateMonth = convertedMonth
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "d"
        let convertedDay: String  = dayFormatter.string(from: sender.date)
        dateDay = convertedDay
        
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        let convertedYear: String  = yearFormatter.string(from: sender.date)
        dateYear = convertedYear
        
        
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "h"
        let convertedHour: String  = hourFormatter.string(from: sender.date)
        dateHour = convertedHour
        
        let minuteFormatter = DateFormatter()
        minuteFormatter.dateFormat = "m"
        let convertedMinute: String  = minuteFormatter.string(from: sender.date)
        dateMinutes = convertedMinute
        
        let timePeriodFormatter = DateFormatter()
        timePeriodFormatter.dateFormat = "a"
        let convertedTimePeriod: String  = timePeriodFormatter.string(from: sender.date)
        dateTimePeriod = convertedTimePeriod
        
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
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        
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
            
            var userDistanceChoice = MetricsInput.text
            if(userDistanceChoice == "M"){
                userDistanceChoice = "Miles"
            }else if (userDistanceChoice == "KM"){
                userDistanceChoice = "Kilometers"
            }
            
            picChooserViewController?.userDistanceText = DistanceInput.text
            picChooserViewController?.userDistanceChoice = userDistanceChoice
            picChooserViewController?.userLocationText = LocationInput.text
            picChooserViewController?.userDay = dateDay
            picChooserViewController?.userMonth = dateMonth
            picChooserViewController?.userYear = dateYear
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return metricsOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        MetricsInput.text = metricsOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return metricsOptions[row]
    }
    

}

