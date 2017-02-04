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
    
    // weather variables
    @IBOutlet weak var DegreesInput: UITextField!
    @IBOutlet weak var WeatherInput: UITextField!
    
    @IBOutlet weak var BtnPhotos: UIButton!
    @IBOutlet weak var BtnCamera: UIButton!
    
    @IBOutlet weak var ImageChoice: UIImageView!
    @IBOutlet weak var ChooseStackView: UIStackView!
    @IBOutlet weak var DeletePhoto: UIButton!
    
    
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
    
    // pickers
    var picker = UIPickerView()
    var datePicker = UIDatePicker()
    var timePicker = UIPickerView()
    var weatherPicker = UIPickerView()
    
    // picker options
    var metricsOptions = ["Miles", "Kilometers"]
    var weatherOptions = ["Sunny", "Partly Cloudy", "Cloudy", "Raining", "Snowing"]
    var hours  = Array (0...23)
    var minutes = Array(0...59)
    var seconds = Array(0...59)
    
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
        
        // title bar
        navigationItem.title = "ENTER RUN DATA"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 169/255, green: 203/255, blue: 74/255, alpha: 1.0)]
        
        //navigationController?.navigationBar.ba = [NSForegroundColorAttributeName: UIColor(red: 169/255, green: 203/255, blue: 74/255, alpha: 1.0)]
        
        // get today's date
        let currentDate = Date()
        let currentDateFormatter = DateFormatter()
        currentDateFormatter.dateStyle = DateFormatter.Style.medium
        currentDateFormatter.timeStyle = DateFormatter.Style.short
        
        // Initialize variables
        titleIsChecked = true
        distanceIsChecked = true
        timeIsChecked = true
        locationIsChecked = true
        dateIsChecked = true
        
        // hide the delete photo button
        DeletePhoto.alpha = 0;
        
        // Handle the text field's user input through delegate callbacks.
        TitleInput.delegate = self;
        DistanceInput.delegate = self;
        TimeInput.delegate = self;
        LocationInput.delegate = self;
        DateInput.delegate = self;
        
        picker.delegate = self
        picker.dataSource = self
        timePicker.delegate = self
        timePicker.dataSource = self
        weatherPicker.delegate = self
        weatherPicker.dataSource = self
        
        // Assign Tags to pickers
        picker.tag = 1
        timePicker.tag = 2
        weatherPicker.tag = 3
        
        // Set which picker which input should use and hide the cursor
        TimeInput.inputView = timePicker
        TimeInput.tintColor = UIColor.clear
        
        MetricsInput.inputView = picker
        MetricsInput.tintColor = UIColor.clear
        
        DateInput.inputView = datePicker
        DateInput.tintColor = UIColor.clear
        
        WeatherInput.inputView = weatherPicker
        WeatherInput.tintColor = UIColor.clear
        
        // Set input date to current date
        DateInput.text = currentDateFormatter.string(from: currentDate)
        
        // Assign current date to variables
        // TO DO: Make a function out of the below
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMM"
        let convertedMonth: String  = monthFormatter.string(from: currentDate)
        dateMonth = convertedMonth
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "d"
        let convertedDay: String  = dayFormatter.string(from: currentDate)
        dateDay = convertedDay
        
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        let convertedYear: String  = yearFormatter.string(from: currentDate)
        dateYear = convertedYear
        
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "h"
        let convertedHour: String  = hourFormatter.string(from: currentDate)
        dateHour = convertedHour
        
        let minuteFormatter = DateFormatter()
        minuteFormatter.dateFormat = "m"
        let convertedMinute: String  = minuteFormatter.string(from: currentDate)
        dateMinutes = convertedMinute
        
        let timePeriodFormatter = DateFormatter()
        timePeriodFormatter.dateFormat = "a"
        let convertedTimePeriod: String  = timePeriodFormatter.string(from: currentDate)
        dateTimePeriod = convertedTimePeriod
        
        // set the date picker to today's date by default
        datePicker.addTarget(self, action: #selector(ViewController.datePickerValueChanged(_:)), for: UIControlEvents.valueChanged)
        datePicker.setDate(currentDate, animated: true)
        
        // Create tool bar for picker without Today button
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
        
        // Create tool bar for picker with Today button
        let toolBarToday = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBarToday.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBarToday.barStyle = UIBarStyle.blackTranslucent
        
        toolBarToday.tintColor = UIColor.white
        
        toolBarToday.backgroundColor = UIColor(red:169/255, green: 203/255, blue: 74/255, alpha: 1)
        
        toolBarToday.setItems([todayBtn,flexSpace,flexSpace,okBarBtn], animated: true)
        
        // Assign Toolbars to pickers
        DateInput.inputAccessoryView = toolBarToday
        DistanceInput.inputAccessoryView = toolBar
        DegreesInput.inputAccessoryView = toolBar
        WeatherInput.inputAccessoryView = toolBar
        MetricsInput.inputAccessoryView = toolBar
        TimeInput.inputAccessoryView = toolBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // close the keyboard when custom toolbar done is pressed
    func donePressed(_ sender: UIBarButtonItem) {
        
        DateInput.resignFirstResponder()
        DistanceInput.resignFirstResponder()
        MetricsInput.resignFirstResponder()
        TimeInput.resignFirstResponder()
        DegreesInput.resignFirstResponder()
        WeatherInput.resignFirstResponder()
        
    }
    
    // when Today's date is pressed, set it to today
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
    
    // when user picks own date, set it to this
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
        ImageChoice.image = selectedImage
        DeletePhoto.alpha = 1;
        ChooseStackView.alpha = 0;
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Photo Buttons
    @IBAction func ChoosePhoto(_ sender: UIButton) {
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = true //or true additional setup required.
        
        self.present(image, animated: true, completion: nil)
    }
    
    @IBAction func OpenCamera(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func DeletePhoto(_ sender: UIButton) {
        ChooseStackView.alpha = 1
        DeletePhoto.alpha = 0
        ImageChoice.image = nil
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
    
    // pass variables through to next view
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
            picChooserViewController?.passedImage = ImageChoice.image
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        var rowNumber = 0
        
        if (pickerView.tag == 1){
            rowNumber = 1
        }else if (pickerView.tag == 2){
            rowNumber = 3
        }else if (pickerView.tag == 3){
            rowNumber = 1
        }
        return rowNumber
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var componentNumber = 0
        
        if (pickerView.tag == 1){
            componentNumber = metricsOptions.count
        }else if (pickerView.tag == 2){
            //var row = pickerView.selectedRow(inComponent: 0)
            //println("this is the pickerView\(row)")
            
            if (component == 0) {
                componentNumber = hours.count
            } else if (component == 1) {
                componentNumber = minutes.count
            } else if (component == 2) {
                componentNumber = seconds.count
            }
        }else if (pickerView.tag == 3){
            componentNumber = weatherOptions.count
        }
        return componentNumber
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 1){
            MetricsInput.text = metricsOptions[row]
        }else if (pickerView.tag == 2){
            //return 3
        }else if (pickerView.tag == 3){
            WeatherInput.text = weatherOptions[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var rowTitle = ""
        
        if (pickerView.tag == 1){
            rowTitle = metricsOptions[row]
        }else if (pickerView.tag == 2){
            if (component == 0) {
                rowTitle = String(hours[row]) + "h"
            } else if (component == 1) {
                rowTitle = String(minutes[row]) + "m"
            } else if (component == 2) {
                rowTitle = String(seconds[row]) + "s"
            }
        }else if (pickerView.tag == 3){
            rowTitle = weatherOptions[row]
        }
        return rowTitle
    }
}

