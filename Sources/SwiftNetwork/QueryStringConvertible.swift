//
//  QueryStringConvertible.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import Foundation

/// A protocol for types that can be converted to a string to be used in query parameters.
public protocol QueryStringConvertible {
    /// Converts the object to a string.
    ///
    /// - Returns: The string representation of the object or `nil` if it cannot be converted.
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
