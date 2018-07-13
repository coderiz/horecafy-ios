//
//  CustomerBusinessRequest.swift
//  horecafy
//
//  Created by iOS User 1 on 30/06/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import Foundation


struct CustomerBusinessRequest:Codable {
    let customerId:Int
    let productName:String
    let brand:String
    let consumption:String
    let targetPrice:Double
    let MailFlag:String
}

struct BusinessRequestResponse: Codable {
    let totalRows: Int
    let page: Int?
    let rows: Int?
    let error: String
    let message: String
    let data: [BusinessResponse]
    
}

struct BusinessResponse:Codable {
    let hiddenId:String
    let id:String
    let customerId:String
    let productName:String
    let targetPrice:Double
    let brand:String
    let consumption:String
    let createdOn:Date
}
