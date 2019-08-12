//
//  LegendViewItem.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 08/08/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import SnapKit

/**
 This class represents an icon with the description in the legend under the map view with markers.
*/
class LegendViewItem: UIView {
    /// The name of the image of the icon.
    private var imageName: String
    /// The text of the legend.
    private var textOfTheLegend: String

    init(imageName: String, textOfTheLegend: String) {
        self.imageName = imageName
        self.textOfTheLegend = textOfTheLegend
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /**
     This function adds an image and the text of the item of the legend to the parent view.
    */
    func addImageAndText() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        imageView.image = UIImage(named: imageName)
        self.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(5)
        }
        
        let textOfTheLegendLabel = UILabel()
        textOfTheLegendLabel.text = self.textOfTheLegend
        textOfTheLegendLabel.lineBreakMode = .byWordWrapping
        textOfTheLegendLabel.numberOfLines = 0
        textOfTheLegendLabel.preferredMaxLayoutWidth = self.superview!.bounds.size.width - 88
        textOfTheLegendLabel.sizeToFit()
        self.addSubview(textOfTheLegendLabel)
        textOfTheLegendLabel.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(5)
            make.left.equalTo(imageView.snp.right).offset(15)
            make.bottom.equalToSuperview()
        }
    
    }
    
}
