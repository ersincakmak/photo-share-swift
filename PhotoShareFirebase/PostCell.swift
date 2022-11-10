//
//  PostCell.swift
//  PhotoShareFirebase
//
//  Created by Ersin ÇAKMAK on 10.11.2022.
//

import UIKit
import Kingfisher

class PostCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postOwner: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    
    var selectedPost: Post?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initData(){
        guard let selectedPost = selectedPost else { return }
        let url = URL(string: selectedPost.imageURL)
        postImage.kf.setImage(with: url)
        postOwner.text = selectedPost.owner
        postTitle.text = selectedPost.title
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
