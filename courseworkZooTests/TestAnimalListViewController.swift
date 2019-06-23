//
//  TestAnimalListViewController.swift
//  courseworkZooTests
//
//  Created by Daniel Šup on 23/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import XCTest

@testable import courseworkZoo
class TestAnimalListViewController: XCTestCase {
    let animalListViewModel: AnimalListViewModel = AnimalListViewModel(dependencies: TestDependency.shared)
    
    func testGetAnimalsNoErrorAndPositiveNumber(){
        let expectation = XCTestExpectation(description: "get animals no error and positive number")
        self.animalListViewModel.getAllAnimalsAction.values.producer.startWithValues{
            (value) in
            if(value.count > 0){
                expectation.fulfill()
            }
        }
        self.animalListViewModel.getAllAnimalsAction.apply().start()
        wait(for: [expectation], timeout: 60)
    }
}
