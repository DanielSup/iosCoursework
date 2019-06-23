//
//  TestEnums.swift
//  courseworkZooTests
//
//  Created by Daniel Šup on 23/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import XCTest

@testable import courseworkZoo
class TestEnums: XCTestCase {
    func testBiotopesEnum(){
        XCTAssertTrue(Biotope.getBiotopeWithId(id: 1) == Biotope.sea)
        XCTAssertTrue(Biotope.getBiotopeWithId(id: 5) == Biotope.mountains)
        XCTAssertTrue(Biotope.getBiotopeWithId(id: 10) == Biotope.polarRegions)
    }
    
    func testSettingsEnum(){
        XCTAssertTrue(SaidInformationSettings.elementary(ElementaryInformationOptions.onlyTitleAndNews) =+-= SaidInformationSettings.elementary(ElementaryInformationOptions.titleNewsAndDescription))
            XCTAssertTrue(SaidInformationSettings.allCases.count == 8)
    }
    
    func testFoodEnum(){
        XCTAssertTrue(Food.getFoodWithId(id: 1) == Food.partsOfPlants)
        XCTAssertTrue(Food.getFoodWithId(id: 2) == Food.livePrey)
        XCTAssertTrue(Food.getFoodWithId(id: 6) == Food.invertebrates)
        XCTAssertTrue(Food.getFoodWithId(id: 9) == Food.fruits)
    }
    
    func testContinensEnum(){
        XCTAssertTrue(Continent.continentWithId(id: 1) == Continent.africa)
        XCTAssertTrue(Continent.continentWithId(id: 5) == Continent.australia)
        XCTAssertTrue(Continent.continentWithId(id: 7) == Continent.europe)
        XCTAssertTrue(Continent.continentWithId(id: -1) == Continent.none)
        XCTAssertTrue(Continent.none == Continent.notInNature)
        
    }
}
