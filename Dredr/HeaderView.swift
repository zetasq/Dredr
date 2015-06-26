//
//  HeaderView.swift
//  Dredr
//
//  Created by Zhu Shengqi on 6/8/15.
//  Copyright (c) 2015 DSoftware. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    @IBOutlet var view: UIView!
    

    @IBOutlet weak var nextEntryTitleView: UILabel!
    @IBOutlet weak var feedTitleView: UILabel!
    @IBOutlet weak var arrowView: ArrowView!
    
    weak var entry: Item! {
        didSet {
            if entry != nil {
                nextEntryTitleView.text = entry.title
                feedTitleView.text = entry.channel.feedTitle
            }
        }
    }
    
    func loadNib() {
        NSBundle.mainBundle().loadNibNamed("HeaderView", owner: self, options: nil)
        
        addSubview(view)
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: .allZeros, metrics: nil, views: ["view": view]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: .allZeros, metrics: nil, views: ["view": view]))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
}
