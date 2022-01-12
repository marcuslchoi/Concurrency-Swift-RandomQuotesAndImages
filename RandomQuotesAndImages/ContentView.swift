//structured concurrency section 9 Async/Await and Actors - Concurrency in Swift (Udemy)

//
//  ContentView.swift
//  RandomQuotesAndImages
//
//  Created by Marcus Choi on 1/11/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var randomImageListVM = RandomImageListViewModel()
    
    var body: some View {
        List(randomImageListVM.randomImageVMs) { randImgVM in
            HStack {
                //map gives unwrapped version of the uiimage
                randImgVM.image.map {
                    //imageview
                    Image(uiImage: $0)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                Text(randImgVM.quoteStr)
            }
        }
        .task {
            await randomImageListVM.getRandomImages(ids: Array(0...30))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
