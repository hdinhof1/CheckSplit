//
//  Person.swift
//  CheckSplit
//
//  Created by Henry Dinhofer on 12/22/16.
//  Copyright © 2016 Henry Dinhofer. All rights reserved.
//

import Foundation

class Person {
    
    var name : String
    var drinks : [Drink]
    var appetizers : [Appetizer]
    var entrees : [Food]
    var total : Double
    var personUUID : Int
    
    
    var description : String {
        
        var description = "\(self.name)\nDrink:"
        for drink in self.drinks {
            description += "\t\(drink.description)"
        }
        
        description += "\nFood:\n"
        for food in entrees {
            description += "\t\(food.name) - \(food.cost)"
        }
        
        description += "Total: \(self.totalTally)\n"
        return description
    }
    
    var totalTally : Double {
        var total : Double = 0.0
        for drink in drinks {
            total += drink.cost
        }
        
        for appetizer in appetizers {
            total += appetizer.cost
        }
        
        for entree in entrees {
            total += entree.cost
        }
        return total
    }
    var subtotal : Double {
        return self.totalTally
    }
    var taxtotal : Double {
        let taxRate = UserDefaults().getTaxRate()
        return self.subtotal * taxRate
    }
    var grandtotal : Double {
        return self.subtotal + self.taxtotal
    }
    
    var tiptotal : Double {
        let grandTotal = self.grandtotal
        let tipRate = UserDefaults().getTipRate()
        return grandTotal * tipRate
    }

    
    init(name: String, drinks : [Drink], appetizers: [Appetizer], entrees : [Food]) {
        self.name = name
        self.drinks = drinks
        self.appetizers = appetizers
        self.entrees = entrees
        self.total = 0.0
        self.personUUID = MealDataStore.sharedInstance.peopleUUID
    }
    
    convenience init(name: String) {
        self.init(name: name, drinks: [Drink](), appetizers: [Appetizer](), entrees: [Food]())
    }
    
    //generic method (addItem : [Any])
    func addDrink(drink : Drink) {
        self.drinks.append(drink)
        total += drink.cost
    }
    
    func removeDrink(drink : Drink) {
        guard let index = self.drinks.index(where: { $0 == drink } )
            else { return }
        
        total -= self.drinks[index].cost
        self.drinks.remove(at: index)
    }
    
    func split(drink : Drink, withPerson person : Person) {
        drink.splitWith.append(person)
        person.addDrink(drink: drink)
    }
    
    
    
}
func ==(lhs: Person, rhs: Person) -> Bool {
    return lhs.name == rhs.name //&& lhs.personUUID == rhs.personUUID
}
