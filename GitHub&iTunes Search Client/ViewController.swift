//
//  ViewController.swift
//  GitHub&iTunes Search Client
//
//  Created by Sasha Evtushenko on 6/29/20.
//  Copyright © 2020 Sasha Evtushenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var gitHubUsers = [GitHubUser]()
    var itunesItems = [iTunesItem]()
    
    @IBOutlet var searchBarTextField: UITextField!
    @IBOutlet var searchResultsTableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarTextField.delegate = self
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            search(searchURL: ITUNES_SEARCH_URL, searchQuery: "Jack+Johnson")
        case 1:
            search(searchURL: GITHUB_USERS_SEARCH_URL, searchQuery: "Tom")
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itunesItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchResultsTableView.dequeueReusableCell(withIdentifier: "iTunesRightIconResultCell", for: indexPath) as! iTunesRightIconResultCell
        cell.artistNameLabel.text = itunesItems[indexPath.row].artistName
        cell.trackNameLabel.text = itunesItems[indexPath.row].trackName
        if let imageUrl = URL(string: itunesItems[indexPath.row].artworkUrl60) {
            DispatchQueue.global().async {
               if let data = try? Data(contentsOf: imageUrl)
               {
                 DispatchQueue.main.async {
                    cell.artwork60.image = UIImage(data: data)
                 }
               }
            }
        }
        return cell
    }

    func search(searchURL: String, searchQuery: String) {
        guard let jsonUrl = URL(string: searchURL + searchQuery) else { return }
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
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBarTextField.endEditing(true)
        return false
    }
}

