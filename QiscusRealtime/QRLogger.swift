//
//  QRLogger.swift
//  QiscusRealtime
//
//  Created by Qiscus on 15/08/18.
//

import Foundation

class QRLogger {
    static func debugPrint(_ text: String) {
        if QiscusRealtime.enableDebugPrint {
            QRLogger.debugPrint("[QiscusRealtime] \(text)")
        }
    }
    
    static func errorPrint(_ text: String) {
        if QiscusRealtime.enableDebugPrint {
            QRLogger.debugPrint("[QiscusRealtime] Error: \(text)")
        }
    }
}
