//
//  JournalModel.swift
//  testZennex
//
//  Created by Мелкозеров Данила on 13.06.2022.
//

import Foundation

// MARK: - JournalListModel
struct JournalModel: Decodable, Identifiable {
    var id: Int?
    let data: DataClass?
    
    static var placeholder: Self {
        return JournalModel(id: nil, data: nil)
    }
}

// MARK: - DataClass
struct DataClass: Decodable {
    let getJournalingHome: GetJournalingHome?
}

// MARK: - GetJournalingHome
struct GetJournalingHome: Decodable {
    let status: Int?
    let success: Bool?
    let message: [Message]
}

// MARK: - Message
struct Message: Decodable, Hashable {
    let date: String?
    let dailyScore: Double?
    let dailyRating: Int?
    let remainingHours: Double?
    let photoLinks: [String]?

    enum CodingKeys: String, CodingKey {
        case date
        case dailyScore = "daily score"
        case dailyRating = "daily rating"
        case remainingHours = "remaining hours"
        case photoLinks = "photo links"
    }
}
