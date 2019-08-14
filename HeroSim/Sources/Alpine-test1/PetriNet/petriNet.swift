//
//  petriNet.swift
//  Alpine-test1
//
//  Created by Quentin Zeller on 08.08.19.
//

import Foundation



struct PetriNet{
    enum netType{
        case hero
    }
    
    let type : netType
    let commonName: String
    let places: [Place<Any>]
    var transitions: [Transition<Any, Any>]
    
    init(places: [Place<Any>],transitions: [Transition<Any, Any>], commonName: String = "" ,type: netType = .hero) {
        self.type = type
        self.commonName = commonName
        
        // Init places and transition object.
        // TODO
        self.places = places
        self.transitions = transitions
    }
    
    mutating func test(){
        var ok = transitions[0].fire()
    }
    
}
