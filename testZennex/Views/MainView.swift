
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
                MonthsView(viewModel: journalListViewModel)
                
                if journalListViewModel.currentMonthJournal.isEmpty {
                    noDataRowView
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(journalListViewModel.currentMonthJournal, id: \.self) { item in
                            NavigationLink(destination: DetailView(
                                dayOfWeek: item.dayOfWeek ?? "",
                                dayOfMonth: item.dayOfMonth ?? "",
                                dailyScore: item.dailyScore ?? "")
                            ) {
                                if item.isToday {
                                    VStack {
                                        MainRowView(viewModel: item)
                                        startJournalView
                                    }
                                } else {
                                    MainRowView(viewModel: item)
                                }
                            }
                        }
                        .foregroundColor(.black)
                    }
                    .padding()
                }
            }
            .navigationBarTitle("Journaling", displayMode: .inline)
        }
        .onAppear {
            self.journalListViewModel.fetchListJournal(journalListViewModel.currentMonth)
        }
    }
    
    private var noDataRowView: some View {
        List {
            Text("Нет данных")
        }
    }
    
    private var startJournalView: some View {
        HStack(alignment: .center) {
            Text("Start today's journal")
                .frame(width: 280, height: 40, alignment: .center)
                .foregroundColor(Color(hex: "#F6F6F6"))
                .background(Color(hex: "#313841"))
                .cornerRadius(8)
        }
    }
}

struct MonthView: View {
    var month : String
    var isSelected : Bool
    
    var body: some View {
        Text(month)
            .font(.custom(
                (isSelected ? "HelveticaNowDisplay-Bold" : "HelveticaNowDisplay"), size: 14)
            )
            .padding()
    }
}

struct MonthsView: View {
    var viewModel: JournalViewModel
    @State var selectedItem = 0

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(0..<viewModel.months.count, id: \.self) { item in
                    MonthView(
                        month: viewModel.months[item],
                        isSelected: item == selectedItem ? true : false
                    )
                    .onTapGesture {
                        selectedItem = item
                        viewModel.fetchListJournal(viewModel.months[item].lowercased())
                    }
                }
            }
        }
    }
}

struct TodayRowView: View {
    var viewModel: JournalRowViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 8) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(viewModel.colorFromDailyRating)
                    .frame(width: 8, height: 24)
                
                Text(viewModel.dayOfMonth ?? "")
                    .font(.custom("HelveticaNowDisplay-Bold", size: 16))
                
                Text("Today")
            }
            
            HStack(alignment: .center) {
                Text("Start today's journal")
                    .frame(width: 240, height: 40, alignment: .center)
                    .foregroundColor(Color(hex: "#F6F6F6"))
                    .background(Color(hex: "#313841"))
                    .cornerRadius(8)
            }
        }
    }
}

struct MainRowView: View {
    var viewModel: JournalRowViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 8) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(viewModel.colorFromDailyRating)
                    .frame(width: 8, height: 24)
                
                Text(viewModel.dayOfMonth ?? "")
                    .font(.custom("HelveticaNowDisplay-Bold", size: 16))
                    .fontWeight(.bold)
                
                Text(viewModel.dayOfWeek ?? "")
                    .font(.custom("HelveticaNowDisplay", size: 16))
                    .fontWeight(.light)
            }
            
            HStack {
                Spacer(minLength: 45)
                
                VStack(alignment: .leading) {
                    Text(viewModel.dailyScore ?? "")
                        .font(.custom("HelveticaNowDisplay", size: 12))
                        .foregroundColor(Color(hex: "#AAB2BB"))
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.photoLinks, id: \.self) { index in
                                CustomImageView(urlString: index)
                                    .clipped()
                                    .cornerRadius(4)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct CustomImageView: View {
    var urlString: String
    @ObservedObject var imageLoader = APIImageLoaderService()
    @State var image: UIImage = UIImage()
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width:67.2, height:48)
            .onReceive(imageLoader.$image) { image in
                self.image = image
            }
            .onAppear {
                imageLoader.loadImage(for: urlString)
            }
    }
}


