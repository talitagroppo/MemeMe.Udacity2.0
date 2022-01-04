//
//  AddNewImage.swift
//  MemeTwo
//
//  Created by Talita Groppo on 04/01/2022.
//

import Foundation
import UIKit

class AddNewImage: UIViewController, UINavigationControllerDelegate {
    @IBOutlet weak var plusButton: UIBarButtonItem!
    
    @IBAction func plusButton(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: MemeImagePickerView.identifier) as! MemeImagePickerView
//        vc.allMemes = allMemes
        navigationController?.pushViewController(vc, animated: true)
    }
}
