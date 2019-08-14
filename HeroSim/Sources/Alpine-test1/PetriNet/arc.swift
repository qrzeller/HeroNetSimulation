//
//  arcs.swift
//  Alpine-test1
//
//  Created by Quentin Zeller on 11.08.19.
//

import Foundation

struct Arc<PlaceType>{
    enum Way{
        case fromPlace
        case fromTransition
    }
    var connectedPlace: Place<PlaceType>
    
    let label: ([PlaceType]) -> PlaceType?
    let name : String
    let direction: Way
    
    init(label: @escaping ([PlaceType]) -> PlaceType?, connectedPlace: Place<PlaceType>, direction: Way, name: String = "") {
        self.label = label
        self.name = name
        self.connectedPlace = connectedPlace
        self.direction = direction
        
    }
     // params for out arcs only
    // return type can be any because (T or closure/function)
    mutating func execute(paramsOut: [PlaceType]? = nil) -> PlaceType?{
        if (direction == .fromPlace){
            if let param = self.connectedPlace.getAValue() {
                return label([param])// only 1 parameter
            } else { return nil }
        } else {
            // let inCard = connectedPlace.getDomain().getDomainCardinality()
            let newMark = label(paramsOut!)
            connectedPlace.add(token: newMark as! PlaceType)
            return newMark
        }
    }
}
