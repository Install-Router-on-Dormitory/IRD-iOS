import Foundation

struct MyProfileDTO: Decodable {
    let id: Int
    let email: String
    let name: String
    let profileUri: String?
    let grade: Int
    let classNum: Int
    let num: Int
}
