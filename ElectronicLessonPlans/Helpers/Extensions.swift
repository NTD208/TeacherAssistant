//
//  Extensions.swift
//  ElectronicLessonPlans
//
//  Created by Chu Du on 12/08/2021.
//

import UIKit
import Firebase

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func loadImageUsingCacheWithUrlString(urlString: String) {
        
        self.image = nil
        
        if let cacheImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cacheImage
            return
        }
        
        let url = NSURL(string: urlString)
        URLSession.shared.dataTask(with: url! as URL) { data, response, error in
            if error != nil {
                return
            }
            
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
                
            }
        }.resume()
    }
}
