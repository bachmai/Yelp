//
//  DetailsViewController.swift
//  Yelp
//
//  Created by Bach Mai on 3/24/22.
//

import UIKit
import SDWebImage

class DetailsViewController: UIViewController {
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    var businessID: String?
    private var photos: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        getBusinessDetails()
    }
    

    // MARK: Network calls
    private func getBusinessDetails() {
        guard let businessID = businessID else {
            return
        }
        YelpManager.getBusinessDetails(bizID: businessID) { businessDetails, errorMsg in
            DispatchQueue.main.async { [weak self] in
                if let errorMsg = errorMsg {
                    self?.showAlert(title: "Business Details", message: errorMsg)
                } else if let businessDetails = businessDetails {
                    self?.setupUI(with: businessDetails)
                } else {
                    self?.showAlert(title: "Business Details", message: "Unknown error")
                }
            }
        }
    }
    
    private func downloadPhotos(photoUrls: [String]) {
        DispatchQueue.global().async {
            self.photos.removeAll()
            
            for url in photoUrls {
                guard let url = URL(string: url) else {
                    continue
                }
                
                let group = DispatchGroup()
                
                group.enter()
                URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
                    if let error = error {
                        print(error)
                    } else if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async() {
                            self.photos.append(image)
                            self.photosCollectionView.reloadData()
                        }
                    }
                    group.leave()
                }).resume()
                
                group.wait()
            }
        }
    }
    
    private func setupUI(with bizDetails: BusinessDetailsResponse) {
        businessNameLabel.text = bizDetails.name
        addressLabel.text = bizDetails.location.display_address?.joined(separator: "\n")
        phoneNumberLabel.text = bizDetails.display_phone
        ratingLabel.text = "Rating: \(bizDetails.rating)/5"
        if let photoUrls = bizDetails.photos {
            downloadPhotos(photoUrls: photoUrls)
        }
        
    }

}

extension DetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCollectionViewCell
        cell.mainImageView.image = photos[indexPath.row]
        return cell
    }
    
    
}


