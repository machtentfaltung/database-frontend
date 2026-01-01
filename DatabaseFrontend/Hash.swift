//  SPDX-License-Identifier: MIT OR Apache-2.0
//
//  Hash.swift
//  DatabaseFrontend
//
//  Created by Matei Pralea on 22/04/2024.
//  Copyright © 2024-2026 Matei Pralea. All rights reserved.
//

import Foundation
import CryptoKit


func computeHash(for string: String, salt: String = String()) -> String {
    if salt.isEmpty {
        return SHA512.hash(data: Data(string.utf8))
            .compactMap { String(format: "%02x", $0) }
            .joined()
    }
    else {
        return SHA512.hash(data: Data("\(string)\(salt)".utf8))
            .compactMap { String(format: "%02x", $0) }
            .joined()
    }
}

func salt(length: Int = 12) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map{ _ in letters.randomElement()! })
}
