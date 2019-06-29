//
//  AppFlowCoordinator.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 19/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

class AppFlowCoordinator: BaseFlowCoordinator {
    public var childCoordinators = [BaseFlowCoordinator]()
    
    weak var navigationController: UINavigationController!
    
    func start(in window: UIWindow){
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        self.navigationController = navigationController
        let vm = MainViewModel(dependencies: AppDependency.shared)
        let vc1 = MainViewController(mainViewModel: vm)
        vc1.flowDelegate = self
        navigationController.setViewControllers([vc1], animated: true)
    }
}


extension AppFlowCoordinator: MainDelegate{
    
    func goToAnimalListTapped(in viewController: BaseViewController){
        let vm = AnimalListViewModel(dependencies: AppDependency.shared)
        let vc = AnimalListViewController(animalListViewModel: vm)
        vc.flowDelegate = self
        vc.animalDetailFlowDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func goForSelectionOfLocality(in viewController: BaseViewController){
        let vm = SelectLocalityViewModel(dependencies: AppDependency.shared)
        let vc = SelectLocalityViewController(selectLocalityViewModel: vm)
        vc.flowDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToSettings(in viewController: BaseViewController){
        let vc = SettingInformationViewController()
        vc.flowDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension AppFlowCoordinator: GoToAnimalDetailDelegate{
    func goToAnimalDetail(in viewController: BaseViewController, to animal: Animal){
        let vm = AnimalDetailViewModel(animal: animal, dependencies: AppDependency.shared)
        let vc = AnimalDetailViewController(animal: animal, animalDetailViewModel: vm)
        vc.flowDelegate = self
        navigationController?.pushViewController(vc, animated: true)
        
    }
}


extension AppFlowCoordinator: GoBackDelegate{
    func goBackTapped(in viewController: BaseViewController){
        navigationController.popViewController(animated: true)
    }
}
