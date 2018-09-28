//
//  Utils.swift
//

import UIKit

class Utils: NSObject {
    static func applicationDocumentsDirectory() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[0]
    }
}

struct Evaluacion {
    var ponencia: Int16 = 0
    var ponente: Int16 = 0
    var relevancia: Int16 = 0
}
