//
//  PathWithActionsCell.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 24/08/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import SnapKit

class ButtonWithPathProperty: UIButton {
    /// The path on the button.
    var path: Path?
}


/**
 This class represents a table view cell with a button for removing the path and a button for selecting the path as the actual.
*/
class PathWithActionsCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     The label with the title of the saved path.
    */
    let pathTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample path"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /**
     The button for selecting the path for setting up the animals.
    */
    let selectButton: ButtonWithPathProperty = {
        let button = ButtonWithPathProperty()
        button.setTitle(L10n.selectPath, for: .normal)
        button.setTitleColor(UIColor(red: 0, green: 128.0 / 255.0, blue: 1, alpha: 1), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    /**
     The button for removing the saved path.
    */
    let removeButton: ButtonWithPathProperty = {
        let button = ButtonWithPathProperty()
        button.setTitle(L10n.removePath, for: .normal)
        button.setTitleColor(UIColor(red: 1.0, green: 128.0 / 255.0, blue: 0, alpha: 1), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /**
     This function adds the views to the parent view - cell in the table and adds constraints to the views.
    */
    func setupViews() {
        addSubview(pathTitleLabel)
        pathTitleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
        
        addSubview(selectButton)
        selectButton.snp.makeConstraints { (make) in
            make.top.equalTo(pathTitleLabel.snp.bottom)
            make.left.equalToSuperview().offset(20)
        }
        
        addSubview(removeButton)
        removeButton.snp.makeConstraints { (make) in
            make.top.equalTo(selectButton.snp.bottom)
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-5)
        }
    }

}
