import Foundation

var a: Array<Float> = Array()
a.append(10)
var b: Array<String> = Array()
b.append("10")


let x = 3

func test(a: Int) -> Void{
    print("hello \(a)")
}
let testAny: Any = test as Any

let youhyou = testAny as! (Int) -> Void

let saveCast = type(of: testAny)
//let voila   = testAny as! saveCast


// workaround
func cast<T>(value: Any, to type: T) -> T {
    return value as! T
}

let voilaOk = cast(value: testAny, to: youhyou)

voilaOk(4)

youhyou(3)
//voila(3)

