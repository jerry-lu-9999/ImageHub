//
//  Library.swift
//  ImageHub
//
//  Created by Jiahao Lu on 5/7/21.
//

import Foundation

let kDefaultSearchTerm = "Eibsee"
let kFeedsBaseURLString = "https://api.flickr.com/services/feeds/photos_public.gne"

enum ImageResult{
    case Success(Data)
    case Failure(Error)
}

enum PhotosResult{
    case Success(Collection)
    case Failure(Error)
}

class Library{
    
    private func getCollection(from data: Data) -> PhotosResult{
        do{
            let decoder = JSONDecoder()
            let collection = try decoder.decode(Collection.self, from: data)
            return .Success(collection)
        } catch let error{
            return .Failure(error)
        }
    }
    
    func getItem(thumbnail: Bool=true, item: Item, completion: @escaping (ImageResult) -> Void){
        let newURL = item.media.m.replacingOccurrences(of: "_m", with: thumbnail ? "_q" : "_b")
        if let url = URL(string: newURL){
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request, completionHandler:  { data, _, error in
                guard let imgData = data else {
                    if let err = error {
                        completion(.Failure(err))
                    }
                    return
                }
                completion(.Success(imgData))
            }).resume()
        }
    }
    
    // MARK: - Retrieval
    
    func feedsURL(parameters: [String:String]?) -> URL? {
        
        guard var components = URLComponents(string: kFeedsBaseURLString) else { return nil }
        
        var queryItems = [URLQueryItem]()
        if let params = parameters {
            for (key, value) in params {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        return components.url ?? nil
    }
    
    func fetchCollection(tags: String, completion: @escaping (PhotosResult) -> Void) {
        
        let params = ["format": "json", "nojsoncallback" : "1", "tags": tags]
        if let url = feedsURL(parameters: params) {

            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request, completionHandler:  { data, _, error in
                guard let jsonData = data else {
                    if let err = error {
                        completion(.Failure(err))
                    }
                    return
                }
                completion(self.getCollection(from: jsonData))
            }).resume()
        }
    }
}
