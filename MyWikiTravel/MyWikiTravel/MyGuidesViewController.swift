//
//  MyGuidesViewController.swift
//  MyWikiTravel
//
//  Created by Elias Gorter on 04-06-15.
//  Copyright (c) 2015 EliasGorter6052274. All rights reserved.
//

import UIKit

class MyGuidesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var guides = [String]()
    let cellIdentifier = "myGuidesCell"
    
    @IBOutlet weak var guidesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.translucent = false
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationItem.title = "My Guides"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guides.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! UITableViewCell
        let guide = guides[indexPath.row]
        
        cell.textLabel?.text = guide
        
        return cell
    }
    
    @IBAction func newButton(sender: AnyObject) {
        let alertController = UIAlertController(title: "New Guide", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        var input: UITextField!
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default,handler: nil))
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: { (action: UIAlertAction!) in
            if input.text != "" {
                self.guides.append(input.text)
                self.guidesTableView!.reloadData()
            }
        }))
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Enter Guide Name"
            input = textField
        }
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let guideViewController: GuideViewController = segue.destinationViewController as? GuideViewController {
            navigationItem.title = ""
            var guideIndex = guidesTableView!.indexPathForSelectedRow()!.row
            guideViewController.navigationItem.title = guides[guideIndex]
        }
    }
}
