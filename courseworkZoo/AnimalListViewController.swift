//
//  AnimalListViewController.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 19/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

protocol GoBackDelegate: class{
    func goBackTapped(in viewController: BaseViewController)
}

protocol GoToAnimalListDelegate: class{
    func goToAnimalListTapped(in viewController: ViewController)
}

class AnimalListViewController: BaseViewController {
    private var animalViewModel: AnimalViewModelling
    weak var flowDelegate: GoBackDelegate?
    
    
    init(viewModel: AnimalViewModelling){
        self.animalViewModel = viewModel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.animalViewModel = AnimalViewModel(dependencies: AppDependency.shared)
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let goBackToMapButton = UIButton()
        goBackToMapButton.setTitle("Zpet na mapu", for: .normal)
        goBackToMapButton.setTitleColor(.black, for: .normal)
        view.addSubview(goBackToMapButton)
        goBackToMapButton.snp.makeConstraints{
            (make) in
            make.right.equalTo(view)
            make.bottom.equalTo(view)
            make.height.equalTo(50)
        }
        goBackToMapButton.addTarget(self, action: #selector(goBackTapped(_:)), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    @objc
    func goBackTapped(_ sender: UIButton){
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
