# SwiftKVOKVCDemo
首先需要知道的是, KVO, KVC 都是Objective-C 运行时的特性, Swift 是不具有的, 想要使用, 必须要继承 NSObject, 自然, 继承都没有的结构体也是没有 KVO, KVC 的, 这是前提.
例如, 下面的这段错误代码:
```
class SimpleClass {
    var someValue: String = "123"
}
//SimpleClass().setValue("456", forKey: "someValue") // 错误, 必须要继承自 NSObject
```
### KVC
Swift 下的 KVC 用起来很简单, 只要继承 NSObject 就行了.
```
class KVCClass :NSObject{
    var someValue: String = "123"
}
let kvc = KVCClass()
kvc.someValue // 123
kvc.setValue("456", forKey: "someValue")
kvc.someValue // 456
```
### KVO
KVO 就稍微麻烦一些了,由于 Swift 为了效率, 默认禁用了动态派发, 因此想用 Swift 来实现 KVO, 我们还需要做额外的工作, 那就是将想要观测的对象标记为 dynamic.
```
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
```
这段代码只会输出`someValue change to 456
`
