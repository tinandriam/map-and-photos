//
//  ViewController.swift
//  lab6
//
//  Created by Tina Andria on 26/04/2020.
//  Copyright © 2020 Tina Andria. All rights reserved.
//

import UIKit
//import WebKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var imageTopView: UIImageView!
    @IBOutlet weak var imageBottomView: UIImageView!
    
    @IBAction func getTopPhoto(_ sender: Any) {
        imageTopView.load(url: URL(string: "https://picsum.photos/400/300")!)
    }
    
    @IBAction func takePicture(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let possibleImage = info[.originalImage] as? UIImage {
            imageBottomView.image = possibleImage
        } else {
            return
        }
        dismiss(animated: true, completion: nil)
        
    }
    
}

private extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
