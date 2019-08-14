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
    let places: Places
    let transitions: Transitions
    
    init(places: [Place<Any>],transitions: [Transition], commonName: String = "" ,type: netType = .hero) {
        self.type = type
        self.commonName = commonName
        
        // Init places and transition object.
        // TODO
        self.places = Places(places: places)
        self.transitions = Transitions(transitions: transitions)
    }
    
    func test(){
        let ok = transitions[0]?.fire()
    }
    
}
