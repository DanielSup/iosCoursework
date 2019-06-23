//
//  TestAnimalDetailViewController.swift
//  courseworkZooTests
//
//  Created by Daniel Šup on 23/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import XCTest

@testable import courseworkZoo

class TestAnimalDetailViewController: XCTestCase {
    let viewModel: ViewModel = ViewModel(dependencies: TestDependency.shared)
    
    func testFindBiotopesNoError(){
        let expectation = XCTestExpectation(description: "find biotopes no error")
        var animal: Animal? = nil
        viewModel.getAnimalsAction.values.producer.startWithValues{
            (value) in
            if(value.count == 0){
                expectation.fulfill()
            } else {
                animal = value[0]
            }
        }
        viewModel.getAnimalsAction.apply().start()
        if(animal != nil){
            let detailViewModel = AnimalDetailViewModel(animal: animal!, dependencies: TestDependency.shared)
        detailViewModel.getBiotopesOfAnimal.values.producer.startWithValues{
                (value) in
                expectation.fulfill()
            }
            detailViewModel.getBiotopesOfAnimal.apply().start()
        }
        wait(for: [expectation], timeout: 60)
    }
    
    func testFindFoodNoError(){
        let expectation = XCTestExpectation(description: "find food no error")
        var animal: Animal? = nil
        viewModel.getAnimalsAction.values.producer.startWithValues{
            (value) in
            if(value.count == 0){
                expectation.fulfill()
            } else {
                animal = value[0]
            }
        }
        viewModel.getAnimalsAction.apply().start()
        if(animal != nil){
            let detailViewModel = AnimalDetailViewModel(animal: animal!, dependencies: TestDependency.shared)
        detailViewModel.getFoodsOfAnimal.values.producer.startWithValues{
                (value) in
                expectation.fulfill()
            }
            detailViewModel.getFoodsOfAnimal.apply().start()
        }
        wait(for: [expectation], timeout: 60)
        
    }
    
    func testFindContinentsNoError(){
        let expectation = XCTestExpectation(description: "find continents no error")
        var animal: Animal? = nil
        viewModel.getAnimalsAction.values.producer.startWithValues{
            (value) in
            if(value.count == 0){
                expectation.fulfill()
            } else {
                animal = value[0]
            }
        }
        viewModel.getAnimalsAction.apply().start()
        if(animal != nil){
            let detailViewModel = AnimalDetailViewModel(animal: animal!, dependencies: TestDependency.shared)
            detailViewModel.getContinentsOfAnimal.values.producer.startWithValues{
                (value) in
                expectation.fulfill()
            }
            detailViewModel.getContinentsOfAnimal.apply().start()
        }
        wait(for: [expectation], timeout: 60)
        
    }
}
