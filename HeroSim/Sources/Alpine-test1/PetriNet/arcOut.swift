//
//  arcs.swift
//  Alpine-test1
//
//  Created by Quentin Zeller on 11.08.19.
//

import Foundation

struct ArcOut<PlaceIn, PlaceOut>{

    var connectedPlace: Place<PlaceOut>
    
    let label: ([String: PlaceIn]) -> PlaceOut?
    let name : String
    
    init(label: @escaping ([String: PlaceIn]) -> PlaceOut?, connectedPlace:  Place<PlaceOut>, name: String = "") {
        self.label = label
        self.name = name
        self.connectedPlace = connectedPlace

    }
     // params for out arcs only    
    // return type can be any because (T or closure/function)
    mutating func execute(transitionParams: [String: PlaceIn]) -> PlaceOut?{
        
        // let inCard = connectedPlace.getDomain().getDomainCardinality()
        let newMark = label(transitionParams)
        connectedPlace.add(token: newMark!)
        return newMark
        
    }
}
