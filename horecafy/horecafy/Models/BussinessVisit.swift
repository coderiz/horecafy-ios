//
//  BussinessVisit.swift
//  horecafy
//
//  Created by iOS User 1 on 04/07/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import Foundation

struct BusinessPraposal:Codable {
    let WholesalerId:Int
    let typeOfBusinessId:Int
    let comments:String
    let zipcode:String
}

struct BusinessPraposalResponse:Codable {
    let totalRows: Int
    let page: Int?
    let rows: Int?
    let error: String
    let message: String
}


struct BusinessNotification:Codable {
    let hiddenId: Int64
    let id: String
    let zipcode: String?
    let typeOfBusinessId: Int64
    let customerId: Int64
    let wholesalerId: Int64
    let timeslot: String?
    let status: Bool
//    let createdOn: Date
    let borrado: Bool
    let comments: String
//    let name: String
    let Customer:CustomerObj
    let Wholesaler:WholesalerObj
}

struct CustomerObj:Codable {
    let id:String
    let hiddenId:Int64
    let name:String
}

struct WholesalerObj:Codable {
    let id:String
    let hiddenId:Int64
    let name:String
}

struct BusinessNotificationResponse:Codable {
    let totalRows: Int
    let page: Int?
    let rows: Int?
    let error: String
    let message: String
    let data: [BusinessNotification]
}

struct BusinessPraposalAcceptResponse:Codable {
    let totalRows: Int
    let page: Int?
    let rows: Int?
    let error: String
    let message: String
}


struct AvailibilityResponse:Codable {
    let totalRows: Int
    let page: Int?
    let rows: Int?
    let error: String
    let message: String
    let data:Availibility
}

struct Availibility:Codable {
//    let hiddenId: String
//    let id: String
    let RowNumber: String
    let availability: String
//    let createdOn: Date
}

struct SetTimeSlotResponse:Codable {
    let totalRows: Int
    let page: Int?
    let rows: Int?
    let error: String
    let message: String
}
