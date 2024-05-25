//
//  ModelColor.swift
//  ColorMixing
//
//  Created by Алексей on 25.05.2024.
//

import Foundation

struct ModelColor: Decodable {
    let name: Name
}

struct Name: Decodable {
    let value: String
}
