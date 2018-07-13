//
//  ContactDistributorResponse.swift
//  horecafy
//
//  Created by iOS User 1 on 12/07/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import Foundation

struct ContactDistributorResponse: Codable {
    let totalRows: Int
    let page: Int?
    let rows: Int?
    let error: String
    let message: String
}
