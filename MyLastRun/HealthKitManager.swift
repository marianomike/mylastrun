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
        
        // State the health data type(s) we want to read from HealthKit.
        //let healthDataToRead = Set(arrayLiteral: HKWorkoutType(forIdentifier: HKQuantityTypeIdentifier.)!)
        let healthDataToRead: Set<HKObjectType> = Set([ HKObjectType.workoutType() ])
        
        // State the health data type(s) we want to write from HealthKit.
        //let healthDataToWrite = Set(arrayLiteral: HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!)
        
        // Just in case OneHourWalker makes its way to an iPad...
        if !HKHealthStore.isHealthDataAvailable() {
            print("Can't access HealthKit.")
        }
        
        // Request authorization to read and/or write the specific data.
        healthKitStore.requestAuthorization(toShare: [], read: healthDataToRead) { (success, error) -> Void in
            completion?(true, error as NSError?)
        }
    }
    
    func getLastWorkout(sampleType: HKSampleType , completion: ((HKSample?, NSError?) -> Void)!) {
        
        // Predicate for the height query
        let distantPastWorkout = NSDate.distantPast as NSDate
        let currentDate = NSDate()
        let lastWorkoutPredicate = HKQuery.predicateForSamples(withStart: distantPastWorkout as Date, end: currentDate as Date, options: [])
        
        // Get the single most recent height
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        // Query HealthKit for the last Height entry.
        let workoutQuery = HKSampleQuery(sampleType: sampleType, predicate: lastWorkoutPredicate, limit: 1, sortDescriptors: [sortDescriptor]) { (sampleQuery, results, error ) -> Void in
            
            /*
            if let queryError = error {
                completion(nil, queryError)
                return
            }
 */
            
            // Set the first HKQuantitySample in results as the most recent height.
            let lastWorkout = results!.first
            
            if completion != nil {
                completion(lastWorkout, nil)
            }
        }
        
        // Time to execute the query.
        self.healthKitStore.execute(workoutQuery)
    }
    
}
