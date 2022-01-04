//
//  MemeStorage.swift
//  MemeTwo
//
//  Created by Talita Groppo on 04/01/2022.
//

import Foundation

class MemeStorage {
    static private let identifier = "MemeStorage"
    var storage: UserDefaults
    
    init(storage: UserDefaults = .standard) {
        self.storage = storage
    }
    
    func save(meme: Meme) {
        if let objects = storage.object(forKey: MemeStorage.identifier) {
            var memes = try? JSONDecoder().decode([Meme].self, from: objects as! Data)
            memes?.append(meme)
            let encode = try? JSONEncoder().encode(memes)
            storage.set(encode, forKey: MemeStorage.identifier)
        } else {
            var memes = [Meme]()
            memes.append(meme)
            let encode = try? JSONEncoder().encode(memes)
            storage.set(encode, forKey: MemeStorage.identifier)
        }
    }
    
    func load() -> [Meme] {
        if let objects = storage.object(forKey: MemeStorage.identifier) {
            do {
                let memes = try JSONDecoder().decode([Meme].self, from: objects as! Data)
                return memes
            } catch {
                return [Meme]()
            }
        }
        return [Meme]()
    }
}
