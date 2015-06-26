//
//  FooterView.swift
//  Dredr
//
//  Created by Zhu Shengqi on 6/8/15.
//  Copyright (c) 2015 DSoftware. All rights reserved.
//

import UIKit


class FooterView: UIView {

    @IBOutlet var view: UIView!
    
    @IBOutlet weak var lastEntryTitleView: UILabel!
    @IBOutlet weak var feedTitleView: UILabel!
    @IBOutlet weak var arrowView: ArrowView!
    
    weak var entry: Item! {
        didSet {
            if entry != nil {
                lastEntryTitleView.text = entry.title
                feedTitleView.text = entry.channel.feedTitle
            }
        }
    }
    
    func loadNib() {
        NSBundle.mainBundle().loadNibNamed("FooterView", owner: self, options: nil)
        
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
