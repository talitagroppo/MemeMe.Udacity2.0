//
//  CollectionViewController.swift
//  MemeTwo
//
//  Created by Talita Groppo on 27/12/2021.
//

import UIKit

class CollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    static let collectionCellIdentifier = "collection"
    
    @IBOutlet var collectionViewController: UICollectionView!
    
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!
    
    let storage = MemeStorage()
    
    lazy var allMemes: [Meme] = {
        return storage.load()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0

        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        allMemes = storage.load()
        collectionView.reloadData()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allMemes.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewController.collectionCellIdentifier, for: indexPath) as! SetMemeCollectionViewCell
        let meme = allMemes[indexPath.row]
        let url = getDirectory().appendingPathComponent(meme.imagePath)
        if let data = try? Data(contentsOf: url) {
            guard let image = UIImage(data: data) else {
                cell.imageViewCell.image = UIImage(systemName: "pencil")
                return cell
            }
            cell.imageViewCell.image = image
            return cell
        } else {
            cell.imageViewCell.image = UIImage(systemName: "pencil")
            return cell
        }
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: DetailViewController.identifier) as! DetailViewController
        detailController.meme = allMemes[indexPath.row]
        navigationController?.pushViewController(detailController, animated: true)
    }
    
    func getDirectory() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[0]
    }
}
