
import Foundation


extension Array {
    
    func collectValues<EV>(_ formatter: (Element, Int) -> EV?) -> Array<EV> {
        
        var arr = Array<EV>();
        
        for (idx, elm) in self.enumerated() {
            
            let obj = formatter(elm, idx);
            
            if let anObj = obj {
                arr.append(anObj);
            }
        }
        
        return arr;
    }
   
    mutating func remove(atIndexes indexes: [Int]) {
        let sortedIndexes = indexes.sorted().reversed();
        for index in sortedIndexes {
            if index >= 0 &&
                index < count {
                self.remove(at: index)
            }
        }
    }
    
}
