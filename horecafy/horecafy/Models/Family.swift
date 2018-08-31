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

struct DataInAddFamilyResponse: Codable
{
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
    let createdOn: Date
    let visible: Bool
    let borrado: Bool
}

struct AddFamilyResponse: Codable
{
    let totalRows: Int
    let page: Int?
    let rows: Int?
    let error: String
    let message: String
    let data: [DataInAddFamilyResponse]
}
