// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
class WelcomeJSON: Codable {
    let news: [NewsJSON]

    init(news: [NewsJSON]) {
        self.news = news
    }
}

// MARK: - News
class NewsJSON: Codable {
    let name, description, date: String
        let imageLink: String

        enum CodingKeys: String, CodingKey {
            case name, description, date
            case imageLink = "image_link"
        }

        init(name: String, description: String, date: String, imageLink: String) {
            self.name = name
            self.description = description
            self.date = date
            self.imageLink = imageLink
        }
}

enum NewsJSONError: Error, LocalizedError {
    case notConnected
    case notNewsFound
}

// MARK: - Fetching Data
extension WelcomeJSON {
    static func fetchNewsJSON() async throws -> Welcome {
        guard let url = URL(string: "http://martinmolina.com.mx/martinmolina.com.mx/reto_skiliket/Equipo9/news.json") else {
            throw NewsJSONError.notConnected
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NewsJSONError.notConnected
        }
        
        let jsonDecoder = JSONDecoder()
        let welcomeJSON = try jsonDecoder.decode(WelcomeJSON.self, from: data)
        
        let news = welcomeJSON.news.map { newsJSON in
            News(name: newsJSON.name, description: newsJSON.description, date: newsJSON.date, imageLink: newsJSON.imageLink)
        }
        return Welcome(news: news)
    }
}
