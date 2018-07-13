//
//  Family.swift
//  horecafy
//
//  Created by Pedro Martin Gomez on 18/2/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import Foundation

struct Family: Codable {
    let id: Int
    let name: String
}

struct FamilyResponse: Codable {
    let totalRows: Int
    let page: Int?
    let rows: Int?
    let error: String
    let message: String
    let data: [Family]
}
