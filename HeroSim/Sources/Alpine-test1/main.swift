
//
//  File.swift
//  Alpine-test1
//
//  Created by Quentin Zeller on 06.08.19.
//

import Foundation
import Interpreter


print("Test Structure.test")
let s = Structures()
let s2 = Structures2()
//s.test1()
print("Test 2")
s.test2()
print("Test 3")
s2.test3()

print("__________________ HeroN ____________________")


func plus2(a: Int) -> Int{
    return a + 2
}
func plus4(a: Int) -> Int{
    return a + 4
}
func nothing(a: [Int]) -> Int?{
    print("1. Execute label with value: \(a)")
    return a[0]
}
func nothing2(a: [(Int) -> Int]) -> ((Int) -> Int)?{
    print("2. Execute label with value: \(a)")
    return a[0]
}
func nothing3(a: [Any]) -> Int?{
    print("3. Execute label with value: \(a)")
    let f = a[1] as! (Int) -> Int
    let param = a[0] as! Int
    return f(param)
}
func fGuard(in: [Any]) -> Bool {
    return true
}


let int = Domain(domainCardinality: 1, domainSet: "Int", codomainCardinality: 0, codomainSet: "")
let f   = Domain(domainCardinality: 1, domainSet: "Int", codomainCardinality: 1, codomainSet: "Int")

var p1 = Place<Int>(markings: [1,2,3], domain: int, comment: "P1-Int")
var p2 = Place<(Int) -> Int>(markings: [plus2,plus4], domain: f, comment: "P2-Func")
var p3 = Place<Int>(markings: [0], domain: int, comment: "P3-result")

//var p1 = Place<Any>(markings: [1,2,3], domain: int, comment: "P1-Int")
//var p2 = Place<Any>(markings: [plus2,plus4], domain: f, comment: "P2-Func")
//var p3 = Place<Any>(markings: [0], domain: int, comment: "P3-result")



let a1 = Arc<Int, Int>(label: nothing, connectedPlaceIn: p1, connectedPlaceOut: nil, direction: .fromPlace      , name: "a1")
let a2 = Arc<(Int) -> Int, (Int) -> Int>(label: nothing2, connectedPlaceIn: p2, connectedPlaceOut: nil, direction: .fromPlace      , name: "a2")

// entry arcs are not function ?
let a3 = Arc<Any, Int>(label: nothing3, connectedPlaceIn: nil, connectedPlaceOut: p3,  direction: .fromTransition , name: "a2")

var t1 = Transition<Int, Int>(transitionGuard: fGuard, arcsIn: [a1], arcsOut: [a3], function: a2)

//var pn = PetriNet(places: [p1,p2,p3] as! [Place<Any>], transitions: [t1 as! Transition<Any,Any>] , commonName: "Petri", type: .hero)
//pn.test()
let resultFire = t1.fire()




// Comment

// les types ne sont pas possible car ce sont les labels qui décident des interraction
// les arcs d'entrées sont de types différents -> pas possible de les stores dans un tableau.
