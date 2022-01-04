//
//  DetailViewController.swift
//  MemeTwo
//
//  Created by Talita Groppo on 04/01/2022.
//

import UIKit

class DetailViewController: UIViewController {
    static let identifier = "DetailViewController"

    @IBOutlet var memeImageView: UIImageView!
    @IBOutlet var topLabel: UILabel!
    @IBOutlet var bottomLabel: UILabel!
    
    var meme: Meme?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let meme = meme {
            let path = getDirectory().appendingPathComponent(meme.imagePath)
            memeImageView.image = UIImage(contentsOfFile: path.path)
        }
    }
    
    func getDirectory() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[0]
    }
}

