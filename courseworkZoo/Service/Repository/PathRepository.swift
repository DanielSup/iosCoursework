//
//  PathRepository.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 10/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift

/**
 This protocol is used for dependency injection and working with any path repository.
*/
protocol PathRepositoring{
    func addAnimalToPath(animal: Animal)
    func removeAnimalFromPath(animal: Animal)
    func saveActualPath(with title: String)
    func getAllPaths() -> SignalProducer<[Path], Error>
    func selectPath(path: Path)
    func getAnimalsInPath() -> [Animal]
}


/**
 This class is used for working with paths (saving paths, loading saved paths) and animals in the actual path.
*/
class PathRepository: PathRepositoring{
    /// The key used for saving the number of saved paths.
    private static var countKey = "CountPaths"
    /// The prefix used for saving information about paths.
    private static var path_prefix = "Saved_Paths_Path_"
    /// The postfix used for saving titles of paths.
    private static var title_postfix = "_title"
    /// The postfix used for saving lists of animals in paths.
    private static var animals_postfix = "_animals"
    
    /// The array of animals in the actual path.
    private var animalsInActualPath: [Animal] = []
    
    private var animalRepository: AnimalRepositoring
    
    init(animalRepository: AnimalRepositoring){
        self.animalRepository = animalRepository
    }
    
    
    /**
     This function ensures adding the given animal to actual unsaved path.
     - Parameters:
        - animal: The animal which will be added to the actual unsaved path.
    */
    func addAnimalToPath(animal: Animal){
        self.animalsInActualPath.append(animal)
    }
    
    
    /**
     This function ensures removing the given animal from the actual path.
     - Parameters:
        - animal: The animal which will be removed from the actual path.
    */
    func removeAnimalFromPath(animal: Animal){
        var index: Int = 0
        for animalInActualPath in self.animalsInActualPath {
            if (animalInActualPath.id == animal.id){
                self.animalsInActualPath.remove(at: index)
                break
            }
            index += 1
        }
    }
    
    
    /**
     This function ensures saving the actual path to UserDefaults. This function also increases the count of saved paths by one. There are saved all information about the path and number of saved paths.
     - Parameters:
        - title: The title of the path which is saved.
    */
    func saveActualPath(with title: String){
        var animalIdsForSaving: [Int] = []
        for animalInActualPath in animalsInActualPath {
            animalIdsForSaving.append(animalInActualPath.id)
        }
        
        let previousNumber: Int = UserDefaults.standard.integer(forKey: PathRepository.countKey)
        UserDefaults.standard.set(previousNumber + 1, forKey: PathRepository.countKey)
        
        // Saving information about the path which is saved now.
        let keyForSavingTitle = PathRepository.path_prefix + String(previousNumber) + PathRepository.title_postfix
        let keyForSavingAnimals = PathRepository.path_prefix + String(previousNumber) + PathRepository.animals_postfix
        UserDefaults.standard.set(title, forKey: keyForSavingTitle)
        UserDefaults.standard.set(animalIdsForSaving, forKey: keyForSavingAnimals)
        UserDefaults.standard.synchronize()
    }
    
    
    /**
    This function gets an information about the number of saved paths from UserDefaults. Then it gets information about the found number saved paths from UserDefaults.
     - Returns: A signal producer with the list of all saved paths from UserDefaults.
     */
    func getAllPaths() -> SignalProducer<[Path], Error> {
        var allPaths: [Path] = []
        let numberOfPaths = UserDefaults.standard.integer(forKey: PathRepository.countKey)
        var actualPathIndex: Int = 0
        
        while actualPathIndex < numberOfPaths{

            let keyForTitle = PathRepository.path_prefix + String(actualPathIndex) + PathRepository.title_postfix
            let keyForAnimals = PathRepository.path_prefix + String(actualPathIndex) + PathRepository.animals_postfix
            /// getting information about the path with the actual index and saving the path to array
            if let pathTitle = UserDefaults.standard.string(forKey: keyForTitle), let animalIdsInPath = UserDefaults.standard.value(forKey: keyForAnimals) as? [Int]{

                // getting the list of animals from the list of identificators
                var pathAnimals: [Animal] = []
                for animalIdInPath in animalIdsInPath{
                    self.animalRepository.findAnimalById(id: animalIdInPath).startWithResult{ animal in
                        pathAnimals.append(animal.value!!)
                    }
                }
                
                let path = Path(title: pathTitle, animals: pathAnimals)
                allPaths.append(path)
            }
            actualPathIndex += 1
        }
        return SignalProducer(value: allPaths)
    }
    
    
    /**
     This function ensures selecting the actual path by assigning the list of animals.
     - Parameters:
        - path: The path from the list of saved paths.
    */
    func selectPath(path: Path){
        self.animalsInActualPath = path.animals
    }
    
    /**
     This function returns the list of animals in the actual unsaved path.
     - Returns: The list of animals in the actual unsaved path.
    */
    func getAnimalsInPath() -> [Animal] {
        return self.animalsInActualPath
    }
}
