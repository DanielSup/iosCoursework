//
//  HasRouteWithAnimalsService.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 27/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
This protocol is used for the dependency injection. It ensures getting the repository for finding the shortest path with all animals in the path for showing in the map.
 */
protocol HasRouteWithAnimalsService {
    var routeWithAnimalsService: RouteWithAnimalsServicing { get }
}
