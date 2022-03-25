//
//  UIImageViewExt.swift
//  Yelp
//
//  Created by Bach Mai on 3/25/22.
//

import UIKit

extension UIImageView {
    func setImage(with url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let uiImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = uiImage
                    }
                }
            }
        }
    }
}
