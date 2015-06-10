//
//  ArticleViewController.swift
//  MyWikiTravel
//
//  Created by Elias Gorter on 08-06-15.
//  Copyright (c) 2015 EliasGorter6052274. All rights reserved.
//
// Displays selected article content, from online or offline source.

import UIKit

class ArticleViewController: UIViewController, MediaWikiAPIProtocol {
    
    var article: Article!
    var onlineSource: Bool!
    var api: MediaWikiAPI!
    
    @IBOutlet weak var articleTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = article.title
        api = MediaWikiAPI(delegate: self)
        
        // Display either article text from online article or from saved article in app.
        if onlineSource == true {
            let correctedInput = article.title.stringByReplacingOccurrencesOfString(" ", withString: "%20")
            api.getArticleText(correctedInput)
        } else {
            self.articleTextView.text = "saved article"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Set text of textview to be the article text as retrieved from wikitravel.org.
    func articleAPIResults(articleText: String) {
        dispatch_async(dispatch_get_main_queue(), {
            self.articleTextView.text = articleText
        })
    }
}
