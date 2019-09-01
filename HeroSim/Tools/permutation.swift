//
//  File.swift
//  Hero
//
//  Created by Quentin Zeller on 31.08.19.
//

import Foundation
class Combinatorix {
    
    
    
    static func permutationNoRep(arr: [String], data: inout [String], index: Int = 0, r: Int, result: inout [[String]]){
        
        if (index == r){result.append(data); return}
        
        for i in 0..<arr.count{ // (data.count)
            var listCp = arr
            data[index] = listCp.remove(at: i)
            permutationNoRep(arr: listCp, data: &data, index: index+1, r: r, result: &result)
        }
    }
    
    static func cardProd(array: [[[String]]]) -> [[String]]{
        
        var temporaraResult = [[String]]();
        
        var previous: [[String]] = array[0] // reference at each step (if |vectors|>2
        for a in 1..<array.count { // indice to cross product
            let second: [[String]] = array[a]
            
            for var b in previous {
                for s in second {
                    temporaraResult.append(b+s)
                }
            }
            previous = temporaraResult // next iteration of more than 2 vectors
            temporaraResult.removeAll()
        }
        
        return previous
        
    }
    

}
