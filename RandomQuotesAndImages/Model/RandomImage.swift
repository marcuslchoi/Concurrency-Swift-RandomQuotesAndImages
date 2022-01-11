//
//  RandomImage.swift
//  RandomQuotesAndImages
//
//  Created by Marcus Choi on 1/11/22.
//

import Foundation

struct RandomImage: Decodable {
    let image: Data
    let quote: Quote
}

struct Quote: Decodable {
    let content: String
}
