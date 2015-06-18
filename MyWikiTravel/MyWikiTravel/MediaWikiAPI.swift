//
//  MediaWikiAPI.swift
//  MyWikiTravel
//
//  Created by Elias Gorter on 04-06-15.
//  Copyright (c) 2015 EliasGorter6052274. All rights reserved.
//
// All methods for communicating with MediaWiki API are defined here.

import Foundation

// Protocol defining methods for retrieving MediaWiki API results.
@objc protocol MediaWikiAPIProtocol {
    optional func searchAPIResults(search: NSArray)
    optional func articleAPIResults(articleText: String)
}

class MediaWikiAPI {
    var delegate: MediaWikiAPIProtocol
    
    init(delegate: MediaWikiAPIProtocol) {
        self.delegate = delegate
    }
    
    // Searches wikitravel.org with the inputted search term. Returns an array of article titles from JSON.
    func searchWikiTravel(searchTerm: String) {
        let urlPath = "http://wikitravel.org/wiki/en/api.php?format=json&action=query&list=search&srwhat=text&srsearch=\(searchTerm)"
        let url = NSURL(string: urlPath)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                println(error.localizedDescription)
            }
            var err: NSError?
            if let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary {
                if(err != nil) {
                    println("JSON Error \(err!.localizedDescription)")
                }
                if let searchResult: NSArray = jsonResult["query"]?["search"] as? NSArray {
                    self.delegate.searchAPIResults!(searchResult)
                }
            }
        })
        task.resume()
    }
    
    // Gets the text content of defined article from wikitravel.org.
    func getArticleText(articleTitle: String) {
        let urlPath = "http://wikitravel.org/wiki/en/api.php?format=json&action=query&prop=extracts&explaintext=true&titles=\(articleTitle)"
        let url = NSURL(string: urlPath)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                println(error.localizedDescription)
            }
            var err: NSError?
            if let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary {
                if(err != nil) {
                    println("JSON Error \(err!.localizedDescription)")
                }
                if let pages: NSDictionary = jsonResult["query"]?["pages"] as? NSDictionary {
                    if let id: String = pages.allKeys.first! as? String {
                        if let text: String = pages[id]!["extract"] as? String {
                            self.delegate.articleAPIResults!(text)
                        }
                    }
                }
            }
        })
        task.resume()
    }
    
    // ::TEST AREA::
    func getArticleImage(articleTitle: String) {
        let urlPath = "http://wikitravel.org/wiki/en/api.php?action=query&prop=images&titles=\(articleTitle)&format=json&imlimit=1&imdir=descending"
        let url = NSURL(string: urlPath)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                println(error.localizedDescription)
            }
            var err: NSError?
            if let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary {
                if(err != nil) {
                    println("JSON Error \(err!.localizedDescription)")
                }
                if let pages: NSDictionary = jsonResult["query"]?["pages"] as? NSDictionary {
                    if let id: String = pages.allKeys.first! as? String {
                        if let images: NSArray = pages[id]!["images"] as? NSArray {
                            if let imageLocation: String = images[0]["title"] as? String {
                                self.getArticleThumbnail(imageLocation.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
                            }
                        }
                    }
                }
            }
        })
        task.resume()
    }
    
    func getArticleThumbnail(imageLocation: String) {
        let urlPath = "http://wikitravel.org/wiki/en/api.php?action=query&titles=\(imageLocation)&prop=imageinfo&iiprop=url&iiurlwidth=60&format=json"
        let url = NSURL(string: urlPath)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                println(error.localizedDescription)
            }
            var err: NSError?
            if let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary {
                if(err != nil) {
                    println("JSON Error \(err!.localizedDescription)")
                }
                if let pages: NSDictionary = jsonResult["query"]?["pages"] as? NSDictionary {
                    if let imageInfo: NSArray = pages["-1"]?["imageinfo"] as? NSArray {
                        if let thumbUrl: String = imageInfo[0]["thumburl"] as? String {
                            println(thumbUrl)
                        }
                    }
                }
            }
        })
        task.resume()
    }
}