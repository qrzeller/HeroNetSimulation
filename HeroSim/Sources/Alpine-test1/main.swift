
//
//  File.swift
//  Alpine-test1
//
//  Created by Quentin Zeller on 06.08.19.
//

import Foundation
import Interpreter

func read(fileName: String) -> String{
    do {
        let contents = try NSString(contentsOfFile: fileName, encoding: 4)
        return contents as String
    } catch {
        // contents could not be loaded
        print("Error info: \(error)")
        return "not loaded"
    }
}

let root = "/Users/quentinzeller/Github/OFA/Alpine-tests/Alpine-test1/Sources/Alpine-test1/"
var module: String = read(fileName: root + "curry.alpine")
var interpreter = Interpreter()
try! interpreter.loadModule(fromString: module)

print("__________________ HeroN ____________________")
func label_a1(a: [String]) -> String{
    print("1. Execute label with value: \(a)")
    return a[0]
}
func label_a2(a: [String]) -> String{
    print("2. Execute label with value: \(a)")
    return a[0]
}
func l_a3(a: [Any]) -> String?{
    print("3. Execute label with value: \(a)")
    let t = a as! [String]
    let code: String = "operationNoCurry(\(t[0]), 2 , op: \(t[1]))"
    let value = try! interpreter.eval(string: code)
    print(value)
    return value.description
}
func fGuard(a: [Any]) -> Bool {
    return true
}


/////////////////////////////////////////////////////////////////



let int = Domain(domainCardinality: 1, domainSet: "Int", codomainCardinality: 0, codomainSet: "")
let f   = Domain(domainCardinality: 1, domainSet: "Int", codomainCardinality: 1, codomainSet: "Int")

var p1 = Place(markings: ["1","2","3"], domain: int, comment: "P1-Int")
var p2 = Place(markings: ["add","sub"], domain: f, comment: "P2-Func")
var p3 = Place(markings: ["10"], domain: int, comment: "P3-result")

let a1 = Arc(label: label_a1, connectedPlaceIn: p1, connectedPlaceOut: nil, direction: .fromPlace, name: "a1")
let a2 = Arc(label: label_a2, connectedPlaceIn: p2, connectedPlaceOut: nil, direction: .fromPlace , name: "a2")
let a3 = Arc(label: l_a3, connectedPlaceIn: nil, connectedPlaceOut: p3,  direction: .fromTransition , name: "a2")

var t1 = Transition<String,String>(transitionGuard: fGuard, arcsIn: [a1,a2], arcsOut: [a3], function: nil)

let resultFire = t1.fire()
let resultFire2 = t1.fire()

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



