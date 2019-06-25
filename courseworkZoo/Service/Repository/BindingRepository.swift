//
//  BindingRepository.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 22/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift

class BindingRepository<B: Bindable> : Repository<B> {
    func findBindingsWithAnimal(animal: Int) -> [B]?{
        if let bindings = self.entities.value as? [B]{
            var bindingEntities: [B] = []
            for binding in bindings{
                if(binding.getAnimalId() == animal){
                    bindingEntities.append(binding)
                }
            }
            return bindingEntities
        } else {
            return nil
        }
    }
}
