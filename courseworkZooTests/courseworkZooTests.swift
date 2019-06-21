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
    let localityViewModel: LocalityViewModel = LocalityViewModel(dependencies: TestDependency.shared)

    func testValidViewModelDataReturnsNoError() {
        let expectation = XCTestExpectation(description: "Valid viewModel data returns no error.")
        localityViewModel.getAllLocalitiesAction.completed.observeValues{
            expectation.fulfill()
        }
        localityViewModel.getAllLocalitiesAction.apply().start()
        wait(for: [expectation], timeout: 2) 
    }
    
    func testValidViewModelDataReturnsResult(){
        let expectation = XCTestExpectation(description: "Valid viewModel data returns result")
        localityViewModel.getAllLocalitiesAction.values.producer.startWithValues{
            (value) in
            if(value.count == 28){
                expectation.fulfill()
            }
        }
        localityViewModel.getAllLocalitiesAction.apply().start()
        wait(for: [expectation], timeout: 2)
    }

}
