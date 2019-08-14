//
//  places.swift
//  Alpine-test1
//
//  Created by Quentin Zeller on 08.08.19.
//

import Foundation

struct Places {
    //typealias Places = [Place<Any>]
    
    let places: [Place<Any>] // How to conform to Equatable?...
    
    init(places: [Place<Any>]) {
        self.places = places
    }
    
    subscript(index: Int) -> Place<Any>? {
        get{
            assert (places.count > index && index >= 0, "Place index does not exist : \(index)")
            return (places.count > index && index >= 0) ? places[index] : nil
        }

    }
}
