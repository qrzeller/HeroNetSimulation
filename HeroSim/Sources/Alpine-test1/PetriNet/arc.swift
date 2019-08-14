//
//  arcs.swift
//  Alpine-test1
//
//  Created by Quentin Zeller on 11.08.19.
//

import Foundation

struct Arc<PlaceIn, PlaceOut>{
    enum Way{
        case fromPlace
        case fromTransition
    }
    var connectedPlaceIn: Place<PlaceIn>? = nil
    var connectedPlaceOut: Place<PlaceOut>? = nil
    
    let label: ([PlaceIn]) -> PlaceOut?
    let name : String
    let direction: Way
    
    init(label: @escaping ([PlaceIn]) -> PlaceOut?, connectedPlaceIn:  Place<PlaceIn>?,
                                                    connectedPlaceOut: Place<PlaceOut>?, direction: Way, name: String = "") {
        self.label = label
        self.name = name
        self.connectedPlaceIn = connectedPlaceIn
        self.connectedPlaceOut = connectedPlaceOut
        self.direction = direction
        
        assert(!(direction == .fromPlace) || (PlaceIn.self == PlaceOut.self), "We assumed for arc, In type == Out type") // p -> q

        
    }
     // params for out arcs only    
    // return type can be any because (T or closure/function)
    mutating func execute(transitionParams: [PlaceIn]? = nil) -> PlaceOut?{
        if (direction == .fromPlace){
            if let param = self.connectedPlaceIn!.getAValue() {
                return label([param]) // Assume we did not change the type and (only one param)
            } else { return nil }
        } else {
            // let inCard = connectedPlace.getDomain().getDomainCardinality()
            let newMark = label(transitionParams!)
            connectedPlaceOut!.add(token: newMark!)
            return newMark
        }
    }
}
