//
//  ReviewOffers.swift
//  horecafy
//
//  Created by iOS User 1 on 11/07/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import Foundation

struct ReviewOfferResponse:Codable {

    let totalRows: Int
    let page: Int?
    let rows: Int?
    let error: String
    let message: String
    let data:[OfferObject]

}

struct OfferObject:Codable {
    let hiddenId:Int64
    let id:String
    let WholeSaler:WholesalerOfferObj
    let Demand:DemandOfferObj
    let quantyPerMonth:Int
    let TypeOfFormat:TypeOfFormatOfferObj
    let offerPrice: Double
    let brand: String
    let fomat: String
    let comments: String
    let Product:ProductOfferObj
    let approvedByCustomer: String
    let borrado: Bool
//    let sentToCustomer:Date
    let rejected:Bool
    let images: String
    let video: String
}

struct WholesalerOfferObj:Codable {
    let hiddenId:Int64
    let id: String
    let name:String
}

struct DemandOfferObj:Codable {
    let hiddendId:Int64
    let id: String
}

struct ProductOfferObj:Codable {
    let id: Int64
    let name:String
}

struct TypeOfFormatOfferObj:Codable {
    let id: Int64
    let name:String
}

//Offer DistributorObject

struct DistributorObj:Codable {
    let hiddendId:Int64
    let id: String
    let name:String
    let Products:[OfferObject]
}

//Offer ProductObject
struct ProductObj:Codable {
    let id: Int64
    let name:String
    var Distributors:[OfferObject]
}



