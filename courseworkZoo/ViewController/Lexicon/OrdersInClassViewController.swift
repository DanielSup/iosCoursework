//
//  OrdersInClassViewController.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 18/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This class is a view controller for the screen with orders in a class.
 */
class OrdersInClassViewController: BaseLexiconViewController, UITableViewDelegate, UITableViewDataSource {
    /// The view model with action for getting the list of orders in the given class
    private var ordersInClassViewModel: OrdersInClassViewModel
    /// The table view with orders in the given class.
    private var orderTableView: UITableView!
    /// The array of orders for the table view.
    private var orders: [Class] = []
    
    /**
     - Parameters:
        - ordersInClassViewModel: The view model with important action for getting the list of orders in the class.
    */
    init(ordersInClassViewModel: OrdersInClassViewModel){
        self.ordersInClassViewModel = ordersInClassViewModel
        super.init()
        self.setupBindingsWithViewModelActions()
        self.ordersInClassViewModel.getOrdersInClass.apply().start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     This function binds the view controller with the action for getting the list of orders in the class from the view model.
    */
    override func setupBindingsWithViewModelActions() {
        self.ordersInClassViewModel.getOrdersInClass.values.producer.startWithValues{
            (orders) in
            self.orders = orders
        }
    }

    override func viewDidLoad() {
        let textForSubtitle = NSLocalizedString("orderList", comment: "") + " " + self.ordersInClassViewModel.getParentClassTitle()
        super.setTextForSubtitle(textForSubtitle)
        
        super.viewDidLoad()
        
        // getting sizes of display and the height of the top bar with search
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        let subtitleHeight = super.subtitleLabel.bounds.size.height
        
        self.orderTableView = UITableView(frame: CGRect(x: super.verticalMenuWidth, y: barHeight + 180 + subtitleHeight, width: displayWidth - super.verticalMenuWidth, height: displayHeight - barHeight - subtitleHeight - 180))
        self.orderTableView.register(UITableViewCell.self, forCellReuseIdentifier: "orderCell")
        self.orderTableView.dataSource = self
        self.orderTableView.delegate = self
        self.view.addSubview(self.orderTableView)
    }
    
    
    /**
     This function ensures going to the screen with the list of animals in the selected order.
     - Parameters:
        - tableView: The table view with the list of orders in the class.
        - indexPath: The index of the selected cell (selected order).
    */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.flowDelegate?.goToAnimalsInOrder(in: self, order: self.orders[indexPath.row])
    }
    
    
    /**
     This function returns the number of orders in the selected class.
     - Parameters:
        - tableView: The table view with the orders in the class.
        - section: The index of the section (there is only one section).
     - Returns: The number of orders in the selected class.
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orders.count
    }
    
    
    /**
     This method ensures creating of the cell for the given index path by reusing a cell prototype.
     
     - Parameters:
     - tableView: The object representing the table view with the list of orders in the selected class.
     - indexPath: The object representing the index of the created cell
     
        - Returns: The object representing the cell for the given concrete index path.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.orderTableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath as IndexPath)
        cell.textLabel!.text = self.orders[indexPath.row].title
        return cell
    }
}
