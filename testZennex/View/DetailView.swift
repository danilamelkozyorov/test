//
//  DetailView.swift
//  testZennex
//
//  Created by Мелкозеров Данила on 14.06.2022.
//

import SwiftUI


struct DetailView: View {
    let dayOfWeek: String
    let dayOfMonth: String
    let dailyScore: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            HStack(alignment: .center) {
                Text(dayOfMonth)
                Text(dayOfWeek)
            }
            Text(dailyScore + "points")
        }
    }
}

