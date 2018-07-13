//
//  InviteDistributor.swift
//  horecafy
//
//  Created by iOS User 1 on 03/07/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import Foundation

struct InvitationResoponse:Codable {
    let totalRows: Int
    let page: Int?
    let rows: Int?
    let error: String
    let message: String
    let data: [Invitator]
}

struct Invitator:Codable {
    let hiddenId:String
    let id:String
    let customerId:String
    let createdOn:String
    let name:String
    let email:String
    let phone:String
    let contact:String
}

struct InviteDistributor:Codable {

    let customerId:Int
    let name:String
    let email:String
    let phone:String
    let contact:String

}
