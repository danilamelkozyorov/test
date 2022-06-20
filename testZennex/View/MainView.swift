
//  MainView.swift
//  testZennex
//
//  Created by Мелкозеров Данила on 13.06.2022.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var journalListViewModel = JournalViewModel()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(journalListViewModel.months, id: \.self) { month in
                            Button(month) {
                                self.journalListViewModel.fetchListJournal(month.lowercased())
                            }
                            .foregroundColor(.black)
                            .padding()
                        }
                    }
                }
                
                if journalListViewModel.currentMonthJournal.isEmpty {
                    List {
                        Text("Нет данных")
                    }
                } else {
                    List(journalListViewModel.currentMonthJournal, id: \.self) { message in
                        if message.isToday {
                            HStack(alignment: .top) {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(message.colorFromDailyRating)
                                    .frame(width: 8, height: 24)
                                
                                Text(message.dayOfMonth ?? "")
                                    .font(.custom("HelveticaNowDisplay", size: 16))
                                    .fontWeight(.medium)
                                
                                VStack(alignment: .leading) {
                                    Text("Today")
                                    ZStack(alignment: .leading) {
                                        NavigationLink(destination: DetailView(dayOfWeek: "Здесь мог быть textfield для набора текста", dayOfMonth: "", dailyScore: "0")) {
                                            EmptyView()
                                        }
                                        
                                        Button("Start today's journal") {
                                            print("start writing")
                                        }
                                        .frame(width: 240, height: 40, alignment: .center)
                                        .foregroundColor(.white)
                                        .background(.black)
                                    }
                                }
                            }
                        } else {
                            ZStack {
                                NavigationLink(destination: DetailView(
                                    dayOfWeek: message.dayOfWeek ?? "",
                                    dayOfMonth: message.dayOfMonth ?? "",
                                    dailyScore: message.dailyScore ?? "")
                                ) {
                                    EmptyView()
                                }
                                HStack(alignment: .top) {
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(message.colorFromDailyRating)
                                        .frame(width: 8, height: 24)
                                    
                                    Text(message.dayOfMonth ?? "")
                                        .font(.custom("HelveticaNowDisplay", size: 16))
                                        .fontWeight(.medium)
                                    
                                    VStack(alignment: .leading) {
                                        Text(message.dayOfWeek ?? "")
                                            .font(.custom("HelveticaNowDisplay", size: 16))
                                            .fontWeight(.light)
                                        
                                        Text((message.dailyScore ?? "") + " points")
                                            .font(.custom("HelveticaNowDisplay", size: 12))
                                            .foregroundColor(Color(hex: "#AAB2BB"))
                                        
                                        ScrollView(.horizontal) {
                                            HStack {
                                                ForEach(message.photoLinks, id: \.self) { index in
                                                    AsyncImage(url: URL(string: index)) { image in
                                                        image
                                                            .resizable()
                                                            .scaledToFit()
                                                    } placeholder: {
                                                        ProgressView()
                                                    }
                                                    .cornerRadius(4)
                                                    .frame(width: 67.2, height: 48)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Journaling", displayMode: .inline)
        }.onAppear {
            self.journalListViewModel.fetchListJournal(journalListViewModel.currentMonth)
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}

