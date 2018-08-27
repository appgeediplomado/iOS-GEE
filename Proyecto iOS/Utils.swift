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
