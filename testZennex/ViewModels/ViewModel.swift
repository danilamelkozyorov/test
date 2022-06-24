//
//  ViewModel.swift
//  testZennex
//
//  Created by Мелкозеров Данила on 15.06.2022.
//

import Foundation
import Combine
import SwiftUI

final class JournalViewModel: ObservableObject {
    let currentMonth = "june"
    
    @Published var months = ["June", "May", "April", "March", "February", "January"]
    @Published var currentMonthJournal = [JournalRowViewModel]()
    
    private var cancellableSet: AnyCancellable?
    private var isToday: Bool = false
    
    func fetchListJournal(_ month: String) {
        cancellableSet = APIManager.shared.fetchData(for: month).sink(
            receiveValue: { [weak self] journalModel in
                guard let strongSelf = self else { return }
                strongSelf.currentMonthJournal = (journalModel.data?.getJournalingHome?.message
                    .filter {
                        strongSelf.isToday = false
                        if $0.date == Date().currentDateToString() {
                            strongSelf.isToday = true
                        }
                        return $0.dailyScore != nil || strongSelf.isToday
                    }
                    .reversed()
                    .map { JournalRowViewModel($0) }) ?? [JournalRowViewModel]()
            }
        )
    }
}

struct JournalRowViewModel: Hashable {
    private let message: Message
    
    var isToday: Bool {
        return message.date == Date().currentDateToString() ? true : false
    }
    
    var dayOfMonth: String? {
        guard let dayOfMonth = message.date else { return nil }
        return dayOfMonth.getDayOfMonthFromString()
    }
    
    var dayOfWeek: String? {
        guard let dayOfWeek = message.date else { return nil }
        return dayOfWeek.getDayOfWeekFromString()
    }
    
    var dailyScore: String? {
        guard let score = message.dailyScore else { return nil }
        return score > 0 ? "+" + String(Int(score)) : String(Int(score))
    }
    
    var colorFromDailyRating: Color {
        guard let dailyRating = message.dailyRating,
              let remainingHours = message.remainingHours else { return .black}
        
        if remainingHours >= 12 {
            switch dailyRating {
            case -10..<0:
                return .init(hex: "#F28C8C") // red
            case 0...4:
                return .init(hex: "#EDBD5E") // yellow
            case 5...10:
                return .init(hex: "#BEC982") // green
            default:
                return .black
            }
        } else {
            return .init(hex: "#E6E6E6") // gray
        }
    }
    
    var photoLinks: [String] {
        guard let links = message.photoLinks else { return [] }
        return links
    }
    
    init(_ message: Message) {
        self.message = message
    }
}

