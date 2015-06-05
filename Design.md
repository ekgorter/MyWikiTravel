# MyWikiTravel 
## *Technical Design Document*

---
### Essential & Optional Features
Essential:

* Searching and Reading WikiTravel Content
* Saving WikiTravel Content for Offline Access
* Organizing Collections of Saved Articles

Optional:

* Adding Offline Maps
* Multiple Languages
* Several Ways of Organizing Guides by Own Preference (Days, Countries, Cities)
* Custom Made UI

###User Interface Description

The User Interface currently consists mostly of table views, connected by a navigation controller. The root view is a table view displaying all made guides. A new guide may be created by pressing the "*new*" button in the top right corner. A UIAlert pop-up is displayed on the screen where the user may enter a name for the new guide, which is then added to the table. Pressing a guide in the table will segue to a new table view, where all saved articles of this guide are displayed. Pressing an article name allows users to read the article. To add articles to this guide, the user can press the "*add*" button in the top right corner. This segues to another table view where the user may enter a search term to search in through the contents of [wikitravel.org](www.wikitravel.org/en). The search results are displayed in the table. Pressing a search result will display the corresponding article. In the top right corner of this view is a "*save*" button, which allows users to add this article to their guide for offline use.

This is the very base of the app's functionality. The current interface is made primarily to allow working on implementing and testing the base funtionality. Once all essential funtionality works as required, the interface may be altered to be more appealing and to support more functionality. 

###Datasource

Most of the app's data is retrieved from [wikitravel.org](www.wikitravel.org/en). To retrieve this data, the app uses the **MediaWiki API**. This API is used by most Wiki sites. It allows the contents of the site to be searched and parsed. Most of it's data output is in the JSON format, which is a widely used format and swift has built-in functionality to handle it. The text in the articles is mostly in the wikitext or html format.

###Data Persistence

One of the main goals of this app is to be able to save online articles for offline reading. As most of the data making up the articles can be saved as one of the types supported by NSUserDefaults, this will be the first way of saving the required data. A more advanced way of data persistence in apps is using Core Data. This seems to be a difficult topic however, so it will only be looked into when time allows it or when there is no other easier way.

### (*current*) Classes and Methods

* MyGuidesViewController.swift

This viewcontroller controls the initial view of the app and the root view of the navigation controller. It contains a table that holds the names of all created guides. It also holds a *new* button in the navigation bar. Pressing this button will trigger the associated method which shows an UIAlert pop-up where the user can enter a name for a new guide. Pressing "*ok*" in this pop-up adds the new (empty) guide to the app. Pressing a guide name in the table will segue the view to the GuideViewController.

* GuideViewController.swift

This viewcontroller controls the view where the guide's contents are displayed in a tableview. Pressing an article name will segue to the ArticleViewController showing the (offline) saved contents of this article. Pressing the *add* button in the navigation bar will segue to the SearchViewController, where the user may search for new articles to add.

* SearchViewController.swift

This viewcontroller controls a table view where all search results are displayed. A search term may be entered in the search bar on the top of the screen. Searching calls the searchWikiTravel method inside the MediaWikiAPI class using the MediaWikiAPIProtocol. The method requires a string as input and returns an array of titles of articles that match the search input. The titles are displayed in the table view. Pressing an article title segues to the ArticleViewController, where the contents of this article (online) are displayed.

* ArticleViewController.swift 

This viewcontroller controls the view where the content of an article is displayed. This can either be saved content in the app or online content as retrieved from [wikitravel.org](www.wikitravel.org/en). The content is possibly displayed in either a web view or text view, this has not yet been researched. When the content being shown is not yet saved in the guide, a *save* button will be displayed in the navigation bar. Pressing this button will save an offline version of this article and add it to the current guide.

* Guide.swift

The main hierarchy in the app will be as follows: guides is an array of Guides, a Guide contains an array of Articles, an Article contains all relevant data of an article. This file contains the Guide struct. It will at least hold a variable for an array of Articles and a title, but other variables may be added such as images or dates. 

* Article.swift

This file holds the Article struct. This struct contains all relevant data retrieved from an article on [wikitravel.org](www.wikitravel.org/en). The method for making an Article or multiple Articles based on for example a search through [wikitravel.org](www.wikitravel.org/en) is declared here. 

* MediaWikiAPI.swift

All data for the Articles is retrieved from [wikitravel.org](www.wikitravel.org/en). This is done by using the MediaWiki API. This file contains the MediaWikiAPI class, wherein all methods for API actions are declared. Any call to the API is done through this class. Currently, it only contains the search method which takes a string as search term and uses the MediaWiki API to return all articles found with that search term. Later, other kinds of actions may be added.
