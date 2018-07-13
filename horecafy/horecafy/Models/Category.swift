//
//  Category.swift
//  
//
//  Created by Pedro Martin Gomez on 12/2/18.
//

import Foundation

struct Category: Codable {
    let id: Int
    let name: String
    let image: String
    let totalFamilies:Int
}

struct CategoryWithoutImage: Codable {
    let id: Int
    let name: String
}

struct CategoryResponse: Codable {
    let totalRows: Int
    let page: Int?
    let rows: Int?
    let error: String
    let message: String
    let data: [Category]
}

struct CategoryWithFamilyCount: Codable {
    let id: Int
    let name: String
    let image: String
    let familyCount: Int
}

struct CategoryWithFamilyCountResponse: Codable {
    let totalRows: Int
    let page: Int?
    let rows: Int?
    let error: String
    let message: String
    let data: [CategoryWithFamilyCount]
}
