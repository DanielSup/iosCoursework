//
//  courseworkZooTests.swift
//  courseworkZooTests
//
//  Created by Daniel Šup on 20/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import XCTest
@testable import courseworkZoo

class courseworkZooTests: XCTestCase {
    let viewModel: ViewModel = ViewModel(dependencies: TestDependency.shared)

    func testValidViewModelDataReturnsNoErrorForGettingLocalities() {
        let expectation = XCTestExpectation(description: "Valid viewModel data returns no error.")
        viewModel.getLocalitiesAction.completed.observeValues{
            expectation.fulfill()
        }
        viewModel.getLocalitiesAction.apply().start()
        wait(for: [expectation], timeout: 2) 
    }
    
    func testValidViewModelDataReturnsCorrectResultForGettingLocalities(){
        let expectation = XCTestExpectation(description: "Valid viewModel data returns result")
        viewModel.getLocalitiesAction.values.producer.startWithValues{
            (value) in
            if(value.count == 2){
                expectation.fulfill()
            }
        }
        viewModel.getLocalitiesAction.apply().start()
        wait(for: [expectation], timeout: 2)
    }
    
    func testGetAnimalsNoError(){
        let expectation = XCTestExpectation(description: "get animals no error")
        viewModel.getAnimalsAction.values.producer.startWithValues{
            (value) in
            expectation.fulfill()
        }
        viewModel.getAnimalsAction.apply().start()
        wait(for: [expectation], timeout: 60)
    }
    
    func testGetAnimalsCorrectNumber(){
        let expectation = XCTestExpectation(description: "get animals correct number")
        viewModel.getAnimalsAction.values.producer.startWithValues{
            (value) in
            if(value.count == 7){
                expectation.fulfill()
            }
        }
        viewModel.getAnimalsAction.apply().start()
        wait(for: [expectation], timeout: 60)
    }
    
    func testNoCloseAnimal(){
         let expectation = XCTestExpectation(description: "no close animal")
        viewModel.updateLocation(latitude: 5, longitude: 5)
        viewModel.animalInClosenessAction.values.producer.startWithValues{
            (value) in
            if(value == nil){
                expectation.fulfill()
            }
        }
        viewModel.animalInClosenessAction.apply().start()
        wait(for: [expectation], timeout: 60)
    }
    
    func testNoCloseLocality(){
        let expectation = XCTestExpectation(description: "no close locality")
        viewModel.updateLocation(latitude: 5, longitude: 5)
        viewModel.localityInClosenessAction.values.producer.startWithValues {
            (value) in
            if(value == nil){
                expectation.fulfill()
            }
        }
        viewModel.localityInClosenessAction.apply().start()
        wait(for: [expectation], timeout: 2)
    }
    
    func testCorrectCloseAnimal(){
        let expectation = XCTestExpectation(description: "correct close animal")
        var animal: Animal? = nil
        viewModel.getAnimalsAction.values.producer.startWithValues{
            (value) in
            if(value.count >= 1){
                animal = value[0]
            }
        }
        viewModel.getAnimalsAction.apply().start()
        if(animal != nil){
            let latitude = animal?.latitude ?? -1 + (BaseViewModel.closeDistance / 2.0)
            let longitude = animal?.longitude ?? -1 + (BaseViewModel.closeDistance / 2.0)
            viewModel.updateLocation(latitude: latitude, longitude: longitude)
            viewModel.animalInClosenessAction.values.producer.startWithValues{
                (value) in
                if(value != nil){
                    if(value?.id == animal!.id){
                        expectation.fulfill()
                    }
                    
                }
            }
            viewModel.animalInClosenessAction.apply().start()
        }
        wait(for: [expectation], timeout: 60)
    }
    
    func testCorrectCloseLocality(){
        let expectation = XCTestExpectation(description: "correct close locality")
        var locality: Locality? = nil
        viewModel.getLocalitiesAction.values.producer.startWithValues{
            (value) in
            if(value.count >= 1){
                locality = value[0]
            }
        }
        viewModel.getLocalitiesAction.apply().start()
        if(locality != nil){
            let latitude = locality?.latitude ?? -1 + (BaseViewModel.closeDistance / 2.0)
            let longitude = locality?.longitude ?? -1 + (BaseViewModel.closeDistance / 2.0)
            viewModel.updateLocation(latitude: latitude, longitude: longitude)
        viewModel.localityInClosenessAction.values.producer.startWithValues{
                (value) in
                if(value != nil){
                    if(value?.id == locality!.id){
                        expectation.fulfill()
                    }
                }
            }
            viewModel.localityInClosenessAction.apply().start()
        }
        wait(for: [expectation], timeout: 2)
        
    }
    
}
