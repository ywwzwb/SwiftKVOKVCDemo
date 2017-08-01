//: Playground - noun: a place where people can play

import Cocoa

class SimpleClass {
    var someValue: String = "123"
}
//SimpleClass().setValue("456", forKey: "someValue") // 错误, 必须要继承自 NSObject

// MARK: - kvc
class KVCClass :NSObject{
    var someValue: String = "123"
}
let kvc = KVCClass()
kvc.someValue
kvc.setValue("456", forKey: "someValue")
kvc.someValue

// MARK: - kvo

class KVOClass:NSObject {
    dynamic var someValue: String = "123"
    var someOtherValue: String = "abc"
}

class ObserverClass: NSObject {
    func observer() {
        let kvo = KVOClass()
        kvo.addObserver(self, forKeyPath: "someValue", options: .new, context: nil)
        kvo.addObserver(self, forKeyPath: "someOtherValue", options: .new, context: nil)
        kvo.someValue = "456"
        kvo.someOtherValue = "def"
        kvo.removeObserver(self, forKeyPath: "someValue")
        kvo.removeObserver(self, forKeyPath: "someOtherValue")
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("\(keyPath!) change to \(change![.newKey] as! String)")
    }
}
ObserverClass().observer()
