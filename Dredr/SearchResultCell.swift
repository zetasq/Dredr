//
//  SearchResultCell.swift
//  Dredr
//
//  Created by Zhu Shengqi on 6/16/15.
//  Copyright (c) 2015 DSoftware. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {

    @IBOutlet weak var feedTitleLabel: UILabel!
    @IBOutlet weak var feedUrlLabel: UILabel!
    
    @IBOutlet weak var checkmarkView: UIImageView!
    
    var searchResult: FeedlyResult! {
        didSet {
            if searchResult != nil {
                feedTitleLabel.text = searchResult.feedTitle
                feedUrlLabel.text = searchResult.feedUrl
            }
        }
    }
    
    func showCheckmark() {
        checkmarkView.hidden = false
    }
    
    func hideCheckmark() {
        checkmarkView.hidden = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
