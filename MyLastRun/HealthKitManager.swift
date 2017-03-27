//
//  HealthKitManager.swift
//  My Last Run
//
//  Created by Mike Mariano on 2/12/17.
//  Copyright © 2017 Mike Mariano. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitManager {
    
    let healthKitStore: HKHealthStore = HKHealthStore()
    
    func authorizeHealthKit(completion: ((_ success: Bool, _ error: NSError?) -> Void)!) {
        
        let healthDataToRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!,
            HKObjectType.workoutType()
        ]
        
        if !HKHealthStore.isHealthDataAvailable() {
            print("Can't access HealthKit.")
        }
        /*
        healthKitStore.requestAuthorization(toShare: [], read: healthDataToRead) { (success, error) -> Void in
            completion?(true, error as NSError?)
        }
        */
        healthKitStore.requestAuthorization(toShare: [], read: healthDataToRead) { (success, error) -> Void in
            if( completion != nil ) {
                completion?(success, error as NSError?)
            }
        }
    }
    
    func readRunningWorkouts(completion: (([AnyObject]?, NSError?) -> Void)!) {

        let predicate =  HKQuery.predicateForWorkouts(with: HKWorkoutActivityType.running)
        
        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
        
        let sampleQuery = HKSampleQuery(sampleType: HKWorkoutType.workoutType(), predicate: predicate, limit: 0, sortDescriptors: [sortDescriptor]) {
            (sampleQuery, results, error ) -> Void in
            
            if let queryError = error {
                completion?(nil, queryError as NSError?)
                return
            }
            
            if completion != nil {
                completion(results, nil)
            }
        }
        
        self.healthKitStore.execute(sampleQuery)
    }
    
    func getMonthlyRuns(completion: (([AnyObject]?, NSError?) -> Void)!) {
        
        
        
        //let calendar = NSCalendar.current
        //let interval = NSDateComponents()
        //interval.day =
        
        let endDate = NSDate()
        let startDate = NSCalendar.current.date(byAdding: .month, value: -1, to: endDate as Date)
        
        let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)
        let predicate =  HKQuery.predicateForSamples(withStart: startDate, end: endDate as Date, options: [])
         //let predicate =  HKQuery.pr
        
        let sampleQuery = HKSampleQuery(sampleType: type!, predicate: predicate, limit: 0, sortDescriptors: nil) {
            (sampleQuery, results, error ) -> Void in
            
            if let queryError = error {
                completion?(nil, queryError as NSError?)
                return
            }
            
            if completion != nil {
                completion(results, nil)
            }
        }
        
        self.healthKitStore.execute(sampleQuery)
    
    }
    
    /*
    func perfromQueryForWeightSamples() {
        let endDate = NSDate()
        let startDate = NSCalendar.current.dateByAddingUnit(.CalendarUnitMonth,
                                                                      value: -2, toDate: endDate, options: nil)
        
        let weightSampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
        let predicate = HKQuery.predicateForSamplesWithStartDate(startDate,
                                                                 endDate: endDate, options: .None)
        
        let query = HKSampleQuery(sampleType: weightSampleType, predicate: predicate,
                                  limit: 0, sortDescriptors: nil, resultsHandler: {
                                    (query, results, error) in
                                    if !results {
                                        println("There was an error running the query: \(error)")
                                    }
                                    dispatch_async(dispatch_get_main_queue()) {
                                        self.weightSamples = results as! [HKQuantitySample]
                                        self.tableView.reloadData()
                                    }
        })
        self.healthStore?.executeQuery(query)
    }
 */
    
}
