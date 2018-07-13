import Foundation

struct TypeOfFormat: Codable {
    let id: Int
    let name: String
}

struct TypeOfFormatResponse: Codable {
    let totalRows: Int
    let page: Int?
    let rows: Int?
    let error: String
    let message: String
    let data: [TypeOfFormat]
}
