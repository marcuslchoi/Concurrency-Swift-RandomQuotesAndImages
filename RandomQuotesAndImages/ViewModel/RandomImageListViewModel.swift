//
//  RandomImageListViewModel.swift
//  RandomQuotesAndImages
//
//  Created by Marcus Choi on 1/11/22.
//

import Foundation
import UIKit

@MainActor
class RandomImageListViewModel: ObservableObject {
    
    //published props are set on the main thread, hence using mainactor
    @Published var randomImageVMs: [RandomImageViewModel] = []
    func getRandomImages(ids: [Int]) async {
        
        do {
            let randImages = try await Webservice().getRandomImages(ids: ids)
            self.randomImageVMs = randImages.map(RandomImageViewModel.init)
        } catch {
            print(error)
        }
    }
}

struct RandomImageViewModel: Identifiable {
    let id = UUID()
    fileprivate let randomImage: RandomImage
    
    var image: UIImage? {
        UIImage(data: randomImage.imageData)
    }
    
    var quoteStr: String {
        randomImage.quote.content
    }
}
