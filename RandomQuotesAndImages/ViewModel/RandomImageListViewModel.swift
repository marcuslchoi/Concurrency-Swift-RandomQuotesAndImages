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
    
    //this func waits for all images to be downloaded first, then displays them
    func getRandomImagesSlow(ids: [Int]) async {
        
        do {
            let randImages = try await Webservice().getRandomImages(ids: ids)
            self.randomImageVMs = randImages.map(RandomImageViewModel.init)
        } catch {
            print(error)
        }
    }
    
    //this func immediately displays any downloaded images once it is downloaded
    func getRandomImages(ids: [Int]) async {
        let webservice = Webservice()
        do {
            try await withThrowingTaskGroup(of: (Int, RandomImage).self) { group in
                for id in ids {
                    group.addTask {
                        return (id, try await webservice.getRandomImage(id: id))
                    }
                }
                
                //async sequence
                for try await (_, randImg) in group {
                    let randImgVM = RandomImageViewModel(randomImage: randImg)
                    randomImageVMs.append(randImgVM)
                }
            }
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
