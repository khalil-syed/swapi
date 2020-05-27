//Created on 27/5/20

import Foundation

struct APIResponse<T>: Decodable where T: Decodable {
    
    let count: Int
    let results: T
}
