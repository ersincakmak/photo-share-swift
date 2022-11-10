//
//  FeedViewController.swift
//  PhotoShareFirebase
//
//  Created by Ersin ÇAKMAK on 10.11.2022.
//

import UIKit
import FirebaseFirestore

class FeedViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchPosts()
    }
    
    private func fetchPosts(){
        let firestore = Firestore.firestore()
        firestore.collection("posts").addSnapshotListener { snapshot, error in
            if error != nil {
                print("There was an error occurred while fetching posts")
            } else {
                guard let snapshot = snapshot, !snapshot.isEmpty else { return }
                var emptyArray = [Post]()
                for document in snapshot.documents {
                    guard
                        let imageURL = document.get("image") as? String,
                        let owner = document.get("owner") as? String,
                        let title = document.get("title") as? String
                    else { return }
                    emptyArray.append(Post(imageURL: imageURL, owner: owner, title: title))
                }
                self.posts = emptyArray
                self.tableView.reloadData()
            }
        }
    }
}

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostCell else { return UITableViewCell() }
        cell.selectedPost = posts[indexPath.row]
        cell.initData()
        cell.selectionStyle = .none
        return cell
    }
}
