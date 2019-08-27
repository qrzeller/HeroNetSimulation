//
//  structures2.swift
//  Alpine-test1
//
//  Created by Quentin Zeller on 03.08.19.
//

struct Structures2{
    // Calculatrix, return Int
    indirect enum ArithmeticExpressionStandard {
        case number(Int)
        case addition(ArithmeticExpressionStandard, ArithmeticExpressionStandard)
        case multiplication(ArithmeticExpressionStandard, ArithmeticExpressionStandard)
        case add2(ArithmeticExpressionStandard)
        case add4(ArithmeticExpressionStandard)
        
        func evaluate(_ expression: ArithmeticExpressionStandard) -> Int {
            switch expression {
            case let .number(value):
                return value
            case let .addition(left, right):
                return evaluate(left) + evaluate(right)
            case let .multiplication(left, right):
                return evaluate(left) * evaluate(right)
            case let .add2(a):
                return evaluate(a) + 2
            case let .add4(a):
                return evaluate(a) + 4
            }
        }
    }
    
    
    
    // |||||||||||||||||||||||||||| FOR PARTIAL APPLICATION |||||||||||||||||||||||||||||
    indirect enum ArithmeticPartialExpression {
        case addition(ArithmeticExpressionStandard)
        case multiplication(ArithmeticExpressionStandard)
    }
    
    // currying, inspired from : https://thoughtbot.com/blog/introduction-to-function-currying-in-swift
    func add(a: Int) -> ((Int) -> Int) {
        return { b in a + b }
    }
    //    func add(a: Int)(b: Int) -> Int {
    //        return a + b
    //    }
    
    func partialEvaluate(_ expression: ArithmeticPartialExpression) -> ((ArithmeticExpressionStandard) -> ArithmeticExpressionStandard) {
        switch expression {
        case let .addition(a):
            return { b in ArithmeticExpressionStandard.addition(a, b) }
        case let .multiplication(a):
            return { b in ArithmeticExpressionStandard.multiplication(a, b) }
        }
    }
    
    // partialEvaluate, trying to remove call to partial evaluate ?
    func test3(){
        let five = ArithmeticExpressionStandard.number(5)
        let four = ArithmeticExpressionStandard.number(4)
        
        let sumStd = ArithmeticExpressionStandard.addition(five, four)
        
        // take ArithmeticExpressionStandard as input (not avaluated)
        let sumPart = ArithmeticPartialExpression.addition(sumStd) // return functions
        
        // can we put function here before evaluate ????
//        let sumPart2 = ArithmeticPartialExpression.addition(sumPart)
        
        let notEval = partialEvaluate(sumPart)
        let sum = notEval(four)
        
        let product = partialEvaluate(ArithmeticPartialExpression.multiplication(sum))(ArithmeticExpressionStandard.number(2))
        
        print(ArithmeticExpressionStandard.evaluate(product))
        
        
    }
    
    
    // partialEvaluate
    func test2(){
        let five = ArithmeticExpressionStandard.number(5)
        let four = ArithmeticExpressionStandard.number(4)
        
        let sumStd = ArithmeticExpressionStandard.addition(five, four)
        
        // take ArithmeticExpressionStandard as input (not avaluated)
        let sumPart = partialEvaluate( ArithmeticPartialExpression.addition(sumStd) ) // return functions
        
        // can we put function here before evaluate ????
        
        let sum = sumPart(four)
        let product = partialEvaluate(ArithmeticPartialExpression.multiplication(sum))(ArithmeticExpressionStandard.number(2))
        
        print(ArithmeticExpressionStandard.evaluate(product))
        
        
    }
    
    
    // Standard evaluate
    func test1(){
        let five = ArithmeticExpressionStandard.number(5)
        let four = ArithmeticExpressionStandard.number(5)
        let sum = ArithmeticExpressionStandard.addition(five, four)
        let product = ArithmeticExpressionStandard.multiplication(sum, ArithmeticExpressionStandard.number(2))
        
        print(ArithmeticExpressionStandard.evaluate(product))
        
        
    }
    
}

