//
//  SelectLocalityViewModel.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 21/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift

class SelectLocalityViewModel: BaseViewModel {
    typealias Dependencies = HasLocalityRepository
    
    private let dependencies: Dependencies
    static var selectedLocality: Locality? = nil
    
    
    // MARK - Actions
    
    lazy var getLocalitiesAction = Action<(), [Locality], LoadError>{
        [unowned self] in
        self.dependencies.localityRepository.loadAndSaveDataIfNeeded()
        if let localities = self.dependencies.localityRepository.entities.value as? [Locality] {
            var newLocalities: [Locality] = []
            for locality in localities {
                if(locality.latitude < 0){
                    continue
                }
                newLocalities.append(locality)
            }
            return SignalProducer<[Locality], LoadError>(value: newLocalities)
        } else {
            return SignalProducer<[Locality], LoadError>(error: .noLocalities)
        }
    }

    // MARK - Constructor
    
    init(dependencies: Dependencies){
        self.dependencies = dependencies
        super.init()
    }
}
