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
    /// The attributed string for subtitle which is set for the title of the screen for showing the list of animals in a pavilion
    private var attributedStringForSubtitle: NSAttributedString?
    
    
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
     This function sets the attributed string for the subtitle.
     - Parameters:
        - attributedStringForSubtitle: The attributed string for subtitle.
    */
    func setAttributedStringForSubtitle(_ attributedStringForSubtitle: NSAttributedString){
        self.attributedStringForSubtitle = attributedStringForSubtitle
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
        searchBar.placeholder = L10n.searchScreen
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
        
        let verticalMenu = VerticalMenu(width: Float(self.verticalMenuWidth), topOffset: topOffset, parentView: self.parentView)
        
        let goToGuideItem = VerticalMenuItem(actionString: "goToGuide", actionText: L10n.goToGuide, usedBackgroundColor: Colors.goToGuideOrLexiconButtonBackgroundColor.color)
        goToGuideItem.addTarget(self, action: #selector(goToGuideItemTapped(_:)), for: .touchUpInside)
        verticalMenu.addItem(goToGuideItem, height: 120, last: false)
        
        if (typeOfViewControllerString == "ClassViewController"){
            let classesItem = VerticalMenuItem(actionString: "classesSelected", actionText: L10n.classes, usedBackgroundColor: Colors.selectedItemBackgroundColor.color)
            verticalMenu.addItem(classesItem, height: 90, last: false)
        } else {
            let classesItem = VerticalMenuItem(actionString: "classes", actionText: L10n.classes, usedBackgroundColor: Colors.nonSelectedItemBackgroundColor.color)
            classesItem.addTarget(self, action: #selector(classesItemTapped(_:)), for: .touchUpInside)
            verticalMenu.addItem(classesItem, height: 90, last: false)
        }
        
        if (typeOfViewControllerString == "ContinentsViewController"){
            let continentsItem = VerticalMenuItem(actionString: "continentsSelected", actionText: L10n.continents, usedBackgroundColor: Colors.selectedItemBackgroundColor.color)
            verticalMenu.addItem(continentsItem, height: 90, last: false)
        } else {
            let continentsItem = VerticalMenuItem(actionString: "continents", actionText: L10n.continents, usedBackgroundColor: Colors.nonSelectedItemBackgroundColor.color)
            continentsItem.addTarget(self, action: #selector(continentsItemTapped(_:)), for: .touchUpInside)
            verticalMenu.addItem(continentsItem, height: 90, last: false)
        }
        
        if (typeOfViewControllerString == "BiotopesViewController") {
            let biotopesItem = VerticalMenuItem(actionString: "biotopesSelected", actionText: L10n.biotopes, usedBackgroundColor: Colors.selectedItemBackgroundColor.color)
            verticalMenu.addItem(biotopesItem, height: 90, last: false)
        } else {
            let biotopesItem = VerticalMenuItem(actionString: "biotopes", actionText: L10n.biotopes, usedBackgroundColor: Colors.nonSelectedItemBackgroundColor.color)
            biotopesItem.addTarget(self, action: #selector(biotopesItemTapped(_:)), for: .touchUpInside)
            verticalMenu.addItem(biotopesItem, height: 90, last: false)
        }
        
        if (typeOfViewControllerString == "KindsOfFoodViewController") {
            let kindsOfFoodItem = VerticalMenuItem(actionString: "kindsOfFoodSelected", actionText: L10n.kindsOfFood, usedBackgroundColor: Colors.selectedItemBackgroundColor.color)
            verticalMenu.addItem(kindsOfFoodItem, height: 90, last: false)
        } else {
            let kindsOfFoodItem = VerticalMenuItem(actionString: "kindsOfFood", actionText: L10n.kindsOfFood, usedBackgroundColor: Colors.nonSelectedItemBackgroundColor.color)
            kindsOfFoodItem.addTarget(self, action: #selector(kindsOfFoodItemTapped(_:)), for: .touchUpInside)
            verticalMenu.addItem(kindsOfFoodItem, height: 90, last: false)
        }
        
        if (typeOfViewControllerString == "PavilionsViewController") {
            let pavilionsItem = VerticalMenuItem(actionString: "pavilionsSelected", actionText: L10n.pavilions, usedBackgroundColor: Colors.selectedItemBackgroundColor.color)
            verticalMenu.addItem(pavilionsItem, height: 90, last: false)
        } else {
            let pavilionsItem = VerticalMenuItem(actionString: "pavilions", actionText: L10n.pavilions, usedBackgroundColor: Colors.nonSelectedItemBackgroundColor.color)
            pavilionsItem.addTarget(self, action: #selector(pavilionsItemTapped(_:)), for: .touchUpInside)
            verticalMenu.addItem(pavilionsItem, height: 90, last: false)
        }
        
        let helpItem = VerticalMenuItem(actionString: "help", actionText: L10n.help, usedBackgroundColor: Colors.helpButtonBackgroundColor.color)
        verticalMenu.addItem(helpItem, height: 90, last: true)
        
        
        let titleHeader = TitleHeader(title: L10n.lexiconTitle, menuInTheParentView: verticalMenu, parentView: self.parentView)
        
        
        if (self.textForSubtitle != "" || self.attributedStringForSubtitle != nil) {
            // creating the title of the screen
            let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width - 140, height: CGFloat.greatestFiniteMagnitude))
            
            if (self.textForSubtitle != ""){
                subtitleLabel.text = self.textForSubtitle
                subtitleLabel.font = UIFont.boldSystemFont(ofSize: 30)
            } else if (self.attributedStringForSubtitle != nil){
                subtitleLabel.attributedText = self.attributedStringForSubtitle!
            }
            
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
        self.baseLexiconViewModel.getAllScreens.values.producer.startWithValues{ (screens) in
            for screen in screens {
                if (screen.title.contains(searchText)){
                    screensInResult.append(screen)
                }
            }
        }
        self.baseLexiconViewModel.getAllScreens.apply().start()

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
    @objc func goToGuideItemTapped(_ sender: VerticalMenuItem){
        flowDelegate?.goToGuide(in: self)
    }
    
    
    /**
     This function ensures going to the screen with the list of classes in which animals can belong after the tapping the classesItem item from the vertical menu.
     - Parameters:
     - sender: The item with this method as a target which was tapped.
     */
    @objc func classesItemTapped(_ sender: VerticalMenuItem){
        flowDelegate?.goToClasses(in: self)
    }
    
    
    /**
     This function ensures going to the screen with the list of biotopes in which animals can live after the tapping the classesItem item from the vertical menu.
     - Parameters:
        - sender: The item with this method as a target which was tapped.
     */
    @objc func biotopesItemTapped(_ sender: VerticalMenuItem){
        flowDelegate?.goToBiotopes(in: self)
    }
    
    /**
     This function ensures going to the screen with the list of all localities in the ZOO (especially pavilions) after the tapping the pavilionsItem item from the vertical menu.
     - Parameters:
        - sender: The item with this method as a target which was tapped.
    */
    @objc func pavilionsItemTapped(_ sender: VerticalMenuItem){
        flowDelegate?.goToPavilions(in: self)
    }

    
    /**
     This function ensures going to the screen with the list of all continents where animals could live including the option that there could be animals which don't live anywhere in nature after the tapping the pavilionsItem item from the vertical menu.
     - Parameters:
        - sender: The item with this method as a target which was tapped.
     */
    @objc func continentsItemTapped(_ sender: VerticalMenuItem) {
        flowDelegate?.goToContinents(in: self)
    }
    
    
    /**
     This function ensures going to the screen with the list of kinds of food after the tapping the pavilionsItem item from the vertical menu.
     - Parameters:
        - sender: The item with this method as a target which was tapped.
     */
    @objc func kindsOfFoodItemTapped(_ sender: VerticalMenuItem) {
        flowDelegate?.goToKindsOfFood(in: self)
    }
}
