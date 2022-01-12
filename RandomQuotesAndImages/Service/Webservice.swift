//
//  Webservice.swift
//  RandomQuotesAndImages
//
//  Created by Marcus Choi on 1/11/22.
//
//random photos https://picsum.photos/200/300
//random quotes https://api.quotable.io/random

import Foundation

enum NetworkError: Error {
    case badUrl
    case invalidImageId(Int)
    case decodingError
}

class Webservice {
    
    func getRandomImages(ids: [Int]) async throws -> [RandomImage]
    {
        var randomImages: [RandomImage] = []
        
        //using a task group
        try await withThrowingTaskGroup(of: (Int, RandomImage).self) { group in
            for id in ids {
                //created a reference to self
                group.addTask { [self] in
                    return (id, try await getRandomImage(id: id))
                }
            }
            //async sequence
            for try await (id, randImg) in group
            {
                randomImages.append(randImg)
            }
        }
        
        return randomImages
    }
    
    private func getRandomImage(id: Int) async throws -> RandomImage
    {
        guard let imgUrl = Constants.Urls.getRandomImageUrl() else {throw NetworkError.badUrl}
        guard let quoteUrl = Constants.Urls.randomQuoteUrl else {throw NetworkError.badUrl}
        
        //async let makes these run concurrently
        //thread suspension does not happen here
        async let (imgData, _) = URLSession.shared.data(from: imgUrl)
        async let (quoteData, _) = URLSession.shared.data(from: quoteUrl)
        
        //thread suspension happens here with await
        let randQuote = try JSONDecoder().decode(Quote.self, from: try await quoteData)
        return RandomImage(imageData: try await imgData, quote: randQuote)
    }
}
