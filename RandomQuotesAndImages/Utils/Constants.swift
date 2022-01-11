//
//  Constants.swift
//  RandomQuotesAndImages
//
//  Created by Marcus Choi on 1/11/22.
//

import Foundation

struct Constants {
    struct Urls {
        static func getRandomImageUrl() -> URL? {
            //need something unique at end, otherwise might get cached image
            return URL(string: "https://picsum.photos/200/300?uuid=\(UUID().uuidString)")
        }
        
        static let randomQuoteUrl: URL? = URL(string: "https://api.quotable.io/random")
    }
}
