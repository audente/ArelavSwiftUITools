import Foundation

public extension Array {
    func edges(leading: Int, trailing: Int) -> [Element] {
        var result = [Element]()
        
        let count = self.count
        
        var end = leading
        if leading > count {
            end = count
        }
        for i in 0..<end {
            result.append(self[i])
        }
        
        var start = count - trailing
        if count < trailing + leading {
            start = leading
        }
        for i in start..<count {  
            result.append(self[i])  
        }
        
        return result
    }
}
