//
//  HomeViewController.swift
//  Yelp
//
//  Created by Bach Mai on 3/24/22.
//

import UIKit

class HomeViewController: UIViewController {
    internal enum SortMode : String {
        case AtoZ = "A->Z"
        case ZtoA = "Z->A"
        case ratingAscending = "Rating Low -> High"
        case ratingDescending = "Rating High -> Low"
    }
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sortButton: UIButton!
    
    var searchTerm = "Pho"
    var sortMode = SortMode.AtoZ
    var businessList: [BusinessDetailObj] = []
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        // hides the keyboard when collection view is being used
        collectionView.keyboardDismissMode = .onDrag
        // add refresh control to the collection view
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        // sort button
        sortButton.menu = UIMenu(title: "Sort by", options: .singleSelection, children: [
            UIAction(title: SortMode.AtoZ.rawValue, state: .on, handler: sortButtonHandler),
            UIAction(title: SortMode.ZtoA.rawValue, handler: sortButtonHandler),
            UIAction(title: SortMode.ratingAscending.rawValue, handler: sortButtonHandler),
            UIAction(title: SortMode.ratingDescending.rawValue, handler: sortButtonHandler)])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBusiness(term: searchTerm)
        
    }
    
    @objc private func reloadData() {
        searchBusiness(term: searchTerm)
    }
    
    // MARK: Network calls
    private func searchBusiness(term: String) {
        YelpManager.shared.searchBusiness(term: term) { businessList, errorMsg in
            DispatchQueue.main.async { [weak self] in
                self?.refreshControl.endRefreshing()
                if let errorMsg = errorMsg {
                    self?.showAlert(title: "Search Business", message: errorMsg)
                } else if let businessList = businessList {
                    self?.businessList = businessList
                    self?.sortBusinessListBy(self?.sortMode ?? SortMode.AtoZ)
                    self?.collectionView.reloadData()
                } else {
                    self?.showAlert(title: "Search Business", message: "Unknown error")
                }
            }
        }
    }
    
    // MARK: Private funcs
    private func sortBusinessListBy(_ mode: SortMode) {
        sortMode = mode
        switch mode {
        case .AtoZ:
            businessList = businessList.sorted(by: {$0.name < $1.name})
        case .ZtoA:
            businessList = businessList.sorted(by: {$0.name > $1.name})
        case .ratingAscending:
            businessList = businessList.sorted(by: {$0.rating < $1.rating})
        case .ratingDescending:
            businessList = businessList.sorted(by: {$0.rating > $1.rating})
        }
    }

    private func sortButtonHandler(_ action: UIAction) {
        if let title = sortButton.menu?.selectedElements.first?.title {
            switch title {
            case SortMode.AtoZ.rawValue:
                sortBusinessListBy(.AtoZ)
            case SortMode.ZtoA.rawValue:
                sortBusinessListBy(.ZtoA)
            case SortMode.ratingDescending.rawValue:
                sortBusinessListBy(.ratingDescending)
            case SortMode.ratingAscending.rawValue:
                sortBusinessListBy(.ratingAscending)
            default:
                return
            }
            collectionView.reloadData()
        }
    }
}

// MARK: UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return businessList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "businessCell", for: indexPath) as! BusinessCollectionViewCell
        cell.businessName.text = businessList[indexPath.row].name
        cell.rating.text = "Rating: \(businessList[indexPath.row].rating)/5"
        if let imageUrlstring = businessList[indexPath.row].image_url,
           let imageUrl = URL(string: imageUrlstring) {
//            cell.mainImageView.sd_setImage(with: imageUrl, completed: nil)
            cell.mainImageView.setImage(with: imageUrl)
        } else {
            cell.mainImageView.image = UIImage(named: "product-placeholder")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        vc.businessID = businessList[indexPath.row].id
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let term = searchBar.text {
            searchTerm = term
        }
        reloadData()
        searchBar.endEditing(true)
    }
}
