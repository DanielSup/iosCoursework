//
//  SelectLocalityViewController.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 21/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This class represents the screen for setting the target locality.
 */
class SelectLocalityViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    /// The view model for getting the list of localities with known coordinates.
    private let selectLocalityViewModel: SelectLocalityViewModel
    /// The delegate for going back to the previous screen
    var flowDelegate: GoBackDelegate?
    /// The list of localities which user can visit.
    private var localityList: [Locality] = []
    /// The table view for viewing the list of localities.
    private var localityTableView: UITableView!
    
    
    /**
     - Parameters:
         - selectLocalityViewModel: The view model for getting data about localities with known coordinates where the user can go
    */
    init(selectLocalityViewModel: SelectLocalityViewModel){
        self.selectLocalityViewModel = selectLocalityViewModel
        super.init()
        self.setupBindingsWithViewModelActions()
        self.selectLocalityViewModel.getLocalities.apply().start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     There is binds the view controller with the action of the view model for getting of all locations with known coordinates from the view model.
    */
    override func setupBindingsWithViewModelActions() {
        self.selectLocalityViewModel.getLocalities.values.producer.startWithValues {
            (localityList) in
            self.localityList = localityList
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        self.localityTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        self.localityTableView.register(UITableViewCell.self, forCellReuseIdentifier: "localityCell")
        self.localityTableView.dataSource = self
        self.localityTableView.delegate = self
        self.view.addSubview(self.localityTableView)
    }
    
    
    /**
     - Parameters:
        - tableView: The table view in which the localities are shown.
        - section: The numeric index of the given section.
     - Returns: The number of localities + 1, because we want to enable to cancel selection.
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localityList.count + 1
    }
    
    
    /**
     - Parameters:
        - tableView: The table view where the returned cell is added.
        - indexPath: The object representing the index where the cell is added.
     - Returns: The cell with the title of locality or localized string representing cancelling of selection of the target locality.
    */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.localityTableView.dequeueReusableCell(withIdentifier: "localityCell", for: indexPath as IndexPath)
        cell.textLabel!.text = indexPath.row == 0 ? NSLocalizedString("cancelSelection", comment: ""): self.localityList[indexPath.row - 1].title
        return cell
    }
    
    
    /**
     - Parameters:
        - tableView: The table view where is the given cell for selecting a locality or cell for cancelling the previous selection of the target locality.
        - indexPath: The object representing the index where the selected cell is.
    */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0){
            SelectLocalityViewModel.selectedLocality = nil
        } else {
            SelectLocalityViewModel.selectedLocality = self.localityList[indexPath.row - 1]
        }
        flowDelegate?.goBack(in: self)
    }
    

}
