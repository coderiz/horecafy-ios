import Foundation

struct Demand: Codable {
    let hiddenId: String
    let familyId: Int
    let quantyPerMonth: Int
    let typeOfFormatId: Int
    let targetPrice: Double
    let brand: String
    let format: String
    let comments: String
    let createdOn: Date
    let borrado: Bool
}

struct MakeDemand: Codable {
    var brand: String
    var comments: String
    var format: String
    var hiddenId: Int64
    var id: String
    var quantyPerMonth: Int
    var targetPrice: Double
}

struct DemandResponse: Codable {
    let totalRows: Int
    let page: Int?
    let rows: Int?
    let error: String
    let message: String
    let data: [Demand]
}

struct MakeOffer: Codable {
    var borrado: Bool?
    var brand: String?
    var category: CategoryWithoutImage?
    var comments: String?
    var createdOn: Date?
    var demand: MakeDemand?
    var family: Family?
    var fomat: String?
    var hiddenId: Int?
    var id: String?
    var customerId: Int?
    var demandId: Int?
    var offerPrice: Double?
    var quantyPerMonth: Int?
    
    enum CodingKeys: String, CodingKey {
        case borrado = "borrado"
        case brand = "brand"
        case category = "category"
        case comments = "comments"
        case createdOn = "createdOn"
        case demand = "demand"
        case family = "family"
        case fomat = "fomat"
        case hiddenId = "hiddenId"
        case id = "id"
        case customerId = "customerId"
        case demandId = "demandId"
        case offerPrice = "offerPrice"
        case quantyPerMonth = "quantyPerMonth"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        borrado = try values.decodeIfPresent(Bool.self, forKey: .borrado)
        brand = try values.decodeIfPresent(String.self, forKey: .brand)
        category = try values.decodeIfPresent(CategoryWithoutImage.self, forKey: .category)
        comments = try values.decodeIfPresent(String.self, forKey: .comments)
        createdOn = try values.decodeIfPresent(Date.self, forKey: .createdOn)
        family = try values.decodeIfPresent(Family.self, forKey: .family)
        demand = try values.decodeIfPresent(MakeDemand.self, forKey: .demand)
        family = try values.decodeIfPresent(Family.self, forKey: .family)
        fomat = try values.decodeIfPresent(String.self, forKey: .fomat)
        hiddenId = try values.decodeIfPresent(Int.self, forKey: .hiddenId)
        quantyPerMonth = try values.decodeIfPresent(Int.self, forKey: .quantyPerMonth)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        customerId = try values.decodeIfPresent(Int.self, forKey: .customerId)
        demandId = try values.decodeIfPresent(Int.self, forKey: .demandId)
        offerPrice = try values.decodeIfPresent(Double.self, forKey: .offerPrice)
        quantyPerMonth = try values.decodeIfPresent(Int.self, forKey: .quantyPerMonth)
    }
}

struct Offer: Codable {
    let hiddenId: String
    let id: String
    let customerId: String
    let demandId: Int64
    let wholesalerId: String
    let quantyPerMonth: Int
    let typeOfFormatId: Int
    let offerPrice: Double
    let brand: String
    let fomat: String
    let comments: String
    let createdOn: Date
    let borrado: Bool
    let approvedByCustomer: String?
    let sentToCustomer: Date
    let rejected: Bool
}

struct OfferResponse: Codable {
    let totalRows: Int
    let page: Int?
    let rows: Int?
    let error: String
    let message: String
    let data: [Offer]
}

struct WholeSalerList: Codable {
    let id = -1
    let wholeSalerId: String
    let familyId: Int
    let brand: String
    let comments: String
    let createdOn = Date()
    let borrado: Bool
    
    init(wholeSalerId: String, familyId: Int, brand: String, comments: String, borrado: Bool) {
        self.wholeSalerId = wholeSalerId
        self.familyId = familyId
        self.brand = brand
        self.comments = comments
        self.borrado = borrado
    }
}

struct WholeSalerListResponse: Codable {
    let totalRows: Int
    let page: Int?
    let rows: Int?
    let error: String
    let message: String
    let data: [WholeSalerList]
}

struct DemandsByCustomer: Codable {
    let Customer: Customer
    let TypeOfFormat: TypeOfFormat
    let borrado: Bool
    let brand: String
    let createdOn: Date
    let family: Family
    let format: String
    let hiddenId: Int
    let id: String
    let quantyPerMonth: Int
    let targetPrice: Double
}


