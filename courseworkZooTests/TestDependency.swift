//
//  TestDependency.swift
//  courseworkZooTests
//
//  Created by Daniel Šup on 20/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

@testable import courseworkZoo
class TestDependency {
    private init() {}
    static let shared = TestDependency()
    
    lazy var animalRepository:AnimalRepositoring =  AnimalRepository()
    lazy var localityRepository:LocalityRepositoring =  LocalityRepository()
    lazy var speechService: SpeechServicing = SpeechService(language: Locale.current.identifier)
}

extension TestDependency: HasAnimalRepository{}
extension TestDependency: HasLocalityRepository{}
extension TestDependency: HasSpeechService{}
