//
//  SearchViewController.swift
//  MyWikiTravel
//
//  Created by Elias Gorter on 04-06-15.
//  Copyright (c) 2015 EliasGorter6052274. All rights reserved.
//
// Allows user to search wikitravel.org for articles. Search results are displayed in table.

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, MediaWikiAPIProtocol {
    
    var searchResults = [String]()
    var guide: Guide!
    let cellIdentifier = "searchResultCell"
    var api: MediaWikiAPI!
    
    @IBOutlet weak var articleSearchBar: UISearchBar!
    
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uses the MediaWiki API to get data from wikitravel.org.
        api = MediaWikiAPI(delegate: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Show search results in cells of tableview.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! UITableViewCell!
        let article = searchResults[indexPath.row]
        cell.textLabel?.text = article
        return cell
    }
    
    // Displays the the results of the inputted search term in the tableview.
    func searchAPIResults(searchResult: NSArray) {
        dispatch_async(dispatch_get_main_queue(), {
            self.searchResults = self.articlesFromJson(searchResult)
            self.searchResultsTableView!.reloadData()
        })
    }
    
    func articlesFromJson(searchResult: NSArray) -> [String] {
        var articles = [String]()
        if searchResult.count>0 {
            for result in searchResult {
                let title = result["title"] as? String
                
                articles.append(title!)
            }
        }
        return articles
    }
    
    // Searches wikitravel.org with inputted search term.
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        api.searchWikiTravel(articleSearchBar.text.stringByReplacingOccurrencesOfString(" ", withString: "%20"))
    }
    
    // Displays selected article contents in new view.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let articleViewController: ArticleViewController = segue.destinationViewController as? ArticleViewController {
            var articleIndex = searchResultsTableView!.indexPathForSelectedRow()!.row
            articleViewController.onlineSource = true
            articleViewController.article = searchResults[articleIndex]
            articleViewController.guide = guide
        }
    }
}
