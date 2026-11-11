//
//  Date.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 22.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

extension Date {

    private static let readableFormat = "dd/MM/yyyy HH:mm:ss"

    // Cache the DateFormatter as instantiation is expensive. DateFormatter is thread-safe in macOS 10.9+
    private static let readableDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = Date.readableFormat
        return formatter
    }()

    var readable: String {
        return Date.readableDateFormatter.string(from: self)
    }
    
    func format(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
}
