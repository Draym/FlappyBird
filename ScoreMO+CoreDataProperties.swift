//
//  ScoreMO+CoreDataProperties.swift
//  FlappyBird
//
//  Created by Admin on 03/12/2016.
//  Copyright © 2016 Fullstack.io. All rights reserved.
//

import Foundation
import CoreData


extension ScoreMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ScoreMO> {
        return NSFetchRequest<ScoreMO>(entityName: "ScoreMO");
    }

    @NSManaged public var mode: String?
    @NSManaged public var score: Int32
    
    // MARK: Core Data Paths
    static let ApplicationSupportDirectory = FileManager().urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    static let StoreURL = ApplicationSupportDirectory.appendingPathComponent("FlappyBird.sqlite")
}
