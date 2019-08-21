//
//  arcIn.swift
//  Alpine-test1
//
//  Created by Quentin Zeller on 11.08.19.
//

import Foundation

struct ArcIn<PlaceIn, PlaceOut>{
    var connectedPlace: Place<PlaceIn>
    
    let label: ([PlaceIn]) -> PlaceOut?
    let name : String
    
    init(label: @escaping ([PlaceIn]) -> PlaceOut?, connectedPlace: Place<PlaceIn>, name: String = "") {
        self.label = label
        self.name = name
        self.connectedPlace = connectedPlace
        
    }
    // params for out arcs only
    // return type can be any because (T or closure/function)
    mutating func execute() -> PlaceOut?{
        if let param = self.connectedPlace.getAValue() {
            return label([param]) // Assume we did not change the type and (only one param)
        } else { return nil }
        
    }
}
