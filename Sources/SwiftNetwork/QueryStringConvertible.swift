//
//  QueryStringConvertible.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import Foundation

public protocol QueryStringConvertible {
    func toString() -> String?
}

extension Int: QueryStringConvertible {
    public func toString() -> String? {
        String(self)
    }
}

extension Double: QueryStringConvertible {
    public func toString() -> String? {
        String(self)
    }
}

extension Bool: QueryStringConvertible {
    public func toString() -> String? {
        String(self)
    }
}

extension String: QueryStringConvertible {
    public func toString() -> String? {
        self
    }
}
