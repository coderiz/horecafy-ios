//
//  ApiResponse.swift
//  horecafy
//
//  Created by Pedro Martin Gomez on 12/2/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import Foundation

struct ApiResponse {
    let totalRows: Int
    let page: Int?
    let rows: Int?
    let error: String
    let message: String
    let data: [Any]
}
