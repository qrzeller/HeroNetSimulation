
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


//let int = Domain(domainCardinality: 1, domainSet: "Int", codomainCardinality: 0, codomainSet: "")
//let f   = Domain(domainCardinality: 1, domainSet: "Int", codomainCardinality: 1, codomainSet: "Int")
//
//var p1 = Place(tokens: ["1", "2", "3"], domain: int, name: "p1")
//var p2 = Place(tokens: ["add","sub"], domain: f, name: "p2")
//var p3 = Place(tokens: ["10"], domain: int, name: "p3")
//let places = [p1,p2,p3]
//
//let a1 = ArcIn(label: "a, b", connectedPlace: p1, name: "a1"); print(a1)
//let a2 = ArcIn(label: "c", connectedPlace: p2, name: "a2")
//let a3 = ArcOut(label: PetriNet.opNoCurry, connectedPlace: p3, name: "a2"); print(a3)
//
//var t1 = Transition(transitionGuard: PetriNet.noGuardPrint, arcsIn: [a1,a2], arcsOut: [a3], name: "t1")
//let transitions = [t1]

// run from main
//let resultFire = t1.fire(manualToken: [
//    "a":"2",
//    "b":"3",
//    "c":"sub"
//    ])
//print("________________________________________________________")
//let resultFire2 = t1.fire()
//print(p1)


//let p = PetriNet(places: places, transitions: transitions, commonName: "calculatrice", type: PetriNet.netType.hero)
let p = PetriNet()
p.definitionTest()
p.startDefinitionTest()
p.randomRun(count: 1)



// Questions :
//      - Allow multiple ouput ? (and in alpine ?)
//      - In x, y ;  out x, x
//      - Out x+y ; x-y sur même place?

// TODO:
//      - label in alpine.
//      - definition file
