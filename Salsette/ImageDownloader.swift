//
//  ImageDownloader.swift
//  Salsette
//
//  Created by Marton Kerekes on 03/04/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import Foundation
import UIKit

class ImageDownloader {
    
    private init (){}
    
    static let shared = ImageDownloader()
    
    private var failedImage: UIImage {
        get {
            return UIImage(named: "party")!
        }
    }
    func downloadImage(for urlString: String?, completion:@escaping ((UIImage)->Void)) {
        guard let string = urlString, let url = URL(string: string) else {
            completion(UIImage())
            return
        }
        URLSession.shared.dataTask(with: url) { (imageData, urlResponse, error) in
            guard let _ = error else {
                DispatchQueue.main.async {
                    completion(self.parse(imageData: imageData))
                }
                return
            }
            completion(self.failedImage)
        }.resume()
    }
    
    private func parse(imageData: Data?) -> UIImage {
        guard let data = imageData else {
            return failedImage
        }
        return UIImage(data: data)!
    }
}
