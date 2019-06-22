//
//  SettingInformationViewController.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 21/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

class SettingInformationViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    private var tableView: UITableView!
    private let sections = SaidInformationSettings.sections
    private var items: [[SaidInformationSettings]] = []
    weak var flowDelegate: GoBackDelegate?
    
    override init(){
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString(sections[section].title, comment: "")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCase = items[indexPath.section][indexPath.row]
        SettingsInformationViewModel.setActualSettings(selectedCase)
        flowDelegate?.goBackTapped(in: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items[section].count
    }
    
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        self.tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "settingsCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
