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
        //let healthDataToRead: Set([ HKObjectType.workoutType(), HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)])
        
        //let healthKitTypeToRead = Set(arrayLiteral: HKObjectType.workoutType(), HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning))
        
        let healthDataToRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!,
            HKObjectType.workoutType()
        ]

        
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
    
    func readRunningWorkouts(completion: (([AnyObject]?, NSError?) -> Void)!) {
        // 1. Predicate to read only running workouts
        let predicate =  HKQuery.predicateForWorkouts(with: HKWorkoutActivityType.running)
        // 2. Order the workouts by date
        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
        // 3. Create the query
        let sampleQuery = HKSampleQuery(sampleType: HKWorkoutType.workoutType(), predicate: predicate, limit: 0, sortDescriptors: [sortDescriptor]) {
            (sampleQuery, results, error ) -> Void in
            
            if completion != nil {
                completion(results, nil)
            }
        }
        // 4. Execute the query
        self.healthKitStore.execute(sampleQuery)
    }
    
}
