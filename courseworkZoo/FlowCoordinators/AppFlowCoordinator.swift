//
//  AppFlowCoordinator.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 19/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This class is used as a main flow coordinator. It determines the first screen after the launchscreen and further transitions between screens.
 */
class AppFlowCoordinator: BaseFlowCoordinator {
    
    weak var navigationController: UINavigationController!
    
    /**
     This function starts the application by the screen created in MainViewController.
     - Parameters:
        - window: The window representing the actual screen
    */
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
    
    /**
     This function ensures the transition to the list fo animals.
     - Parameters:
        - viewController: The ViewController which created the actual screen.
    */
    func goToAnimalListTapped(in viewController: BaseViewController){
        let vm = AnimalListViewModel(dependencies: AppDependency.shared)
        let vc = AnimalListViewController(animalListViewModel: vm)
        vc.animalDetailFlowDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    /**
     This function ensures the transition to the screen for selecting the target locality.
     - Parameters:
        - viewController: The ViewController which created the actual screen.
     */
    func goForSelectionOfLocality(in viewController: BaseViewController){
        let vm = SelectLocalityViewModel(dependencies: AppDependency.shared)
        let vc = SelectLocalityViewController(selectLocalityViewModel: vm)
        vc.flowDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    /**
     This function ensures the transition to the screen for setting machinely-read information about close animals
     - Parameters:
        - viewController: The ViewController which created the actual screen.
     */
    func goToSettings(in viewController: BaseViewController){
        let vc = SettingInformationViewController()
        vc.flowDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension AppFlowCoordinator: GoToAnimalDetailDelegate{
    /**
     This function ensures the transition to the screen with detailed information about the given animal.
     - Parameters:
        - viewController: The ViewController which created the actual screen.
        - animal: The animal which we want to show information about.
    */
    func goToAnimalDetail(in viewController: BaseViewController, to animal: Animal){
        let vm = AnimalDetailViewModel(animal: animal, dependencies: AppDependency.shared)
        let vc = AnimalDetailViewController(animal: animal, animalDetailViewModel: vm)
        vc.flowDelegate = self
        navigationController?.pushViewController(vc, animated: true)
        
    }
}


extension AppFlowCoordinator: GoBackDelegate{
    /**
     This function ensures going back to the previous screen.
     - Parameters:
        - viewController: The ViewController which created the actual screen.
    */
    func goBackTapped(in viewController: BaseViewController){
        navigationController.popViewController(animated: true)
    }
}
