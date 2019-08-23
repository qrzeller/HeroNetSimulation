
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


let p = PetriNet()
p.definitionTest()
p.marking()



// Questions :
//      - Allow multiple ouput ? (and in alpine ?)
//      - In x, y ;  out x, x
//      - Out x+y ; x-y sur même place?

// TODO:
//      - label in alpine.
//      - definition file
