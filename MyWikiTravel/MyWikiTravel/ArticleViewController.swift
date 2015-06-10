//
//  ArticleViewController.swift
//  MyWikiTravel
//
//  Created by Elias Gorter on 08-06-15.
//  Copyright (c) 2015 EliasGorter6052274. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController, MediaWikiAPIProtocol {
    
    var article: Article!
    var onlineSource: Bool!
    var api: MediaWikiAPI!
    
    @IBOutlet weak var articleTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationItem.title = article.title
        api = MediaWikiAPI(delegate: self)
        if onlineSource == true {
            let correctedInput = article.title.stringByReplacingOccurrencesOfString(" ", withString: "%20")
            api.getArticleText(correctedInput)
        } else {
            self.articleTextView.text = "saved article"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func articleAPIResults(articleText: String) {
        dispatch_async(dispatch_get_main_queue(), {
            self.articleTextView.text = articleText
        })
    }
}
