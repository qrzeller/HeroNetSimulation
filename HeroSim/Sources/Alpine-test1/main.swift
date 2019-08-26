
//
//  File.swift
//  Alpine-test1
//
//  Created by Quentin Zeller on 06.08.19.
//

import Foundation
import Interpreter
let filePath = "/Users/quentinzeller/Github/OFA/HeroNetSimulation/HeroSim/Sources/Alpine-test1/curry.alpine"
let fileDef  = "/Users/quentinzeller/Github/OFA/HeroNetSimulation/HeroSim/Sources/Alpine-test1/hnet.json"


print("__________________ HeroN ____________________")

var interpreter = Interpreter()
let module = PetriNet.readFile(fileName: filePath)
try! interpreter.loadModule(fromString: module)



let p = PetriNet(interpreter : interpreter)
p.definitionTest()
p.startDefinitionTest()
p.loadDefinitionFile(path: fileDef)
//p.marking()



// TODO:
//      - label in alpine.
//      - definition file
//      - Marking
