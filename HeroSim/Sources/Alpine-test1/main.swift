
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

let root = "/Users/quentinzeller/Github/OFA/HeroNetSimulation/HeroSim/Sources/Alpine-test1/"
var module: String = read(fileName: root + "curry.alpine")
var interpreter = Interpreter()
try! interpreter.loadModule(fromString: module)

print("__________________ HeroN ____________________")


func l_a3(t: [String: String]) -> String?{
    let code: String = "operationNoCurry(a: \(t["a"]!), b: \(t["b"]!) , op: \(t["c"]!))"
    let value = try! interpreter.eval(string: code)
    return value.description
}

func fGuard(a: [String: String]) -> Bool {
    print("Guarded : \(a).")
    return true
}

/////////////////////////////////////////////////////////////////

let int = Domain(domainCardinality: 1, domainSet: "Int", codomainCardinality: 0, codomainSet: "")
let f   = Domain(domainCardinality: 1, domainSet: "Int", codomainCardinality: 1, codomainSet: "Int")

var p1 = Place(tokens: ["1", "2", "3"], domain: int, comment: "P1-Int, a b")
var p2 = Place(tokens: ["add","sub"], domain: f, comment: "P2-Func, c")
var p3 = Place(tokens: ["10"], domain: int, comment: "P3-result")

let a1 = ArcIn(label: "a, b", connectedPlace: p1, name: "a1"); print(a1)
let a2 = ArcIn(label: "c", connectedPlace: p2, name: "a2")
let a3 = ArcOut(label: l_a3, connectedPlace: p3, name: "a2"); print(a3)

var t1 = Transition(transitionGuard: fGuard, arcsIn: [a1,a2], arcsOut: [a3])

let resultFire = t1.fire(manualToken: [
    "a":"2",
    "b":"3",
    "x":"sub"
    ])
print("________________________________________________________")
let resultFire2 = t1.fire()
print(p1)
print("________________________________________________________")


print("-- Marking mode : ")

