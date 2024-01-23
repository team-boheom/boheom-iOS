import Foundation

struct PostRequest: Encodable {
    enum CodingKeys: String, CodingKey {
        case title
        case content
        case recruitment
        case startDay = "start_day"
        case endDay = "end_day"
        case tag
    }

    let title: String
    let content: String
    let recruitment: Int
    let startDay: String
    let endDay: String
    let tag: [String]
}
