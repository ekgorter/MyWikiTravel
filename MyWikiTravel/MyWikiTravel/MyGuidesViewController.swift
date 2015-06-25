//
//  MyGuidesViewController.swift
//  MyWikiTravel
//
//  Created by Elias Gorter on 04-06-15.
//  Copyright (c) 2015 EliasGorter6052274. All rights reserved.
//
// Displays a table of created guides.

import UIKit
import CoreData

class MyGuidesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Contains a list of all "Guide" entities stored in Core Data.
    var guides = [Guide]()
    let cellIdentifier = "myGuidesCell"
    // Required by Core Data to save data.
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet weak var guidesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Guides"
        // Navigation bar is not translucent to prevent problem with cells staying under bar.
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Papyrus", size: 25)!,  NSForegroundColorAttributeName: UIColor.whiteColor()]
        // Retrieves all existing guides from Core Data.
        fetchGuides()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Loads the tableview cells with the guide names.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guides.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! GuideCell
        let guide = guides[indexPath.row]
        cell.guideTitleLabel.text = guide.title
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // Allows table cells to be deleted by swiping.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == .Delete ) {
            // Find the guide object the user is trying to delete.
            let guideToDelete = guides[indexPath.row]
            
            // Delete it from the managedObjectContext.
            managedObjectContext?.deleteObject(guideToDelete)
            
            // Refresh the table view to indicate that it's deleted.
            self.fetchGuides()
            
            // Tell the table view to animate out that row.
            guidesTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            save()
        }
    }
    
    // Pressing the "new" button will show a pop-up window where a new guide name can be entered.
    @IBAction func newButton(sender: AnyObject) {
        // Create pop-up window with textfield.
        let alertController = UIAlertController(title: "New Guide", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        var input: UITextField!
        
        // Add Cancel and Ok buttons, pressing Ok will create and add guide.
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default,handler: nil))
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: { (action: UIAlertAction!) in
            // If any guidename is entered in textfield.
            if input.text != "" {
                var guideNames = [String]()
                for guide in self.guides {
                    guideNames.append(guide.title)
                }
                if contains(guideNames, input.text) == false {
                    self.saveNewGuide(input.text)
                }
            }
        }))
        // Implements textfield functionality.
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Enter Guide Name"
            textField.autocapitalizationType = .Sentences
            input = textField
        }
        // Show pop-up window.
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // Retrieve all existing guides from Core Data.
    func fetchGuides() {
        let fetchRequest = NSFetchRequest(entityName: "Guide")
        
        // Create a sort descriptor object that sorts on the "title" property of the Core Data object.
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        // Set the list of sort descriptors in the fetch request, so it includes the sort descriptor.
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Fetch all "Guide" entities from Core Data.
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Guide] {
            guides = fetchResults
        }
    }
    
    // Create a new guide entity and display it in the table.
    func saveNewGuide(title : String) {
        // Create the new guide entity.
        var newGuide = Guide.createInManagedObjectContext(self.managedObjectContext!, title: title)
        
        // Update the array containing the table view row data.
        self.fetchGuides()
        
        // Use Swift's find() function to figure out the index of the new guide after it's been added and sorted in our guides array.
        if let newGuideIndex = find(guides, newGuide) {
            // Create an NSIndexPath from the newGuideIndex
            let newGuideIndexPath = NSIndexPath(forRow: newGuideIndex, inSection: 0)
            // Animate in the insertion of this row
            guidesTableView.insertRowsAtIndexPaths([ newGuideIndexPath ], withRowAnimation: .Automatic)
            // Save in Core Data.
            save()
        }
    }
    
    // Saves data to Core Data.
    func save() {
        var error : NSError?
        if(managedObjectContext!.save(&error) ) {
            println(error?.localizedDescription)
        }
    }
    
    // Opens selected guide in new view.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let guideViewController: GuideViewController = segue.destinationViewController as? GuideViewController {
            var guideIndex = guidesTableView!.indexPathForSelectedRow()!.row
            guideViewController.title = guides[guideIndex].title 
        }
    }
}
