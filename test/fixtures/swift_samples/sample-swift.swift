import UIKit

typealias SomeTypeAlias = Double

enum SomeEnum {
    
}

class SomeClass {
    
}

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
