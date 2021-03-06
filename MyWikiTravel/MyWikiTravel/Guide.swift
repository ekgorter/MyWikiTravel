//
//  Guide.swift
//  MyWikiTravel
//
//  Created by Elias Gorter on 12-06-15.
//  Copyright (c) 2015 EliasGorter6052274. All rights reserved.
//
// Description of Guide entity in Core Data.

import Foundation
import CoreData

class Guide: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var guideContent: NSSet

    // Method allows creation of new guide.
    class func createInManagedObjectContext(moc: NSManagedObjectContext, title: String) -> Guide {
        let newGuide = NSEntityDescription.insertNewObjectForEntityForName("Guide", inManagedObjectContext: moc) as! Guide
        
        newGuide.title = title
        
        return newGuide
    }
}
