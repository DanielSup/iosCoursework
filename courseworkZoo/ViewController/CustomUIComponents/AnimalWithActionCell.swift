//
//  UIAnimalWithActionCell.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 10/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import SnapKit

class ButtonWithAnimalProperty: UIButton{
    // The animal on the button.
    var animal: Animal? = nil
}

/**
 This class represents a table cell with a button for adding an animal to the actual path or removing an animal from the actual path.
*/
class AnimalWithActionCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let animalTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample animal"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let actionButton: ButtonWithAnimalProperty = {
        let button = ButtonWithAnimalProperty()
        button.setTitle(L10n.addToPath, for: .normal)
        button.setTitleColor(UIColor(red: 0, green: 128.0 / 255.0, blue: 1, alpha: 1), for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 13)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    func setupViews(){
        addSubview(animalTitleLabel)
        animalTitleLabel.snp.makeConstraints{
            (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(25)
        }
        addSubview(actionButton)
        actionButton.snp.makeConstraints{ (make) in
            make.top.equalTo(animalTitleLabel.snp.bottom)
            make.left.equalToSuperview().offset(25)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
}
