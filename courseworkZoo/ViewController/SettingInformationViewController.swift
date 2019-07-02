//
//  SettingInformationViewController.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 21/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit


/**
 This class represents the screen on which the user can set the information about the close animal which will be machine-read. This class ensures showing the options for setting of the information in a table with three sections (no information, elementary information and advanced information).
 */
class SettingInformationViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    /// The table view used for showing the options for setting the machine-read information.
    private var tableView: UITableView!
    /// The array with three basic sections (no information, elementary information and advanced information)
    private let sections = SaidInformationSettings.sections
    /// The array of sections where each section is represented by an array in which items belonging to the section are saved.
    private var items: [[SaidInformationSettings]] = []
    /// The delegate for going back to the previous screen.
    var flowDelegate: GoBackDelegate?
    
    
    /**
     There are loaded all sections and all possible settings of machine-read information. All possible settings are divided to sections by almost equal operator.
    */
    override init(){
        // Saving of all possible options of setting the machine-read information to the items array.
        for section in sections {
            var casesInSection: [SaidInformationSettings] = []
            for actualCase in SaidInformationSettings.allCases{
                if (actualCase =+-= section){
                    casesInSection.append(actualCase)
                }
            }
            items.append(casesInSection)
        }
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        // setting up the table view
        self.tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "settingsCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)
    }
    
    
    /**
     This function is used for showing the title of the section.
     - Parameters:
        - tableView: The table where the given section is shown.
        - section: The numeric index of the given section
     - Returns: The localized string in which is saved the localized title of the given section.
    */
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString(sections[section].title, comment: "")
    }
    
    
    /**
     This function handles the selecting the given option.
     - Parameters:
        - tableView: The table with sections and options for setting the machine-read information
        - indexPath: The object representing the index of the selected cell (index of section and index of row in the given section)
    */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCase = items[indexPath.section][indexPath.row]
        SettingsInformationViewModel.setActualSettings(selectedCase)
        flowDelegate?.goBackTapped(in: self)
    }
    
    
    /**
     - Parameters:
        - tableView: The table view with sections for setting the machine-read information.
     - Returns: The number of sections for setting the machine-read information. In this case this function returns 3, but this number can change with modifies of the items of the SaidInformationSettings enum.
    */
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count
    }
    
    
    /**
     - Parameters:
        - tableView: The table view with sections and cells for setting the machine-read information.
        - section: The numeric index of the given section
     - Returns: The number of options for setting of the machinely said information within the given section.
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items[section].count
    }
    
    
    /**
     - Parameters:
        - tableView: The table view with sections and cells for setting the machine-read information about the close animal
        - indexPath: The obect representing the index of the given cell with number of section and number of the cell within the given section.
     - Returns: The cell which will be shown in the table view at the given index
    */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath as IndexPath)
        let value = self.items[indexPath.section][indexPath.row].subtitle
        cell.textLabel!.text = NSLocalizedString(value, comment: "")
        if (self.items[indexPath.section][indexPath.row] == SettingsInformationViewModel.getActualSettings()){
            cell.textLabel?.backgroundColor = .yellow
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        }
        return cell
    }
    
}
