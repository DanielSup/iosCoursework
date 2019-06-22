//
//  SelectLocalityViewController.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 21/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

class SelectLocalityViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    private let selectLocalityViewModel: SelectLocalityViewModel
    var flowDelegate: GoBackDelegate?
    private var localityList: [Locality] = []
    private var localityTableView: UITableView!
    init(selectLocalityViewModel: SelectLocalityViewModel){
        self.selectLocalityViewModel = selectLocalityViewModel
        super.init()
        self.selectLocalityViewModel.getLocalitiesAction.values.producer.startWithValues {
            (localityList) in
            self.localityList = localityList
        }
        self.selectLocalityViewModel.getLocalitiesAction.apply().start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        self.localityTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        self.localityTableView.register(UITableViewCell.self, forCellReuseIdentifier: "localityCell")
        self.localityTableView.dataSource = self
        self.localityTableView.delegate = self
        self.view.addSubview(self.localityTableView)
        
        self.view.backgroundColor = .white        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localityList.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.localityTableView.dequeueReusableCell(withIdentifier: "localityCell", for: indexPath as IndexPath)
        cell.textLabel!.text = indexPath.row == 0 ? NSLocalizedString("cancelSelection", comment: ""): self.localityList[indexPath.row - 1].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0){
            SelectLocalityViewModel.selectedLocality = nil
        } else {
            SelectLocalityViewModel.selectedLocality = self.localityList[indexPath.row - 1]
        }
        flowDelegate?.goBackTapped(in: self)
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
