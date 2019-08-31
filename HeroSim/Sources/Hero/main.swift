
//
//  File.swift
//  Alpine-test1
//
//  Created by Quentin Zeller on 06.08.19.
//

import Foundation
import Interpreter
let filePath = "/Users/quentinzeller/Github/OFA/HeroNetSimulation/HeroSim/Sources/Hero/curry.alpine"
let fileDef  = "/Users/quentinzeller/Github/OFA/HeroNetSimulation/HeroSim/Sources/Hero/hnet.json"


print("__________________ HeroN ____________________")

var interpreter = Interpreter()
let module = PetriNet.readFile(fileName: filePath)
try! interpreter.loadModule(fromString: module)
let labelExecution = {d, l in LabelTools.dynamicReplace(t: d, label: l, interpreter: interpreter)}



let p = PetriNet()
//p.definitionTest(labelExecution: labelExecution)
//p.startDefinitionTest()
p.loadDefinitionFile(path: fileDef, labelExecution: labelExecution)
//p.manualRun(transitionName: "t1", binding: ["a":"2","c":"sub"])
//p.randomRun()
//p.transitions["t2"]?.fire()

Combination.test()
//p.marking()



// TODO:
//      - label in alpine.
//      - definition file
//      - Marking
