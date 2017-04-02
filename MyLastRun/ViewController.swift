//
//  ViewController.swift
//  MyLastRun
//
//  Created by Mike Mariano on 1/24/17.
//  Copyright © 2017 Mike Mariano. All rights reserved.
//

import UIKit
import HealthKit

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var BtnNext: UIBarButtonItem!
    @IBOutlet weak var MetricsInput: UITextField!
    @IBOutlet weak var BtnAllRuns: UIBarButtonItem!
    
    // input variables
    @IBOutlet weak var TitleInput: UITextField!
    @IBOutlet weak var DistanceInput: UITextField!
    @IBOutlet weak var TimeInput: UITextField!
    @IBOutlet weak var PaceInput: UITextField!
    @IBOutlet weak var LocationInput: UITextField!
    @IBOutlet weak var DateInput: UITextField!
    
    // weather variables
    @IBOutlet weak var DegreesInput: UITextField!
    @IBOutlet weak var WeatherInput: UITextField!
    
    @IBOutlet weak var BtnPhotos: UIButton!
    @IBOutlet weak var BtnCamera: UIButton!
    
    @IBOutlet weak var ImageChoice: UIImageView!
    @IBOutlet weak var ChooseStackView: UIStackView!
    @IBOutlet weak var DeletePhoto: UIButton!
    
    @IBOutlet weak var CalendarTabs: UISegmentedControl!
    @IBOutlet weak var SummaryView: UIView!
    
    
    let healthManager:HealthKitManager = HealthKitManager()
    var distance:HKQuantitySample?
    var workouts = [HKWorkout]()
    var monthlyRuns = [HKWorkout]()
    var yearlyRuns = [HKWorkout]()
    var monthlyDuration = [HKWorkout]()
    var yearlyDuration = [HKWorkout]()
    var lastRun = [HKWorkout]()
    var selectedRun: Int!
    var photoLayout = 1
    var showStats:Bool! = true
    var typeChoice:String! = "Single"
    var totalMilesMonth:Double = 0
    var totalMilesYear:Double = 0
    var totalDurationMonth:TimeInterval = 0
    var totalDurationYear:TimeInterval = 0
    var curYear:String = "2017"
    var curMonth:String = "January"
    var durationMonth:String = ""
    var paceMonth:String = ""
    var durationYear:String = ""
    var paceYear:String = ""
    
    let monthFormatter = DateFormatter()
    let formatMonth = "MMM"
    let dayFormatter = DateFormatter()
    let formatDay = "d"
    let yearFormatter = DateFormatter()
    let formatYear = "yyyy"
    let hourFormatter = DateFormatter()
    let formatHour = "h"
    let minuteFormatter = DateFormatter()
    let formatMinutes = "m"
    let timePeriodFormatter = DateFormatter()
    let formatTimePeriod = "a"
    
    let formatter = DateComponentsFormatter()
    let distanceFormatter = LengthFormatter()
    
    // checked variables
    var titleIsChecked: Bool!
    var distanceIsChecked: Bool!
    var timeIsChecked: Bool!
    var locationIsChecked: Bool!
    var dateIsChecked: Bool!
    
    // duration
    var durHour: String!
    var durMinutes: String!
    var durSeconds: String!
    
    // pace
    var paceHour: String!
    var paceMinutes: String!
    var paceSeconds: String!
    
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
    var pacePicker = UIPickerView()
    
    // picker options
    var metricsOptions = ["Miles", "Kilometers"]
    var weatherOptions = ["None", "Sunny", "Partly Cloudy", "Cloudy", "Raining", "Snowing"]
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
        getHealthKitPermission()
        
        // title bar
        //navigationItem.title = "MY LAST RUN"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 169/255, green: 203/255, blue: 74/255, alpha: 1.0)]
        
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
        
        SummaryView.isHidden = true
        
        // Handle the text field's user input through delegate callbacks.
        TitleInput.delegate = self
        DistanceInput.delegate = self
        TimeInput.delegate = self
        LocationInput.delegate = self
        DateInput.delegate = self
        DegreesInput.delegate = self
        PaceInput.delegate = self
        
        picker.delegate = self
        picker.dataSource = self
        timePicker.delegate = self
        timePicker.dataSource = self
        weatherPicker.delegate = self
        weatherPicker.dataSource = self
        pacePicker.delegate = self
        pacePicker.dataSource = self
        
        // Assign Tags to pickers
        picker.tag = 1
        timePicker.tag = 2
        weatherPicker.tag = 3
        pacePicker.tag = 4
        
        // Set which picker which input should use and hide the cursor
        TimeInput.inputView = timePicker
        TimeInput.tintColor = UIColor.clear
        
        MetricsInput.inputView = picker
        MetricsInput.tintColor = UIColor.clear
        
        DateInput.inputView = datePicker
        DateInput.tintColor = UIColor.clear
        
        WeatherInput.inputView = weatherPicker
        WeatherInput.tintColor = UIColor.clear
        
        PaceInput.inputView = pacePicker
        PaceInput.tintColor = UIColor.clear
        
        // Set input date to current date
        DateInput.text = currentDateFormatter.string(from: currentDate)
        updateDates(date: currentDate)
        
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
        PaceInput.inputAccessoryView = toolBar
    }
    
    @IBAction func segmentControlValueChanged(_ sender: UISegmentedControl) {
        
        if CalendarTabs.selectedSegmentIndex == 0 {
            typeChoice = "Year"
            sendSummaryType(type: typeChoice)
            SummaryView.isHidden = false
            BtnAllRuns.isEnabled = false
            BtnAllRuns.tintColor = UIColor.clear
        } else if CalendarTabs.selectedSegmentIndex == 1 {
            typeChoice = "Month"
            sendSummaryType(type: typeChoice)
            SummaryView.isHidden = false
            BtnAllRuns.isEnabled = false
            BtnAllRuns.tintColor = UIColor.clear
        } else if CalendarTabs.selectedSegmentIndex == 2 {
            typeChoice = "Single"
            SummaryView.isHidden = true
            BtnAllRuns.isEnabled = true
            BtnAllRuns.tintColor = UIColor(red: 140/255, green: 162/255, blue: 98/255, alpha: 1.0)
        }
        
    }
    
    func sendSummaryType(type : String) {
        let summaryVC = childViewControllers.last as! SummaryViewController
        summaryVC.typeChoice = type
        if(type == "Year"){
            summaryVC.totalDistance = totalMilesYear
            summaryVC.summaryDate = curYear
            summaryVC.summaryDuration = durationYear
            summaryVC.summaryPace = paceYear
        }else if(type == "Month"){
            summaryVC.totalDistance = totalMilesMonth
            summaryVC.summaryDate = curMonth
            summaryVC.summaryDuration = durationMonth
            summaryVC.summaryPace = paceMonth
        }
        summaryVC.updateLabels()
    }
    
    func getHealthKitPermission() {
        healthManager.authorizeHealthKit { (authorized,  error) -> Void in
            if authorized {
                self.getAllRuns()
            } else {
                
            }
        }
    }
    
    func updateDates(date: Date){
        monthFormatter.dateFormat = formatMonth
        let convertedMonth: String  = monthFormatter.string(from: date)
        dateMonth = convertedMonth
        
        dayFormatter.dateFormat = formatDay
        let convertedDay: String  = dayFormatter.string(from: date)
        dateDay = convertedDay
        
        yearFormatter.dateFormat = formatYear
        let convertedYear: String  = yearFormatter.string(from: date)
        dateYear = convertedYear
        
        hourFormatter.dateFormat = formatHour
        let convertedHour: String  = hourFormatter.string(from: date)
        dateHour = convertedHour
        
        minuteFormatter.dateFormat = formatMinutes
        let convertedMinute: String  = minuteFormatter.string(from: date)
        dateMinutes = convertedMinute
        
        timePeriodFormatter.dateFormat = formatTimePeriod
        let convertedTimePeriod: String  = timePeriodFormatter.string(from: date)
        dateTimePeriod = convertedTimePeriod
    }
    
    func getAllRuns(){
        let currentDate = Date()
        self.curMonth = self.getMonth(date: currentDate)
        self.curYear = self.getYear(date: currentDate)
        
        self.healthManager.readRunningWorkouts(completion: { (results, error) -> Void in
            if( error != nil )
            {
                print("Error reading workouts: \(String(describing: error?.localizedDescription))")
                return;
            }
            else
            {
                print("Workouts read successfully!")
            }
            
            self.workouts = results as! [HKWorkout]
            
            // print workouts
            //print(self.workouts.count)
            
            
            
            DispatchQueue.main.async(){
                
                if(self.workouts.count != 0){
                    
                    
                    for i in 0 ..< self.workouts.count{
                        //push this months runs to array
                        if(self.getMonth(date: self.workouts[i].endDate) == self.getMonth(date: currentDate)){
                            self.monthlyRuns.append(self.workouts[i])
                        }
                        //push this months runs to array
                        if(self.getYear(date: self.workouts[i].endDate) == self.getYear(date: currentDate)){
                            self.yearlyRuns.append(self.workouts[i])
                        }
                    }
                    
                    for i in 0 ..< self.monthlyRuns.count{
                        let distance = self.convertKMToMiles(distance: self.monthlyRuns[i].totalDistance!)
                        self.totalMilesMonth = self.totalMilesMonth + Double(distance)!
                        
                        self.totalDurationMonth = self.totalDurationMonth + self.monthlyRuns[i].duration
                    }
                    
                    if(self.totalDurationMonth != 0){
                        self.durationMonth = self.convertDuration(duration:self.totalDurationMonth)
                        self.paceMonth = self.calculateAveragePace(distance: self.totalMilesMonth, duration: self.totalDurationMonth)
                        print("Miles this month: \(self.totalMilesMonth)")
                        print("Duration this month: \(self.convertDuration(duration:self.totalDurationMonth))")
                        print("Average Pace this month: \(self.calculateAveragePace(distance: self.totalMilesMonth, duration: self.totalDurationMonth))")
                    }
                    
                    for i in 0 ..< self.yearlyRuns.count{
                        let distance = self.convertKMToMiles(distance: self.yearlyRuns[i].totalDistance!)
                        self.totalMilesYear = self.totalMilesYear + Double(distance)!
                        
                        self.totalDurationYear = self.totalDurationYear + self.yearlyRuns[i].duration
                    }
                    
                    if(self.totalDurationYear != 0){
                        self.durationYear = self.convertDuration(duration:self.totalDurationYear)
                        self.paceYear = self.calculateAveragePace(distance: self.totalMilesYear, duration: self.totalDurationYear)
                        print("Miles this year: \(self.totalMilesYear)")
                        print("Duration this year: \(self.convertDuration(duration:self.totalDurationYear))")
                        print("Average Pace this year: \(self.calculateAveragePace(distance: self.totalMilesYear, duration: self.totalDurationYear))")
                    }
                
                    let lastDistance = self.convertKMToMiles(distance: self.workouts[0].totalDistance!)
                
                    self.DateInput.text = self.convertDate(date: self.workouts[0].startDate)
                    self.DistanceInput.text = String(describing: lastDistance)
                    self.TimeInput.text = self.convertDuration(duration: self.workouts[0].duration)
                    self.PaceInput.text = self.calculatePace(distance: self.workouts[0].totalDistance!, duration: self.workouts[0].duration)
                
                    self.updateDates(date: self.workouts[0].startDate)
                    self.datePicker.setDate(self.workouts[0].startDate, animated: true)
                    self.selectedRun = 0;
                }
            }
            
        })
    }
    
    func getMonth(date: Date) -> String{
        monthFormatter.dateFormat = "MMMM"
        let convertedMonth: String  = monthFormatter.string(from: date)
        return convertedMonth
    }
    
    func getYear(date: Date) -> String{
        yearFormatter.dateFormat = formatYear
        let convertedYear: String  = yearFormatter.string(from: date)
        return convertedYear
    }
    
    func calculateAveragePace(distance: Double, duration: TimeInterval) -> String{
        
        let pace = duration / distance
        
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [ .minute, .second ]
        formatter.zeroFormattingBehavior = [ .pad ]
        
        let convertedPace = formatter.string(from: pace)
        return convertedPace!
        
    }
    
    func calculatePace(distance: HKQuantity, duration: TimeInterval) -> String{
        let distanceInKM = distance.doubleValue(for: HKUnit.mile())
        let pace = duration/distanceInKM
        
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [ .minute, .second ]
        formatter.zeroFormattingBehavior = [ .pad ]
        
        let convertedPace = formatter.string(from: pace)
        return convertedPace!
        
    }
    
    func convertDuration(duration: TimeInterval) -> String{
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [ .hour, .minute, .second ]
        formatter.zeroFormattingBehavior = [ .pad ]
        
        let convertedDuration = formatter.string(from: duration)
        return convertedDuration!
    }
    
    func convertDate(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        let convertedDate = dateFormatter.string(from: date)
        return convertedDate
    }
    
    func convertKMToMiles(distance: HKQuantity) -> String{
        //distanceFormatter.numberFormatter.numberStyle =
        var distanceInKM = distance.doubleValue(for: HKUnit.mile())
        distanceInKM = distanceInKM.roundTo(places: 2)
        var convertedMiles = distanceFormatter.string(fromValue: distanceInKM, unit: LengthFormatter.Unit.mile)
        convertedMiles = String(convertedMiles.characters.dropLast(3))
        return convertedMiles
    }
    
    func milesToKilometers(speedInMPH:Double) ->Double {
        let speedInKPH = speedInMPH * 1.60934
        return speedInKPH as Double
    }
    
    func kilometersToMiles(speedInMPH:Double) ->Double {
        let speedInKPH = speedInMPH / 1.60934
        return speedInKPH as Double
    }
    
    func updateToKM(){
        let distanceInMiles = Double(DistanceInput.text!)
        if(distanceInMiles != nil){
            var distanceInKilometers = milesToKilometers(speedInMPH: distanceInMiles!)
            distanceInKilometers = distanceInKilometers.roundTo(places: 2)
            DistanceInput.text = String(describing:distanceInKilometers)
            
            let duration = parseDuration(TimeInput.text!)
            let pace = duration/distanceInKilometers
            print(pace)
            
            formatter.unitsStyle = .positional
            formatter.allowedUnits = [ .minute, .second ]
            formatter.zeroFormattingBehavior = [ .pad ]
            
            let convertedPace = formatter.string(from: pace)
            PaceInput.text = convertedPace
        }
    }
    
    func parseDuration(_ timeString:String) -> TimeInterval {
        guard !timeString.isEmpty else {
            return 0
        }
        
        var interval:Double = 0
        
        let parts = timeString.components(separatedBy: ":")
        for (index, part) in parts.reversed().enumerated() {
            interval += (Double(part) ?? 0) * pow(Double(60), Double(index))
        }
        
        return interval
    }
    
    func updateToMiles(){
        let distanceInKm = Double(DistanceInput.text!)
        if(distanceInKm != nil){
            var distanceInMiles = kilometersToMiles(speedInMPH: distanceInKm!)
            distanceInMiles = distanceInMiles.roundTo(places: 2)
            DistanceInput.text = String(describing:distanceInMiles)
            
            let duration = parseDuration(TimeInput.text!)
            let pace = duration/distanceInMiles
            print(pace)
            
            formatter.unitsStyle = .positional
            formatter.allowedUnits = [ .minute, .second ]
            formatter.zeroFormattingBehavior = [ .pad ]
            
            let convertedPace = formatter.string(from: pace)
            PaceInput.text = convertedPace
        }
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
        PaceInput.resignFirstResponder()
    }
    
    // when Today's date is pressed, set it to today
    func tappedToolBarBtn(_ sender: UIBarButtonItem) {
        
        updateDates(date: Date())
        
        DateInput.text = dateMonth + " " + dateDay + ", " + dateYear + ", " + dateHour + ":" + dateMinutes + " " + dateTimePeriod
        
        DateInput.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // move up textfields when editing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateViewMoving(up: true, moveValue: 100)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateViewMoving(up: false, moveValue: 100)
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
    }
    
    // when user picks own date, set it to this
    func datePickerValueChanged(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        DateInput.text = dateFormatter.string(from: sender.date)
        
        updateDates(date: sender.date)
        
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
    
    @IBAction func DateInputEdit(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(ViewController.datePickerValueChanged(_:)), for: UIControlEvents.valueChanged)
    }
    
    @IBAction func showPreview(_ sender: UIBarButtonItem) {
        //self.navigationController?.pushViewController(nextViewController, animated: true)
        if(typeChoice == "Single"){
            self.performSegue(withIdentifier: "showSingle", sender: self)
        }else if(typeChoice == "Month"){
            self.performSegue(withIdentifier: "showSummary", sender: self)
        }else if(typeChoice == "Year"){
            self.performSegue(withIdentifier: "showSummary", sender: self)
        }
        
    }
    
    @IBAction func unwindToStats(segue: UIStoryboardSegue) {
        if let modalVC = segue.source as? AddWorkoutViewController, segue.identifier == "closeModal" {
                
            //let text = modalVC.textField.text
            DateInput.text = modalVC.selectedDate
            DistanceInput.text = modalVC.selectedDistance
            TimeInput.text = modalVC.selectedDuration
            PaceInput.text = modalVC.selectedPace
            updateDates(date: modalVC.selectedDateObject)
            selectedRun = modalVC.selectedInt
            print("returned \(selectedRun)")
                
            // Now do stuff with the text.
        }
    }
    
    // pass variables through to next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSingle" {
            let picChooserViewController = segue.destination as? PhotoPickerViewController
            
            picChooserViewController?.userTitleText = TitleInput.text
            picChooserViewController?.userDistanceText = DistanceInput.text
            picChooserViewController?.userDistanceChoice = MetricsInput.text
            picChooserViewController?.userLocationText = LocationInput.text
            picChooserViewController?.userDay = dateDay
            picChooserViewController?.userMonth = dateMonth
            picChooserViewController?.userYear = dateYear
            picChooserViewController?.passedImage = ImageChoice.image
            picChooserViewController?.userDegrees = DegreesInput.text
            picChooserViewController?.userWeatherIcon = WeatherInput.text
            picChooserViewController?.userDuration = TimeInput.text
            picChooserViewController?.userPace = PaceInput.text
            picChooserViewController?.currentLayout = photoLayout
            picChooserViewController?.showStats = showStats
        }else if segue.identifier == "showWorkouts"{
            
            print("trying to pass \(selectedRun)")
            if(selectedRun == nil){
                selectedRun = 0
            }
            let navVC = segue.destination as! UINavigationController
            let tableVC = navVC.viewControllers.first as! AddWorkoutViewController
            
            tableVC.passedInt = selectedRun
            tableVC.workouts = workouts
            
        }else if segue.identifier == "showSummary"{
            let summaryPreviewVC = segue.destination as? SummaryPreviewViewController
            
            summaryPreviewVC?.passedImage = ImageChoice.image
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
        }else if (pickerView.tag == 4){
            rowNumber = 2
        }
        return rowNumber
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var componentNumber = 0
        
        if (pickerView.tag == 1){
            componentNumber = metricsOptions.count
        }else if (pickerView.tag == 2){
            
            if (component == 0) {
                componentNumber = hours.count
            } else if (component == 1) {
                componentNumber = minutes.count
            } else if (component == 2) {
                componentNumber = seconds.count
            }
        }else if (pickerView.tag == 3){
            componentNumber = weatherOptions.count
        }else if (pickerView.tag == 4){
            
            if (component == 0) {
                componentNumber = minutes.count
            } else if (component == 1) {
                componentNumber = seconds.count
            }
        }
        return componentNumber
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 1){
            MetricsInput.text = metricsOptions[row]
            
            if(metricsOptions[row] == "Miles"){
                updateToMiles()
            }else if(metricsOptions[row] == "Kilometers"){
                updateToKM()
            }
        }else if (pickerView.tag == 2){
            durHour = String(pickerView.selectedRow(inComponent: 0))
            durMinutes = String(pickerView.selectedRow(inComponent: 1))
            durSeconds = String(pickerView.selectedRow(inComponent: 2))
            
            if(durSeconds.characters.count == 1){
                durSeconds = "0" + durSeconds
            }
            
            if(durMinutes.characters.count == 1){
                durMinutes = "0" + durMinutes
            }
            print(durHour)
            if(durHour == "0"){
                TimeInput.text = durMinutes + ":" + durSeconds
            }else{
                TimeInput.text = durHour + ":" + durMinutes + ":" + durSeconds
            }
            TimeInput.text = durHour + ":" + durMinutes + ":" + durSeconds
            //print(dateHour + ":" + dateMinutes + ":" + dateSeconds)
        }else if (pickerView.tag == 3){
            WeatherInput.text = weatherOptions[row]
        }else if (pickerView.tag == 4){
            paceMinutes = String(pickerView.selectedRow(inComponent: 0))
            paceSeconds = String(pickerView.selectedRow(inComponent: 1))
            
            if(paceSeconds.characters.count == 1){
                paceSeconds = "0" + paceSeconds
            }
            
            if(paceMinutes.characters.count == 1){
                paceMinutes = "0" + paceMinutes
            }
            PaceInput.text = paceMinutes + ":" + paceSeconds
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
        }else if (pickerView.tag == 4){
            if (component == 0) {
                rowTitle = String(minutes[row]) + "m"
            } else if (component == 1) {
                rowTitle = String(seconds[row]) + "s"
            }
        }
        return rowTitle
    }
}

