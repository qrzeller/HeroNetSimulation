//
//  labelTools.swift
//  AST
//
//  Created by Quentin Zeller on 23.08.19.
//

import Foundation
import Interpreter

// some function / closure to use for the labels of arcs
public struct LabelTools{
    
    // replace dynamically the opération
    public static func dynamicReplace(t: [String: String], label: String, interpreter: Interpreter) -> String? {
        if label == "" { return "true"} // return true of label inexistant
        var lab = label
        var searchRg:Range<String.Index> = lab.startIndex..<lab.endIndex
        while let idx = lab.range(of: "[$].*?[$]", options: .regularExpression, range: searchRg) {
            let rep = lab[lab.index(after: idx.lowerBound)..<lab.index(before: idx.upperBound)]
            if let bind = t[String(rep)] { lab.replaceSubrange(idx, with: bind)}
            else { print("📕 This binding does not exist: \(rep)"); return nil}
            searchRg = idx.lowerBound..<lab.endIndex
            
        }
        do {
            let value = try interpreter.eval(string: lab)
            return value.description
        }catch{
            print("📕 The interpreter cannot parse the input label, check the correct label definition")
            return nil
        }
        
    }
    
    // Transform output of swift in boolean, return false if other object than "True"
    public static func asBool(output: String?) -> Bool{
        return output?.uppercased() == "true".uppercased()
    }
    
    // Basic function, example function if you want to personalise the labels execution
    public static let opNoCurry = { (t: [String: String]) -> String? in
        let code: String = "operationNoCurry(a: \(t["a"]!), b: \(t["b"]!) , op: \(t["c"]!))"
        let value = try! interpreter.eval(string: code)
        return value.description
    }
    
    // Does not guard but print output
    public static let noGuardPrint = { (a: [String: String]) -> Bool in
        print("Guarded : \(a).")
        return true
    }
}
