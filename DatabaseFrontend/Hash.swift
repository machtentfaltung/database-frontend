// Database Frontend
// Copyright (C) 2024-2025 Matei Pralea <matei.pralea@proton.me>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

//
//  Hash.swift
//  DatabaseFrontend
//
//  Created by Matei Pralea on 22/04/2024.
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
