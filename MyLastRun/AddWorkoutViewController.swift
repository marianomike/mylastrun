//
//  AddWorkoutViewController.swift
//  My Last Run
//
//  Created by Mike Mariano on 2/18/17.
//  Copyright © 2017 Mike Mariano. All rights reserved.
//

import UIKit
import HealthKit

class AddWorkoutViewController: UITableViewController, UINavigationControllerDelegate {
    
    var workouts = [HKWorkout]()
    let healthManager:HealthKitManager = HealthKitManager()
    let formatter = DateComponentsFormatter()
    var passedInt = 0
    var selectedInt: Int!
    //var delegate: SendDataDelegate?
    
    var selectedDate: String!
    var selectedDistance: String!
    var selectedDuration: String!
    var selectedPace: String!
    var selectedDateObject = Date()
    
    @IBOutlet weak var BtnCancel: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        print(passedInt)
        
        // set the title of the view
        navigationItem.title = "CHOOSE RUN"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 169/255, green: 203/255, blue: 74/255, alpha: 1.0)]

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        //getAllRuns()
        populateRuns()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateRuns(){
        if(self.workouts.count != 0){
            self.tableView.reloadData()
            self.setDefault(defaultInt: self.passedInt)
        }
    }
    
    func setDefault(defaultInt: Int){
        let indexPath = IndexPath(row: defaultInt, section: 0)
        self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
        
        self.selectedDate = String(describing: self.convertDate(date: self.workouts[defaultInt].startDate))
        self.selectedDistance = String(describing: self.convertKMToMiles(distance: self.workouts[defaultInt].totalDistance!))
        self.selectedDuration = String(describing: self.convertDuration(duration: self.workouts[defaultInt].duration))
        self.selectedPace = String(describing: self.calculatePace(distance: self.workouts[defaultInt].totalDistance!, duration: self.workouts[defaultInt].duration))
        
        self.selectedDateObject = self.workouts[defaultInt].startDate
        self.selectedInt = defaultInt
    }
    
    @IBAction func CancelAdd(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
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
        let distanceFormatter = LengthFormatter()
        var distanceInKM = distance.doubleValue(for: HKUnit.mile())
        distanceInKM = distanceInKM.roundTo(places: 2)
        var convertedMiles = distanceFormatter.string(fromValue: distanceInKM, unit: LengthFormatter.Unit.mile)
        convertedMiles = String(convertedMiles.characters.dropLast(3))
        return convertedMiles
    }
    
    func calculatePace(distance: HKQuantity, duration: TimeInterval) -> String{
        let distanceInKM = distance.doubleValue(for: HKUnit.mile())
        let pace = duration/distanceInKM
        
        let formatter = DateComponentsFormatter()
        
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
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if workouts.count > 0 {
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = .singleLine
            return 1
        }
        
        let rect = CGRect(x: 0,
                          y: 0,
                          width: self.tableView.bounds.size.width,
                          height: self.tableView.bounds.size.height)
        let noDataLabel: UILabel = UILabel(frame: rect)
        
        noDataLabel.text = "No run data in Apple Health."
        noDataLabel.textColor = UIColor.lightGray
        noDataLabel.textAlignment = NSTextAlignment.center
        self.tableView.backgroundView = noDataLabel
        self.tableView.separatorStyle = .none
        
        return 0
    }


    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return workouts.count
    }

    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RunCell", for: indexPath)
        
        let workout = workouts[indexPath.row]
        let startDate = convertDate(date: workout.startDate)
        if(workout.totalDistance != nil){
            let distance = convertKMToMiles(distance: workout.totalDistance!)
            
            cell.textLabel?.text = startDate
            cell.detailTextLabel?.text = distance + " m"
        }

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        //print(index)
        //let cell: UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedDate = String(describing: convertDate(date: workouts[index].startDate))
        selectedDistance = String(describing: convertKMToMiles(distance: workouts[index].totalDistance!))
        selectedDuration = String(describing: convertDuration(duration: workouts[index].duration))
        selectedPace = String(describing: calculatePace(distance: self.workouts[index].totalDistance!, duration: self.workouts[index].duration))
        
        selectedDateObject = self.workouts[index].startDate
        selectedInt = index

        //print(selectedDate)
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? ViewController {
            controller.selectedRun = selectedInt
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 */
    

}
