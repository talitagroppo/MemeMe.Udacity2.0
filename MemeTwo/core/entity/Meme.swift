//
//  Meme.swift
//  MemeTwo
//
//  Created by Talita Groppo on 22/12/2021.
//

import Foundation

class Meme: Codable {
    let top: String
    let bottom: String
    let imagePath: String
    
    init(top: String, bottom: String, imagePath: String) {
        self.top = top
        self.bottom = bottom
        self.imagePath = imagePath
    }
}
