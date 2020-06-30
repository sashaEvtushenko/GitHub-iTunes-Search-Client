//
//  ViewController.swift
//  GitHub&iTunes Search Client
//
//  Created by Sasha Evtushenko on 6/29/20.
//  Copyright © 2020 Sasha Evtushenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var gitHubUsers = [GitHubUser]()
    var itunesItems = [iTunesItem]()
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchResultsTableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        searchBar.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return itunesItems.count
        case 1:
            return gitHubUsers.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchResultsTableView.dequeueReusableCell(withIdentifier: "RightIconResultCell", for: indexPath) as! RightIconResultCell
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            cell.leftTopLabel.text = itunesItems[indexPath.row].artistName
            cell.leftBottomLabel.text = itunesItems[indexPath.row].trackName
            if let imageUrl = URL(string: itunesItems[indexPath.row].artworkUrl60) {
                DispatchQueue.global().async {
                   if let data = try? Data(contentsOf: imageUrl)
                   {
                     DispatchQueue.main.async {
                        cell.icon.image = UIImage(data: data)
                     }
                   }
                }
            }
        case 1:
            cell.leftTopLabel.text = gitHubUsers[indexPath.row].login
            cell.leftBottomLabel.text = gitHubUsers[indexPath.row].html_url
            if let imageUrl = URL(string: gitHubUsers[indexPath.row].avatar_url) {
                DispatchQueue.global().async {
                   if let data = try? Data(contentsOf: imageUrl)
                   {
                     DispatchQueue.main.async {
                        cell.icon.image = UIImage(data: data)
                     }
                   }
                }
            }
        default:
            break
        }
        return cell
    }

    func search(searchURL: String, searchQuery: String) {
        guard let jsonUrl = URL(string: searchURL + searchQuery) else { return }
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            URLSession.shared.dataTask(with: jsonUrl) { data, response, error in
                guard let data = data else { return }
                
                do {
                    let jsonData = try JSONDecoder().decode(iTunesItems.self, from: data)
                    self.itunesItems = jsonData.results
                    print(self.itunesItems)
                    DispatchQueue.main.async {
                        self.searchResultsTableView.reloadData()
                    }
                } catch let jsonError {
                    print("Error serializing JSON", jsonError)
                }
            }.resume()
        case 1:
            URLSession.shared.dataTask(with: jsonUrl) { data, response, error in
                guard let data = data else { return }
                do {
                    let jsonData = try JSONDecoder().decode(GitHubUsers.self, from: data)
                    self.gitHubUsers = jsonData.items
                    print(self.gitHubUsers)
                    DispatchQueue.main.async {
                        self.searchResultsTableView.reloadData()
                    }
                } catch let jsonError {
                    print("Error serializing JSON", jsonError)
                }
            }.resume()
        default:
            break
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchBarString = searchBar.text
        guard let searchString = searchBarString?.replacingOccurrences(of: " ", with: "+") else { return }
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            search(searchURL: ITUNES_SEARCH_URL, searchQuery: searchString)
        case 1:
            search(searchURL: GITHUB_USERS_SEARCH_URL, searchQuery: searchString)
        default:
            break
        }
        
        searchBar.endEditing(true)
    }
    
}

