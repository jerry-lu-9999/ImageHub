//
//  Collection.swift
//  ImageHub
//
//  Created by Jiahao Lu on 5/7/21.
//

import Foundation
import UIKit

struct Media: Equatable, Decodable{
    let m: String
}

struct Item: Equatable, Decodable{
    
    let title: String
    let link: String
    let media: Media
    let published: String
    let description: String
    let author: String
    let author_id : String
    let tags: String
//    let image : Data
//
//    private enum CodingKeys: CodingKey{
//        case title, link, media, published, description, author, author_id, tags
//    }
}

struct Collection: Decodable{
    let title: String
    let link: String
    let description: String
    let modified: String
    let generator: String
    let items: [Item]
}
