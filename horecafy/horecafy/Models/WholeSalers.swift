//
//  WholeSalers.swift
//  horecafy
//
//  Created by iOS User 1 on 02/07/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import Foundation

struct Distributor:Codable {
    let hiddenId: String
    let id: String
    let VAT: String
    let email: String
    let name: String
    let typeOfBusinessId: Int
    let contactName: String
    let contactEmail: String
    let contactMobile: String
    let address: String
    let city: String
    let zipCode: String
    let province: String
    let country: String
//    let createdOn: Date
    let visible: Bool
    let borrado: Bool
}

struct WholesalerResponseData:Codable {
    let totalRows: Int
    let page: Int?
    let rows: Int?
    let error: String
    let message: String
    let data: [Distributor]
}

struct MakeAnOrder:Codable {
    let customerId:Int
    let WholesalerId:Int
    let deliveryDate:String
    let products:String
    let deliveryTime:String?
    let comments:String?
}

struct MakeOrderResponse:Codable {
        let totalRows: Int
        let page: Int?
        let rows: Int?
        let error: String
        let message: String
}

