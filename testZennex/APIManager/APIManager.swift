//
//  APIManager.swift
//  testZennex
//
//  Created by Мелкозеров Данила on 13.06.2022.
//

import Foundation
import Combine
import UIKit

class APIManager {
    static let shared = APIManager()
        
    private func getListJournalURL(month: String) -> URL? {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "swiftdevs.ru"
        components.path = "/jsons/\(month).json"
        return components.url
    }
    
    func fetchData(for month: String) -> AnyPublisher<JournalModel, Never> {
        guard let url = getListJournalURL(month: month) else {
            return Just(JournalModel.placeholder)
                .eraseToAnyPublisher()
        }
        
        return
            URLSession.shared.dataTaskPublisher(for: url)
                .map { $0.data }
                .decode(type: JournalModel.self, decoder: JSONDecoder())
                .catch { error in Just(JournalModel.placeholder) }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
    }
}

class APIImageLoaderService: ObservableObject {
    @Published var image: UIImage = UIImage()
    
    func loadImage(for urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: data) ?? UIImage()
            }
        }
        task.resume()
    }
}
    

