//
//  LocalityRepository.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 04/05/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift

class LocalityRepository: NSObject {
    
    lazy var localities = MutableProperty<[Locality]?>([])
    
    func getLocalities() -> [Locality]? {
        print("Getting localities")
        let result: String = APIService.getResultsOfAPICall(url: Constants.server+Constants.localities)
        if(result == "error" || result == "content could not be loaded"){
            return nil
        }
        var localities :[Locality] = []
        let localitiesInJson = result.parseJSONString
        let decoder = JSONDecoder()
        for localityInJson in localitiesInJson{
            let localityObject = try? decoder.decode(Locality.self, from: localityInJson) 
            if let locality = localityObject as? Locality {
                localities.append(locality)
            } else {
                return nil
            }
        }
        return localities
    }
    
    func reload(){
        localities.value = self.getLocalities()
    }
    
    func findLocalityInCloseness(latitude: Double, longitude: Double) -> SignalProducer<Locality?, LoadError>{
        if let localities = self.localities.value as? [Locality]{
            for locality in localities{
                if(abs(locality.latitude - latitude) < BaseViewModel.closeDistance && abs(locality.longitude - longitude) < BaseViewModel.closeDistance){
                    return SignalProducer(value: locality)
                }
            }
            return SignalProducer(value: nil)
            
        } else {
            return SignalProducer(error: .noLocalities)
        }
    }
    
}
