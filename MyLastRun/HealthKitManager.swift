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
    
}
