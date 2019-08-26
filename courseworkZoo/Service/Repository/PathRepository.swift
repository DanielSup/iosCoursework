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
    func addAllAnimalsToPath()
    func removeAnimalFromPath(animal: Animal)
    func removeAllAnimalsFromPath()
    func saveActualPath(with title: String)
    func getAllPaths() -> SignalProducer<[Path], Error>
    func selectPath(_ path: Path)
    func getAnimalsInPath() -> [Animal]
    func removePath(_ path: Path)
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
     This function adds all animals to the actual unsaved path.
    */
    func addAllAnimalsToPath() {
        self.animalRepository.loadAndSaveDataIfNeeded()
        self.animalRepository.getAnimalsWithKnownCoordinate().startWithResult { (animalsWithKnownCoordinateResult) in
            self.animalsInActualPath = animalsWithKnownCoordinateResult.value!
        }
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
     This function removes all animals from the actual unsaved path.
    */
    func removeAllAnimalsFromPath() {
        self.animalsInActualPath = []
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
        
        let pathWithAllAnimals = self.getPathWithAllAnimalsWithCoordinate()
        if (pathWithAllAnimals != nil) {
            allPaths.append(pathWithAllAnimals!)
        }
        
        /// adding paths from NSUserDefaults
        while actualPathIndex < numberOfPaths{

            let keyForTitle = PathRepository.path_prefix + String(actualPathIndex) + PathRepository.title_postfix
            let keyForAnimals = PathRepository.path_prefix + String(actualPathIndex) + PathRepository.animals_postfix
            /// getting information about the path with the actual index and saving the path to array
            if let pathTitle = UserDefaults.standard.string(forKey: keyForTitle), let animalIdsInPath = UserDefaults.standard.value(forKey: keyForAnimals) as? [Int]{

                // getting the list of animals from the list of identificators
                var pathAnimals: [Animal] = []
                for animalIdInPath in animalIdsInPath{
                    self.animalRepository.getAnimalById(id: animalIdInPath).startWithResult{ animal in
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
     This function returns the paths with all animals with known coordinate. If animals couldn't be loaded, it returns nil.
     - Returns: The path will all animals with coordinate or nil if animals couldn't be loaded.
    */
    private func getPathWithAllAnimalsWithCoordinate() -> Path? {
        self.animalRepository.loadAndSaveDataIfNeeded()
        if let allAnimals = self.animalRepository.entities.value as? [Animal] {
            var animalsWithCoordinate: [Animal] = []
            for animal in allAnimals {
                if (animal.latitude >= 0) {
                    animalsWithCoordinate.append(animal)
                }
            }
            return Path(title: L10n.pathWithAllAnimals, animals: animalsWithCoordinate)
        } else {
            return nil
        }
    }
    
    /**
     This function ensures selecting the actual path by assigning the list of animals.
     - Parameters:
        - path: The path from the list of saved paths.
    */
    func selectPath(_ path: Path){
        self.animalsInActualPath = path.animals
    }
    
    /**
     This function returns the list of animals in the actual unsaved path.
     - Returns: The list of animals in the actual unsaved path.
    */
    func getAnimalsInPath() -> [Animal] {
        return self.animalsInActualPath
    }
    
    /**
     This function removes the given path by the title and the list of animals.
     - Parameters:
        - path: The path which must be removed.
    */
    func removePath(_ path: Path) {
        print("path removingß")
        var allPaths: [Path] = []
        let numberOfPaths = UserDefaults.standard.integer(forKey: PathRepository.countKey)
        var actualPathIndex: Int = 0
        
        let pathWithAllAnimals = self.getPathWithAllAnimalsWithCoordinate()
        if (pathWithAllAnimals != nil) {
            allPaths.append(pathWithAllAnimals!)
        }
        
        /// adding paths from NSUserDefaults
        while actualPathIndex < numberOfPaths{
            
            let keyForTitle = PathRepository.path_prefix + String(actualPathIndex) + PathRepository.title_postfix
            let keyForAnimals = PathRepository.path_prefix + String(actualPathIndex) + PathRepository.animals_postfix
            /// getting information about the path with the actual index and saving the path to array
            if let pathTitle = UserDefaults.standard.string(forKey: keyForTitle), let animalIdsInPath = UserDefaults.standard.value(forKey: keyForAnimals) as? [Int]{
                
                var isPathSame = path.animals.count == animalIdsInPath.count && path.title == pathTitle
                if (!isPathSame) {
                    actualPathIndex += 1
                    continue
                }
                
                for i in 0..<path.animals.count {
                    if (path.animals[i].id != animalIdsInPath[i]) {
                        isPathSame = false
                        break
                    }
                }
                if (isPathSame) {
                    UserDefaults.standard.removeObject(forKey: keyForTitle)
                    UserDefaults.standard.removeObject(forKey: keyForAnimals)
                    UserDefaults.standard.synchronize()
                }
            }
            actualPathIndex += 1
        }
    }
}
