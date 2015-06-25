//
//  MyGuidesViewController.swift
//  MyWikiTravel
//
//  Created by Elias Gorter on 04-06-15.
//  Copyright (c) 2015 EliasGorter6052274. All rights reserved.
//
// Displays a table of created guides.

import UIKit

class MyGuidesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let coreData = CoreData()
    var guides = [Guide]()
    let cellIdentifier = "myGuidesCell"
    
    @IBOutlet weak var guidesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Guides"
        
        // Setup navigation bar.
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Papyrus", size: 25)!,  NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        // Retrieves all existing guides from Core Data.
        self.guides = coreData.fetchGuides()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guides.count
    }
    
    // Loads the tableview cells with the guide names.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! GuideCell
        let guide = guides[indexPath.row]
        
        cell.guideTitleLabel.text = guide.title
        
        return cell
    }
    
    // Deselect cell immediately after selection.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // Allows table cells to be deleted by swiping.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // Deletes guides.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == .Delete ) {
            let guideToDelete = guides[indexPath.row]
            
            coreData.delete(guideToDelete)
            self.guides = coreData.fetchGuides()
            guidesTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            coreData.save()
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
            
            // Check if any guidename is entered in textfield.
            if input.text != "" {
                var guideNames = [String]()
                for guide in self.guides {
                    guideNames.append(guide.title)
                }
                // Check if guidename already exists.
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
    
    // Create a new guide entity and display it in the table.
    func saveNewGuide(title : String) {
        let newGuide = coreData.createNewGuide(title)
        
        self.guides = coreData.fetchGuides()
        if let newGuideIndex = find(guides, newGuide) {
            let newGuideIndexPath = NSIndexPath(forRow: newGuideIndex, inSection: 0)
            guidesTableView.insertRowsAtIndexPaths([ newGuideIndexPath ], withRowAnimation: .Automatic)
            coreData.save()
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
