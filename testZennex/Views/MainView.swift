
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
                monthScrollView
                
                if journalListViewModel.currentMonthJournal.isEmpty {
                    noDataRowView
                } else {
                    List(journalListViewModel.currentMonthJournal, id: \.self) { message in
                        if message.isToday {
                            TodayRowView(viewModel: message)
                        } else {
                            MainRowView(viewModel: message)
                        }
                    }
                    .padding(-20)
                }
            }
            .navigationBarTitle("Journaling", displayMode: .inline)
        }
        .onAppear {
            self.journalListViewModel.fetchListJournal(journalListViewModel.currentMonth)
        }
    }
        
    private var monthScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
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
    }
    
    private var noDataRowView: some View {
        List {
            Text("Нет данных")
        }
    }
}

struct TodayRowView: View {
    var viewModel: JournalRowViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(viewModel.colorFromDailyRating)
                    .frame(width: 8, height: 24)
                
                Text(viewModel.dayOfMonth ?? "")
                    .font(.custom("HelveticaNowDisplay-Bold", size: 16))
                Text("Today")
            }
            
            ZStack(alignment: .center) {
                NavigationLink(
                    destination: DetailView(dayOfWeek: "Здесь мог быть textfield для набора текста",
                                            dayOfMonth: "",
                                            dailyScore: "0")
                ) { EmptyView() }
                
                Button("Start today's journal") {
                    print("start writing")
                }
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
        ZStack {
            NavigationLink(destination: DetailView(
                dayOfWeek: viewModel.dayOfWeek ?? "",
                dayOfMonth: viewModel.dayOfMonth ?? "",
                dailyScore: viewModel.dailyScore ?? "")
            ) {
                EmptyView()
            }
            HStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(viewModel.colorFromDailyRating)
                    .frame(width: 8, height: 24)

                Text(viewModel.dayOfMonth ?? "")
                    .font(.custom("HelveticaNowDisplay-Bold", size: 16))
                    .fontWeight(.bold)
                
                VStack(alignment: .leading) {
                    Text(viewModel.dayOfWeek ?? "")
                        .font(.custom("HelveticaNowDisplay", size: 16))
                        .fontWeight(.light)
                    
                    Text((viewModel.dailyScore ?? "") + " points")
                        .font(.custom("HelveticaNowDisplay", size: 12))
                        .foregroundColor(Color(hex: "#AAB2BB"))
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.photoLinks, id: \.self) { index in
                                CustomImageView(urlString: index)
                                    .clipped()
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

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}

