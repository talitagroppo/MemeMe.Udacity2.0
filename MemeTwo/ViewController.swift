//
//  ViewController.swift
//  MemeTwo
//
//  Created by Talita Groppo on 22/12/2021.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    static let cellIdentifier = "cell"

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var plusButton: UIBarButtonItem!
    
    @IBAction func plusButton(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: MemeImagePickerView.identifier) as! MemeImagePickerView
//        vc.allMemes = allMemes
        navigationController?.pushViewController(vc, animated: true)
    }
    
    let storage = MemeStorage()
    
    lazy var allMemes: [Meme] = {
        return storage.load()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        allMemes = storage.load()
        tableView.reloadData()
        navigationController?.tabBarController?.tabBar.isHidden = false
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMemes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.cellIdentifier, for: indexPath) as! SetMemeTableViewCell
        let meme = allMemes[indexPath.row]
        cell.memeTop.text = ("\(meme.top)...\(meme.bottom)")
//        cell.memeBottom.text = meme.bottom
        let url = getDirectory().appendingPathComponent(meme.imagePath)
        if let data = try? Data(contentsOf: url) {
            guard let image = UIImage(data: data) else {
                cell.memeImageView.image = UIImage(systemName: "pencil")
                return cell
            }
            cell.memeImageView.image = image
            return cell
        } else {
            cell.memeImageView.image = UIImage(systemName: "pencil")
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: DetailViewController.identifier) as! DetailViewController
        detailController.meme = allMemes[indexPath.row]
        navigationController?.pushViewController(detailController, animated: true)
    }
    
    func getDirectory() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[0]
    }
}
