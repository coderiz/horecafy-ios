//
//  MenuStats.swift
//  horecafy
//
//  Created by aipxperts on 25/08/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import Foundation

struct wholesalerStats: Codable
{
    let totalPendingDemands: Int
    let totalPendingVisits: Int
}

struct wholesalerStatsResponse: Codable
{
//    let totalRows:Int
    let page:Int?
    let rows:Int?
    let error:String
    let message:String
    let data:wholesalerStats
}

struct customerStats: Codable
{
    let totalPendingOffers: Int
    let totalPendingVisits: Int
}

struct customerStatsResponse: Codable
{
//    let totalRows:Int
    let page:Int?
    let rows:Int?
    let error:String
    let message:String
    let data:customerStats
}
