import UIKit

typealias SomeTypeAlias = Double  /* multiple line comment
/* nested
*/ code mixed with comments are counted as comments.. nandrei?
*/ enum SomeEnum {
    
}

class SomeClass {
    
}

// Single line comment
struct SomeStruct {
    
    init?() {
        return nil
    }
    
    func instanceMethod() -> Bool {
        let option = "bla"
        switch option {
        case "bla":
            return true
        default:
            return false
        }
    }
    
    func delay() {
        DispatchQueue.main.async {
            print("bla")
        }
    }
}
