//
//  FreeDemand.swift
//  horecafy
//
//  Created by iOS User 1 on 27/06/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import Foundation

struct FreeDemandResponse: Codable {
    let totalRows: Int
    let page: Int?
    let rows: Int?
    let error: String
    let message: String
    let data: [FreeDemand]
   
}

struct CreateFreeDemand:Codable {
    var customerId:Int
    var demandText:String
}

struct FreeDemand:Codable {
    var hiddenId:String
    var id:String
    var customerId:String
    var demandText:String
    var createdOn:Date
}
