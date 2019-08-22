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
    let places: [Place<String>]
    var transitions: [Transition<String, String>]
    
    init(places: [Place<String>],transitions: [Transition<String, String>], commonName: String = "" ,type: netType = .hero) {
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
