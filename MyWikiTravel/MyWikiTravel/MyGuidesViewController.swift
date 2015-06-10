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
    
    var guides = [String]()
    let cellIdentifier = "myGuidesCell"
    let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var guidesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "My Guides"
        // Navigation bar is not translucent to prevent problem with cells staying under bar.
        navigationController?.navigationBar.translucent = false
        // If any guides are stored in the app, these are displayed in the table.
        if let savedGuides = userDefaults.valueForKey("guides") as? [(String)] {
            self.guides = savedGuides
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Loads the tableview cells with the guide names.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guides.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! UITableViewCell
        let guide = guides[indexPath.row]
        cell.textLabel?.text = guide
        return cell
    }
    
    // Allows table cells to be deleted by swiping.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            self.guides.removeAtIndex(indexPath.row)
            self.userDefaults.setValue(self.guides, forKey: "guides")
            self.guidesTableView!.reloadData()
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
                self.guides.append(input.text)
                self.guidesTableView!.reloadData()
                self.userDefaults.setValue(self.guides, forKey: "guides")
            }
        }))
        // Implements textfield functionality.
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Enter Guide Name"
            input = textField
        }
        // Show pop-up window.
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // Opens selected guide in new view.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let guideViewController: GuideViewController = segue.destinationViewController as? GuideViewController {
            var guideIndex = guidesTableView!.indexPathForSelectedRow()!.row
            guideViewController.navigationItem.title = guides[guideIndex]
        }
    }
}
