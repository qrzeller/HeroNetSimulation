
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
func nothing(a: [Any]) -> Any?{
    print("Execute label with value: \(a)")
    return a[0]
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



let a1 = Arc(label: nothing, connectedPlace: p1, direction: .fromPlace      , name: "a1")
let a2 = Arc(label: nothing, connectedPlace: p2, direction: .fromPlace      , name: "a2")
let a3 = Arc(label: nothing, connectedPlace: p3, direction: .fromTransition , name: "a2")

var t1 = Transition(transitionGuard: fGuard, arcsIn: [a1,a2], arcsOut: [a3])

var pn = PetriNet(places: [p1,p2,p3], transitions: [t1], commonName: "Petri", type: .hero)
pn.test()
