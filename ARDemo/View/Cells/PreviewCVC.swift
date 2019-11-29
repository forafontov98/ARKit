//
//  PreviewCVC.swift
//  ARDemo
//
//  Created by Владислав Форафонтов on 27/11/2019.
//  Copyright © 2019 Владислав Форафонтов. All rights reserved.
//

import UIKit

protocol PreviewCVCProtocol {
    func config(image: UIImage)
    func startLoading()
    func stopLoading()
}

@IBDesignable
class PreviewCVC: UICollectionViewCell {
    
    @IBInspectable var cornerRadius: CGFloat = 10.0
    
    @IBOutlet weak var preview: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }
    
}

extension PreviewCVC: PreviewCVCProtocol {
    func config(image: UIImage) {
        preview.image = image
    }
    
    func startLoading() {
        spinner.startAnimating()
    }
    
    func stopLoading() {
        spinner.stopAnimating()
    }
}
