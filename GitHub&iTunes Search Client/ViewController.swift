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
    var cellReuseIdentifiers = ["RightIconResultCell", "LeftIconResultCell"]
    
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
            let reuseID = indexPath.row % 2 == 0 ? cellReuseIdentifiers[0] : cellReuseIdentifiers[1]
            if let cell = searchResultsTableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as? RightIconResultCell {
                cell.configureCell(iTunesItem: itunesItems[indexPath.row])
                return cell
            } else if let cell = searchResultsTableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as? LeftIconResultCell {
                cell.configureCell(iTunesItem: itunesItems[indexPath.row])
                return cell
            }
        case 1:
            let reuseID = indexPath.row % 2 == 0 ? cellReuseIdentifiers[1] : cellReuseIdentifiers[0]
            if let cell = searchResultsTableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as? RightIconResultCell {
                cell.configureCell(gitHubUser: gitHubUsers[indexPath.row])
                return cell
            } else if let cell = searchResultsTableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as? LeftIconResultCell {
                cell.configureCell(gitHubUser: gitHubUsers[indexPath.row])
                return cell
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

