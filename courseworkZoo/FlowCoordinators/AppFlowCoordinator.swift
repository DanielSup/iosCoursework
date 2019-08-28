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


extension AppFlowCoordinator: MainDelegate, GoToLexiconDelegate{
    
    /**
     This function ensures the transition to the main screen of the lexicon part of the application.
     - Parameters:
     - viewController: The ViewController which created the actual screen.
    */
    func goToLexicon(in viewController: BaseViewController) {
        let vm = MainLexiconViewModel(dependencies: AppDependency.shared)
        let vc = MainLexiconViewController(mainLexiconViewModel: vm)
        vc.flowDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /**
     This function ensures going to the screen for selecting animals to the actual path.
     - Parameters:
        - viewController: The ViewController which created the actual screen.
    */
    func goToSelectAnimalsToPath(in viewController: BaseViewController) {
        let vm = SelectAnimalsToPathViewModel(dependencies: AppDependency.shared)
        let vc = SelectAnimalsToPathViewController(selectAnimalsToPathViewModel: vm)
        vc.flowDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /**
    This function ensures going to the screen for choosing one of the saved paths.
     - Parameters:
        - viewController: The ViewController which created the actual screen.
     */
    func goToChooseSavedPath(in viewController: BaseViewController) {
        let vm = ChooseSavedPathViewModel(dependencies: AppDependency.shared)
        let vc = ChooseSavedPathViewController(chooseSavedPathViewModel: vm)
        vc.flowDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /**
     This function ensures going to the screen for setting the parameters of the visit of the ZOO.
     - Parameters:
        - viewController: The ViewController which created the actual screen.
     */
    func goToSettingParametersOfVisit(in viewController: BaseViewController) {
        let vm = SettingParametersOfVisitViewModel(dependencies: AppDependency.shared)
        let vc = SettingParametersOfVisitViewController(settingParametersOfVisitViewModel: vm)
        vc.flowDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /**
     This function ensures going to the screen for setting pieces of information about a close animal which are machine-read.
     - Parameters:
        - viewController: The ViewController which created the actual screen.
     */
    func goToSelectInformation(in viewController: BaseViewController){
        let vm = SelectInformationViewModel(dependencies: AppDependency.shared)
        let vc = SelectInformationViewController(selectInformationViewModel: vm)
        vc.flowDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    /**
     This function ensures going to the help screen.
     - Parameters:
        - viewController: The ViewController which created the actual screen.
    */
    func goToHelp(in viewController: BaseViewController) {
        let vc = HelpViewController()
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
    func goBack(in viewController: BaseViewController){
        navigationController.popViewController(animated: true)
    }
}


extension AppFlowCoordinator: LexiconDelegate{
    /**
     This function ensures going back to the main screen of the guide part of the application which is also the main screen of the whole application.
     - Parameters:
        - viewController: The ViewController which created the actual screen.
    */
    func goToGuide(in viewController: BaseViewController) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    /**
     This function ensures going to the screen with the list of classes in which animals can belong.
     - Parameters:
        - viewController: The ViewController which created the actual screen.
     */
    func goToClasses(in viewController: BaseViewController) {
        let vm = ClassViewModel(dependencies: AppDependency.shared)
        let vc = ClassViewController(classViewModel: vm)
        vc.flowDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /**
     This function ensures goint to the screen with the list of biotopes in which animsls can live.
     - Parameters:
        - viewController: The ViewController which created the actual screen.
    */
    func goToBiotopes(in viewController: BaseViewController) {
        let vm = BiotopesViewModel()
        let vc = BiotopesViewController(biotopesViewModel: vm)
        vc.flowDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToPavilions(in viewController: BaseViewController) {
        let vm = PavilionsViewModel(dependencies: AppDependency.shared)
        let vc = PavilionsViewController(pavilionsViewModel: vm)
        vc.flowDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }

    /**
     This function ensures going to the screen with the list of orders of the given class.
     - Parameters:
        - viewController: The ViewController which created the actual screen.
        - parentClass: The parent class of the found orders.
    */
    func goToOrders(in viewController: BaseViewController, of parentClass: Class){
        let vm = OrdersInClassViewModel(dependencies: AppDependency.shared, parentClass: parentClass)
        let vc = OrdersInClassViewController(ordersInClassViewModel: vm)
        vc.flowDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }

    /**
     This function ensures going to the screen with the list of animals in the given order.
     - Parameters:
        - viewController: The ViewController which created the actual screen.
        - order: The given order in which the found animals are.
    */
    func goToAnimalsInOrder(in viewcontroller: BaseViewController, order: Class){
        let vm = AnimalsInOrderViewModel(dependencies: AppDependency.shared, order: order)
        let vc = AnimalsInOrderViewController(animalsInOrderViewModel: vm)
        vc.flowDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }

    /**
     This function ensures going to the screen with the list of animals living in the given biotope.
     - Parameters:
        - viewController: The ViewController which created the actual screen.
        - biotope: The given biotope in which animals can live.
     */
    func goToAnimalsInBiotope(in viewController: BaseViewController, biotope: Biotope) {
        let vm = AnimalsInBiotopeViewModel(dependencies: AppDependency.shared, biotope: biotope)
        let vc = AnimalsInBiotopeViewController(animalsInBiotopeViewModel: vm)
        vc.flowDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /**
     This function ensures going to the scree with the list of animals in the choosed pavilion.
     - Parameters:
        - viewController: The ViewController which created the actual screen.
        - pavilion: The choosed locality (pavilion).
    */
    func goToAnimalsInPavilion(in viewController: BaseViewController, pavilion: Locality){
        let vm = AnimalsInPavilionViewModel(dependencies: AppDependency.shared, locality: pavilion)
        let vc = AnimalsInPavilionViewController(animalsInPavilionViewModel: vm)
        vc.flowDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    /**
     This function ensures going to the screen with the list of continents where animals could live including the option that there could be animals which don't live anywhere in nature.
     - Parameters:
        - viewController: The ViewController which created the actual screen.
    */
    func goToContinents(in viewController: BaseViewController) {
        let vm = ContinentsViewModel()
        let vc = ContinentsViewController(continentsViewModel: vm)
        vc.flowDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    /**
     This function ensures going to the screen with the list of animals living in the given continent or animals which don't live anywhere in nature.
     - Parameters:
        - viewController: The ViewController which created the actual screen.
        - continent: The choosed continent or option for getting the list of animals which don't live anywhere in nature.
    */
    func goToAnimalsInContinent(in: BaseViewController, continent: Continent) {
        let vm = AnimalsInContinentViewModel(dependencies: AppDependency.shared, continent: continent)
        let vc = AnimalsInContinentViewController(animalsInContinentViewModel: vm)
        vc.flowDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    /**
     This function ensures going to the screen with the list of kinds of food which animals can eat.
     - Parameters:
        - viewController: The ViewController which created the actual screen.
    */
    func goToKindsOfFood(in viewController: BaseViewController) {
        let vm = KindsOfFoodViewModel()
        let vc = KindsOfFoodViewController(kindsOfFoodViewModel: vm)
        vc.flowDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    /**
     This function ensures going to the screen with the list of animals eating the given kind of food.
     - Parameters:
     - viewController: The ViewController which created the actual screen.
     - continent: The choosed kind of food which animals can eat..
     */
    func goToAnimalsEatingKindOfFood(in viewController: BaseViewController, kindOfFood: Food) {
        let vm = AnimalsEatingKindOfFoodViewModel(dependencies: AppDependency.shared, kindOfFood: kindOfFood)
        let vc = AnimalsEatingKindOfFoodViewController(animalsEatingKindOfFoodViewModel: vm)
        vc.flowDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}