struct OfferCustomer: Codable {
    let customer: Customer?
    let typeOfFormat: TypeOfFormat?
    let borrado: Bool?
    let brand: String?
    let createdOn: Date?
    let family: Family?
    let format: String?
    let hiddenId: Int?
    let id: String?
    let offerPrice: Double?
    let quantyPerMonth: Int?
    let reject: Bool?
    let sentToCustomer: Date?
    let wholesaler: WholeSaler?
    
    enum CodingKeys: String, CodingKey {
        case customer = "Customer"
        case typeOfFormat = "TypeOfFormat"
        case borrado = "borrado"
        case brand = "brand"
        case createdOn = "createdOn"
        case family = "family"
        case format = "fomat"
        case hiddenId = "hiddenId"
        case id = "id"
        case offerPrice = "offerPrice"
        case quantyPerMonth = "quantyPerMonth"
        case reject = "rejected"
        case sentToCustomer = "sentToCustomer"
        case wholesaler = "wholesaler"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        customer = try values.decodeIfPresent(Customer.self, forKey: .customer)
        typeOfFormat = try values.decodeIfPresent(TypeOfFormat.self, forKey: .typeOfFormat)
        borrado = try values.decodeIfPresent(Bool.self, forKey: .borrado)
        brand = try values.decodeIfPresent(String.self, forKey: .brand)
        createdOn = try values.decodeIfPresent(Date.self, forKey: .createdOn)
        family = try values.decodeIfPresent(Family.self, forKey: .family)
        format = try values.decodeIfPresent(String.self, forKey: .format)
        hiddenId = try values.decodeIfPresent(Int.self, forKey: .hiddenId)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        offerPrice = try values.decodeIfPresent(Double.self, forKey: .offerPrice)
        quantyPerMonth = try values.decodeIfPresent(Int.self, forKey: .quantyPerMonth)
        reject = try values.decodeIfPresent(Bool.self, forKey: .reject)
        sentToCustomer = try values.decodeIfPresent(Date.self, forKey: .sentToCustomer)
        wholesaler = try values.decodeIfPresent(WholeSaler.self, forKey: .wholesaler)
    }
}

struct WholeSaler: Codable {
    let hiddenId: Int?
    let id: String?
    let name: String?
    let zipCode: String?
    
    enum CodingKeys: String, CodingKey {
        case hiddenId = "hiddenId"
        case id = "id"
        case name = "name"
        case zipCode = "zipCode"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        zipCode = try values.decodeIfPresent(String.self, forKey: .zipCode)
        hiddenId = try values.decodeIfPresent(Int.self, forKey: .hiddenId)
        id = try values.decodeIfPresent(String.self, forKey: .id)
    }
}

struct ListsByWholeSaler: Codable {
    let id: Int
    let wholeSalerId: Int
    let familyId: Int
    let brand: String
    let comments: String
    let createdOn: Date
    let borrado: Bool
    let family: Family
}

struct Customer: Codable {
    let hiddenId: Int64
    let id: String
    let name: String
}

struct DemandByCustomerResponse: Codable {
    let totalRows: Int
    let page: Int?
    let rows: Int?
    let error: String
    let message: String
    let data: [DemandsByCustomer]
}

struct OfferCustomerResponse: Codable {
    let totalRows: Int
    let page: Int?
    let rows: Int?
    let error: String
    let message: String
    let data: [OfferCustomer]
}

struct MakeOfferResponse: Codable {
    let totalRows: Int
    let page: Int?
    let rows: Int?
    let error: String
    let message: String
    let data: [MakeOffer]
}

struct DemandsByWholeSaler: Codable {
    let hiddenId: String
    let id: String
    let customerId: String
    let customerName: String
    let zipCode: String
    let familyId: Int
    let quantyPerMonth: Int
    let typeOfFormatId: Int
    let targetPrice: Double
    let brand: String
    let format: String
    let createdOn: Date
    let borrado: Bool
    let comments: String
    let sentTo: Date
}

struct DemandByWholeSalerResponse: Codable {
    let totalRows: Int
    let page: Int?
    let rows: Int?
    let error: String
    let message: String
    let data: [DemandsByWholeSaler]
}

struct ListsByWholeSalerResponse: Codable {
    let totalRows: Int
    let page: Int?
    let rows: Int?
    let error: String
    let message: String
    let data: [ListsByWholeSaler]
}




