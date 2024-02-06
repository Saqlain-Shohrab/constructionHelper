//
//  Helper.swift
//  Construction Helper
//
//  Created by Saqlain Shohrab on 04/02/2024.
//

import UIKit
import Kingfisher

class Helper {
    
    static func loadImageIntoView(imageUrl imageUrlStr: String?, imageView: UIImageView?) {
        DispatchQueue.main.async {
            
            
            if imageUrlStr == nil || imageView == nil {
                return
            }
            
            imageView?.image = nil
            
            if let imageUrl = URL(string: imageUrlStr!) {
                
                imageView?.kf.setImage(with: imageUrl)
            } else {
                
                print("Image failed to load for url \(imageUrlStr!).")
            }
        }
    }
    
    static func fileExists(atPath path: String) -> Bool {
        
        if let url = URL(string: path) {
            let fileManager = FileManager.default
            let exists = fileManager.fileExists(atPath: url.path)
            return exists
        } else {
            return false
        }
    }
}
