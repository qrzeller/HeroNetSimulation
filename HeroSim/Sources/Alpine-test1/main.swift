
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
// ENUM
print("\nTesting enums")
let e = Structures2.ArithmeticExpressionStandard.self
let one = e.number(1)
let two = e.number(2)
let tree = e.number(3)
let five = e.number(5)
let four = e.number(5)

let sum = e.addition(five, four)
let product = e.multiplication(sum, e.number(2))

let myInt: Int = product.evaluate(product) // why cannot put "e"?, why cannot use self ?
print(myInt)

func plus2(a: Int) -> Int{
    return a + 2
}
func plus4(a: Int) -> Int{
    return a + 4
}
func label_a1(a: [Structures2.ArithmeticExpressionStandard]) -> Structures2.ArithmeticExpressionStandard?{
    print("1. Execute label with value: \(a)")
    return a[0]
}
func label_a2(a: [(Structures2.ArithmeticExpressionStandard) -> Structures2.ArithmeticExpressionStandard]) -> (Structures2.ArithmeticExpressionStandard) -> Structures2.ArithmeticExpressionStandard{ // add ? to out type, and change transition function body
    print("2. Execute label with value: \(a)")
    return a[0]
}
func l_a3(a: [Any]) -> Structures2.ArithmeticExpressionStandard?{
    print("3. Execute label with value: \(a)")
    let f = a[1] as! (Structures2.ArithmeticExpressionStandard) -> Structures2.ArithmeticExpressionStandard
    let param = a[0] as! Structures2.ArithmeticExpressionStandard
    let equation = f(param)
    let valueEvaluated = equation.evaluate(equation)
    return Structures2.ArithmeticExpressionStandard.number(valueEvaluated)
}
func fGuard(a: [Any]) -> Bool {
    return one.evaluate(a[0] as! Structures2.ArithmeticExpressionStandard) == 1
}


/////////////////////////////////////////////////////////////////



let int = Domain(domainCardinality: 1, domainSet: "Int", codomainCardinality: 0, codomainSet: "")
let f   = Domain(domainCardinality: 1, domainSet: "Int", codomainCardinality: 1, codomainSet: "Int")

var p1 = Place(markings: [one,two,tree], domain: int, comment: "P1-Int")
var p2 = Place(markings: [e.add2,e.add4], domain: f, comment: "P2-Func")
var p3 = Place(markings: [four], domain: int, comment: "P3-result")

let a1 = Arc(label: label_a1, connectedPlaceIn: p1, connectedPlaceOut: nil, direction: .fromPlace, name: "a1")
let a2 = Arc(label: label_a2, connectedPlaceIn: p2, connectedPlaceOut: nil, direction: .fromPlace , name: "a2")
let a3 = Arc<Any, Structures2.ArithmeticExpressionStandard>(label: l_a3, connectedPlaceIn: nil, connectedPlaceOut: p3,  direction: .fromTransition , name: "a2")

var t1 = Transition<Structures2.ArithmeticExpressionStandard, Structures2.ArithmeticExpressionStandard>(transitionGuard: fGuard, arcsIn: [a1], arcsOut: [a3], function: a2)

let resultFire = t1.fire()


///////////////////////////////////////////////////////////////////
//// ENUM
//print("\nTesting enums")
//let e = Structures2.ArithmeticExpressionStandard.self
//let one = e.number(1)
//let two = e.number(2)
//let tree = e.number(3)
//let five = e.number(5)
//let four = e.number(5)
//
//let sum = e.addition(five, four)
//let product = e.multiplication(sum, e.number(2))
//
//let myInt: Int = product.evaluate(product) // why cannot put "e"?, why cannot use self ?
//print(myInt)



