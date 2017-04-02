//
//  SummaryViewController.swift
//  My Last Run
//
//  Created by Mike Mariano on 3/25/17.
//  Copyright © 2017 Mike Mariano. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var SummaryCategory: UILabel!
    @IBOutlet weak var SummaryCategoryInput: UITextField!
    @IBOutlet weak var TotalDistanceInput: UITextField!
    @IBOutlet weak var TotalMetricInput: UITextField!
    @IBOutlet weak var TotalDurationInput: UITextField!
    @IBOutlet weak var AveragePaceInput: UITextField!
    @IBOutlet weak var CommentsInput: UITextField!
    
    var typeChoice:String! = ""
    var summaryDate:String! = ""
    var summaryDuration:String! = "00:00:00"
    var summaryPace:String! = "00:00:00"
    var parentVC:ViewController!
    var totalDistance:Double = 0
    
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
    var pacePicker = UIPickerView()
    
    // picker options
    var metricsOptions = ["Miles", "Kilometers"]
    var hours  = Array (0...23)
    var minutes = Array(0...59)
    var seconds = Array(0...59)
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateLabels()
        
        // Assign Tags to pickers
        picker.tag = 1
        timePicker.tag = 2
        pacePicker.tag = 4
        
        TotalDurationInput.delegate = self
        AveragePaceInput.delegate = self
        TotalDistanceInput.delegate = self
        SummaryCategoryInput.delegate = self
        CommentsInput.delegate = self
        
        picker.delegate = self
        picker.dataSource = self
        timePicker.delegate = self
        timePicker.dataSource = self
        pacePicker.delegate = self
        pacePicker.dataSource = self
        
        // Set which picker which input should use and hide the cursor
        TotalDurationInput.inputView = timePicker
        TotalDurationInput.tintColor = UIColor.clear
        
        TotalMetricInput.inputView = picker
        TotalMetricInput.tintColor = UIColor.clear
        
        AveragePaceInput.inputView = pacePicker
        AveragePaceInput.tintColor = UIColor.clear
        
        // Create tool bar for picker without Today button
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.blackTranslucent
        
        toolBar.tintColor = UIColor.white
        
        toolBar.backgroundColor = UIColor(red:169/255, green: 203/255, blue: 74/255, alpha: 1)
        
        
        let todayBtn = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ViewController.tappedToolBarBtn))
        
        let okBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(ViewController.donePressed))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(SummaryViewController.donePressed))
        
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
        TotalDistanceInput.inputAccessoryView = toolBar
        TotalMetricInput.inputAccessoryView = toolBar
        TotalDurationInput.inputAccessoryView = toolBar
        AveragePaceInput.inputAccessoryView = toolBar

    }
    
    // close the keyboard when custom toolbar done is pressed
    func donePressed(_ sender: UIBarButtonItem) {
        TotalDistanceInput.resignFirstResponder()
        TotalMetricInput.resignFirstResponder()
        TotalDurationInput.resignFirstResponder()
        AveragePaceInput.resignFirstResponder()
    }
    
    func updateLabels(){
        //print("Passed from parent: \(typeChoice)")
        SummaryCategory.text = typeChoice
        SummaryCategoryInput.text = summaryDate
        TotalDurationInput.text = summaryDuration
        AveragePaceInput.text = summaryPace
        TotalDistanceInput.text = String(totalDistance)
    }
    
    func milesToKilometers(speedInMPH:Double) ->Double {
        let speedInKPH = speedInMPH * 1.60934
        return speedInKPH as Double
    }
    
    func kilometersToMiles(speedInMPH:Double) ->Double {
        let speedInKPH = speedInMPH / 1.60934
        return speedInKPH as Double
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
    
    func updateToKM(){
        let distanceInMiles = Double(TotalDistanceInput.text!)
        if(distanceInMiles != nil){
            var distanceInKilometers = milesToKilometers(speedInMPH: distanceInMiles!)
            distanceInKilometers = distanceInKilometers.roundTo(places: 2)
            TotalDistanceInput.text = String(describing:distanceInKilometers)
            
            let duration = parseDuration(TotalDurationInput.text!)
            let pace = duration/distanceInKilometers
            print(pace)
            
            formatter.unitsStyle = .positional
            formatter.allowedUnits = [ .minute, .second ]
            formatter.zeroFormattingBehavior = [ .pad ]
            
            let convertedPace = formatter.string(from: pace)
            AveragePaceInput.text = convertedPace
        }
    }
    
    func updateToMiles(){
        let distanceInKm = Double(TotalDistanceInput.text!)
        if(distanceInKm != nil){
            var distanceInMiles = kilometersToMiles(speedInMPH: distanceInKm!)
            distanceInMiles = distanceInMiles.roundTo(places: 2)
            TotalDistanceInput.text = String(describing:distanceInMiles)
            
            let duration = parseDuration(TotalDurationInput.text!)
            let pace = duration/distanceInMiles
            print(pace)
            
            formatter.unitsStyle = .positional
            formatter.allowedUnits = [ .minute, .second ]
            formatter.zeroFormattingBehavior = [ .pad ]
            
            let convertedPace = formatter.string(from: pace)
            AveragePaceInput.text = convertedPace
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /*
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
 */
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        var rowNumber = 0
        
        if (pickerView.tag == 1){
            rowNumber = 1
        }else if (pickerView.tag == 2){
            rowNumber = 3
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
            TotalMetricInput.text = metricsOptions[row]
            
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
                TotalDurationInput.text = durMinutes + ":" + durSeconds
            }else{
                TotalDurationInput.text = durHour + ":" + durMinutes + ":" + durSeconds
            }
            TotalDurationInput.text = durHour + ":" + durMinutes + ":" + durSeconds
            //print(dateHour + ":" + dateMinutes + ":" + dateSeconds)
        }else if (pickerView.tag == 4){
            paceMinutes = String(pickerView.selectedRow(inComponent: 0))
            paceSeconds = String(pickerView.selectedRow(inComponent: 1))
            
            if(paceSeconds.characters.count == 1){
                paceSeconds = "0" + paceSeconds
            }
            
            if(paceMinutes.characters.count == 1){
                paceMinutes = "0" + paceMinutes
            }
            AveragePaceInput.text = paceMinutes + ":" + paceSeconds
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
