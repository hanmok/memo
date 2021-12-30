//
//  ModelTest.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/22.
//

import Foundation

class Customer {
    let name: String
    var card: CreditCard?
    init(name: String) {
        self.name = name
    }
    deinit{ print("\(name) is being deinitialized")}
}

class CreditCard {
    let number: Int
    unowned let customer: Customer
    
    init(number: Int, customer: Customer) {
        self.number = number
        self.customer = customer
    }
    deinit{print("Card \(number) is being deinitialized")}
}


class Country {
    let name: String
    var capitalCity: City!
    init(name: String, capitalName: String) {
        self.name = name
        self.capitalCity = City(name: capitalName, country: self)
    }
}

class City {
    let name: String
    unowned let country: Country
    init(name: String, country: Country) {
        self.name = name
        self.country = country
    }
}
