//
//  TestSettingsInformation.swift
//  courseworkZooTests
//
//  Created by Daniel Šup on 23/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import XCTest

@testable import courseworkZoo
class TestSettingsInformation: XCTestCase {
    func testSettings(){
        let settings = SettingsInformationViewModel.getActualSettings()
        SettingsInformationViewModel.setActualSettings(SaidInformationSettings.advanced(AdvancedInformationOptions.withoutAttractions))
        
        XCTAssertTrue(SettingsInformationViewModel.getActualSettings() == SaidInformationSettings.advanced(AdvancedInformationOptions.withoutAttractions))
        
        SettingsInformationViewModel.setActualSettings(settings)
        
        XCTAssertTrue(SettingsInformationViewModel.getActualSettings() == settings)
    }
}
