//
//  BaseLexiconViewController.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 21/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This class is a base class for view controllers (screens) in the lexicon part of the application. It ensures adding a vertical menu, search bar and subtitle for any screen in the lexicon part of the application.
*/
class BaseLexiconViewController: BaseViewController, UISearchBarDelegate{
    /// The delegate for going to a different screen (going to the main screen of the guide part of the application etc.)
    weak var flowDelegate: LexiconDelegate?
    /// The view where all elements on the screen are added.
    private var parentView: UIView!
    /// The boolean representing whether the parent view for all elements on the screen was changed.
    private var isParentViewChanged = false
    /// The subtitle of the screen (title of the animal, list of animals in a pavilion, biotope or continent etc.)
    var subtitleLabel: UILabel!
    /// The width of the vertical menu.
    var verticalMenuWidth: CGFloat = 70
    /// The view model for the search bar for getting the list of results.
    var baseLexiconViewModel = BaseLexiconViewModel(dependencies: AppDependency.shared)
    /// The popover which is shown after entering any character in the search bar.
    var searchResultsPopover: SearchResultsPopoverViewController! = nil
    /// The text for the subtitle describing the content of the actual screen.
    private var textForSubtitle: String = ""
    
    
    override init(){
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /**
     This function ensures setting the text of the subtitle
     - Parameters:
        - textForSubtitle: The text for the subtitle which describes the content of the actual screen.
    */
    func setTextForSubtitle(_ textForSubtitle: String){
        self.textForSubtitle = textForSubtitle
    }

    /**
     This function sets the parent view of all elements in the screen apart from the search bar. The view represents the main content of the screen without the search bar.
     - Parameters:
        - parentView: The view where all elements apart from the search bar are added.
    */
    func setParentView(parentView: UIView){
        self.parentView = parentView
        self.isParentViewChanged = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (!self.isParentViewChanged) {
            self.parentView = self.view
        }
        self.parentView.backgroundColor = Colors.screenBodyBackgroundColor.color
        
        /// Adding the search bar for searching screens
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = NSLocalizedString("searchScreen", comment: "")
        searchBar.sizeToFit()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        
        let typeOfViewController = type(of: self)
        let typeOfViewControllerString = String(describing: typeOfViewController)
        
        // counting and setting the correct top offset for the vertical menu
        let navigationBarHeight = self.navigationController?.navigationBar.frame.size.height ?? 0
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        var totalOffset = navigationBarHeight + statusBarHeight
        let topOffset = !self.isParentViewChanged ? totalOffset : 0
        
        let verticalMenu = UIVerticalMenu(width: Float(self.verticalMenuWidth), topOffset: topOffset, parentView: self.parentView)
        
        let goToGuideItem = UIVerticalMenuItem(actionString: "goToGuide", usedBackgroundColor: Colors.goToGuideOrLexiconButtonBackgroundColor.color)
        goToGuideItem.addTarget(self, action: #selector(goToGuideItemTapped(_:)), for: .touchUpInside)
        verticalMenu.addItem(goToGuideItem, height: 120, last: false)
        
        if (typeOfViewControllerString == "ClassViewController"){
            let classesItem = UIVerticalMenuItem(actionString: "classesSelected", usedBackgroundColor: Colors.selectedItemBackgroundColor.color)
            verticalMenu.addItem(classesItem, height: 90, last: false)
        } else {
            let classesItem = UIVerticalMenuItem(actionString: "classes", usedBackgroundColor: Colors.nonSelectedItemBackgroundColor.color)
            classesItem.addTarget(self, action: #selector(classesItemTapped(_:)), for: .touchUpInside)
            verticalMenu.addItem(classesItem, height: 90, last: false)
        }
        
        if (typeOfViewControllerString == "ContinentsViewController"){
            let continentsItem = UIVerticalMenuItem(actionString: "continentsSelected", usedBackgroundColor: Colors.selectedItemBackgroundColor.color)
            verticalMenu.addItem(continentsItem, height: 90, last: false)
        } else {
            let continentsItem = UIVerticalMenuItem(actionString: "continents", usedBackgroundColor: Colors.nonSelectedItemBackgroundColor.color)
            continentsItem.addTarget(self, action: #selector(continentsItemTapped(_:)), for: .touchUpInside)
            verticalMenu.addItem(continentsItem, height: 90, last: false)
        }
        
        if (typeOfViewControllerString == "BiotopesViewController") {
            let biotopesItem = UIVerticalMenuItem(actionString: "biotopesSelected", usedBackgroundColor: Colors.selectedItemBackgroundColor.color)
            verticalMenu.addItem(biotopesItem, height: 90, last: false)
        } else {
            let biotopesItem = UIVerticalMenuItem(actionString: "biotopes", usedBackgroundColor: Colors.nonSelectedItemBackgroundColor.color)
            biotopesItem.addTarget(self, action: #selector(biotopesItemTapped(_:)), for: .touchUpInside)
            verticalMenu.addItem(biotopesItem, height: 90, last: false)
        }
        
        if (typeOfViewControllerString == "KindsOfFoodViewController") {
            let kindsOfFoodItem = UIVerticalMenuItem(actionString: "kindsOfFoodSelected", usedBackgroundColor: Colors.selectedItemBackgroundColor.color)
            verticalMenu.addItem(kindsOfFoodItem, height: 90, last: false)
        } else {
            let kindsOfFoodItem = UIVerticalMenuItem(actionString: "kindsOfFood", usedBackgroundColor: Colors.nonSelectedItemBackgroundColor.color)
            verticalMenu.addItem(kindsOfFoodItem, height: 90, last: false)
        }
        
        if (typeOfViewControllerString == "PavilionsViewController") {
            let pavilionsItem = UIVerticalMenuItem(actionString: "pavilionsSelected", usedBackgroundColor: Colors.selectedItemBackgroundColor.color)
            verticalMenu.addItem(pavilionsItem, height: 90, last: false)
        } else {
            let pavilionsItem = UIVerticalMenuItem(actionString: "pavilions", usedBackgroundColor: Colors.nonSelectedItemBackgroundColor.color)
            pavilionsItem.addTarget(self, action: #selector(pavilionsItemTapped(_:)), for: .touchUpInside)
            verticalMenu.addItem(pavilionsItem, height: 90, last: false)
        }
        
        let helpItem = UIVerticalMenuItem(actionString: "help", usedBackgroundColor: Colors.helpButtonBackgroundColor.color)
        verticalMenu.addItem(helpItem, height: 90, last: true)
        
        
        let titleHeader = UITitleHeader(title: "lexiconTitle", menuInTheParentView: verticalMenu, parentView: self.parentView)
        
        
        if (self.textForSubtitle != "") {
            // creating the title of the screen
            let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width - 140, height: CGFloat.greatestFiniteMagnitude))
            subtitleLabel.text = self.textForSubtitle
            subtitleLabel.font = UIFont.boldSystemFont(ofSize: 30)
            subtitleLabel.numberOfLines = 0
            subtitleLabel.lineBreakMode = .byWordWrapping
            subtitleLabel.preferredMaxLayoutWidth = self.view.bounds.width - 140
            subtitleLabel.sizeToFit()
            self.parentView.addSubview(subtitleLabel)
            subtitleLabel.snp.makeConstraints{ (make) in
                make.top.equalTo(titleHeader.snp.bottom)
                make.centerX.equalToSuperview().offset(35)
            }
            self.subtitleLabel = subtitleLabel
        }
        
    }
    
    
    /**
     This function shows the list of screens whose title contains the text from the search bar. It binds the view controller with the view model (BaseLexiconViewModel) for getting the list of all screens. After starting of the action there are found screens whose title contains the text in the text field in the search bar at the top of the screen. It is called after each change of the text in the text field in the search bar. If this method is first called, the popover window is added to the actual screen.
     - Parameters:
        - searchBar: The search bar at the top of the screen.
        - searchText: The text in the text field in the search bar.
    */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        var screensInResult: [Screen] = []
        self.baseLexiconViewModel.getAllScreensAction.values.producer.startWithValues{ (screens) in
            for screen in screens {
                if (screen.title.contains(searchText)){
                    screensInResult.append(screen)
                }
            }
        }
        self.baseLexiconViewModel.getAllScreensAction.apply().start()

        if (searchResultsPopover == nil) {
            // counting and setting the correct top offset of the window with the results of searching screens.
            let navigationBarHeight = self.navigationController?.navigationBar.frame.size.height ?? 0
            let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
            var totalOffset = navigationBarHeight + statusBarHeight
            let topOffset = !isParentViewChanged ? totalOffset : 0
            
            
            self.searchResultsPopover = SearchResultsPopoverViewController(results: screensInResult)
            self.searchResultsPopover!.widthOfTable = self.view.bounds.size.width - 100
            self.searchResultsPopover!.flowDelegate = self.flowDelegate
            self.parentView.addSubview(self.searchResultsPopover!.view)
            self.searchResultsPopover!.view.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(topOffset)
                    make.centerX.equalToSuperview().offset(25)
                    make.width.equalToSuperview().offset(-100)
                    make.height.equalTo(350)
            }
        } else {
            self.searchResultsPopover!.setResults(screensInResult)
        }
    }
    
    
    // MARK - Actions
    
    
    /**
     This function ensures going to the main screen of the application (and also the main screen of the guide part of this application) after tapping the goToGuideItem item from the vertical menu.
     - Parameters:
     - sender: The item with this method as a target which was tapped.
     */
    @objc func goToGuideItemTapped(_ sender: UIVerticalMenuItem){
        flowDelegate?.goToGuide(in: self)
    }
    
    
    /**
     This function ensures going to the screen with the list of classes in which animals can belong after the tapping the classesItem item from the vertical menu.
     - Parameters:
     - sender: The item with this method as a target which was tapped.
     */
    @objc func classesItemTapped(_ sender: UIVerticalMenuItem){
        flowDelegate?.goToClasses(in: self)
    }
    
    
    /**
     This function ensures going to the screen with the list of biotopes in which animals can live after the tapping the classesItem item from the vertical menu.
     - Parameters:
        - sender: The item with this method as a target which was tapped.
     */
    @objc func biotopesItemTapped(_ sender: UIVerticalMenuItem){
        flowDelegate?.goToBiotopes(in: self)
    }
    
    /**
     This function ensures going to the screen with the list of all localities in the ZOO (especially pavilions) after the tapping the pavilionsItem item from the vertical menu.
     - Parameters:
        - sender: The item with this method as a target which was tapped.
    */
    @objc func pavilionsItemTapped(_ sender: UIVerticalMenuItem){
        flowDelegate?.goToPavilions(in: self)
    }

    
    /**
     This function ensures going to the screen with the list of all continents where animals could live including the option that there could be animals which don't live anywhere in nature after the tapping the pavilionsItem item from the vertical menu.
     - Parameters:
        - sender: The item with this method as a target which was tapped.
     */
    @objc func continentsItemTapped(_ sender: UIVerticalMenuItem) {
        flowDelegate?.goToContinents(in: self)
    }
}
