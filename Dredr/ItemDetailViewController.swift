//
//  ItemDetailViewController.swift
//  Dredr
//
//  Created by Zhu Shengqi on 6/5/15.
//  Copyright (c) 2015 DSoftware. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var articleView: ArticleView!
    @IBOutlet weak var scrollMainView: UIView!
    
    @IBOutlet weak var toolbarView: UIToolbar!
    
    @IBOutlet weak var starredButton: UIBarButtonItem!
    @IBOutlet weak var unreadButton: UIBarButtonItem!
    @IBOutlet weak var originalPageButton: UIBarButtonItem!
    
    
    var headerView: HeaderView!
    var footerView: FooterView!
    
    var headerConstraints: [NSLayoutConstraint] = []
    var footerConstraints: [NSLayoutConstraint] = []
    var articleConstraints: [NSLayoutConstraint] = []
    
    var entries: [Item]!
    var currentIndex: Int!
    
    var dmBoard = DMBoard.sharedBoard
    
    deinit {
        scrollView.delegate = nil
    }
    
    @IBAction func toggleStarred(sender: AnyObject) {
        if entries[currentIndex].isStarred {
            dmBoard.currentAccount!.makeItemUnstarred(entries[currentIndex])
            setStarredButtonStarred(false, animated: true)
        } else {
            dmBoard.currentAccount!.makeItemStarred(entries[currentIndex])
            setStarredButtonStarred(true, animated: true)
        }
    }
    
    func setStarredButtonStarred(starred: Bool, animated: Bool) {
        let setting: () -> Void = {
            [unowned self] in
            if starred {
                self.starredButton.image = UIImage(named: "starred")
                self.starredButton.tintColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
            } else {
                self.starredButton.image = UIImage(named: "unstarred")
                self.starredButton.tintColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
            }
        }
        
        if animated {
            UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                setting()
            }, completion: nil)
        } else {
           setting()
        }
    }
    
    @IBAction func toggleUnRead(sender: AnyObject) {
        if entries[currentIndex].isRead {
            dmBoard.currentAccount!.makeItemUnread(entries[currentIndex])
            setUnreadButtonUnread(true, animated: true)
        } else {
            dmBoard.currentAccount!.makeItemRead(entries[currentIndex])
            setUnreadButtonUnread(false, animated: true)
        }
    }
    
    func setUnreadButtonUnread(unread: Bool, animated: Bool) {
        let setting: () -> Void = {
            [unowned self] in
            if unread {
                self.unreadButton.tintColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
            } else {
                self.unreadButton.tintColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
            }
        }
        
        if animated {
            UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                setting()
            }, completion: nil)
        } else {
            setting()
        }
    }

    @IBAction func loadOriginalPage(sender: AnyObject) {
        performSegueWithIdentifier(LoadPageIdentifier, sender: self)
    }
    

    
    func config() {
        dmBoard.currentItem = entries[currentIndex]
        
        if !entries[currentIndex].isRead {
            dmBoard.currentAccount!.makeItemRead(entries[currentIndex])
            setUnreadButtonUnread(false, animated: false)
        }
        
        setStarredButtonStarred(entries[currentIndex].isStarred, animated: false)
    }
    
    let headerHeight: CGFloat = 100

    func updateUI() {
        articleView.entry = entries[currentIndex]
        
        addHeaderView(headerHeight)
        addFooterView(headerHeight)
    }

    func addHeaderView(height: CGFloat) {
        if currentIndex > 0 {
            
            headerView = HeaderView(frame: CGRectMake(0, -height, scrollMainView.bounds.width, height))
            headerView.entry = entries[currentIndex - 1]
            headerView.setTranslatesAutoresizingMaskIntoConstraints(false)

            
            scrollMainView.addSubview(headerView)
            
            headerConstraints = []
            headerConstraints.append(NSLayoutConstraint(item: headerView, attribute: .Leading, relatedBy: .Equal, toItem: scrollMainView, attribute: .Leading, multiplier: 1, constant: 0))
            headerConstraints.append(NSLayoutConstraint(item: headerView, attribute: .Trailing, relatedBy: .Equal, toItem: scrollMainView, attribute: .Trailing, multiplier: 1, constant: 0))
            headerConstraints.append(NSLayoutConstraint(item: headerView, attribute: .Bottom, relatedBy: .Equal, toItem: articleView, attribute: .Top, multiplier: 1, constant: 0))
            headerConstraints.append(NSLayoutConstraint(item: headerView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: height))
            
            scrollMainView.addConstraints(headerConstraints)
        }
    }
    
    
    func addFooterView(height: CGFloat) {
        if currentIndex < entries.count - 1 {
            footerView = FooterView(frame: CGRectMake(0, scrollMainView.bounds.height, scrollMainView.bounds.width, height))
            footerView.entry = entries[currentIndex + 1]
            footerView.setTranslatesAutoresizingMaskIntoConstraints(false)

            scrollMainView.addSubview(footerView)
            
            footerConstraints = []
            footerConstraints.append(NSLayoutConstraint(item: footerView, attribute: .Leading, relatedBy: .Equal, toItem: scrollMainView, attribute: .Leading, multiplier: 1, constant: 0))
            footerConstraints.append(NSLayoutConstraint(item: footerView, attribute: .Trailing, relatedBy: .Equal, toItem: scrollMainView, attribute: .Trailing, multiplier: 1, constant: 0))
            footerConstraints.append(NSLayoutConstraint(item: footerView, attribute: .Top, relatedBy: .Equal, toItem: scrollMainView, attribute: .Bottom, multiplier: 1, constant: 0))
            footerConstraints.append(NSLayoutConstraint(item: footerView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: height))
            
            scrollMainView.addConstraints(footerConstraints)
        }
    }
    
    func loadNextEntry() {
        let nextView = ArticleView(frame: CGRectMake(0, headerView.frame.origin.y - view.bounds.height, view.bounds.width, view.bounds.height))
        
        nextView.entry = headerView.entry
        scrollMainView.addSubview(nextView)
        
        UIView.animateWithDuration(0.2, animations: {
            self.headerView.frame = CGRectMake(0, self.view.bounds.height, self.headerView.frame.width, self.headerView.frame.height)
            
            self.articleView.frame = CGRectMake(0, self.view.bounds.height + self.headerView.frame.height, self.articleView.frame.width, self.articleView.frame.height)
            self.articleView.removeFromSuperview()
            
            nextView.frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height)
            self.articleView = nextView
            }, completion: {
                (finished) in
                self.headerView?.removeFromSuperview()
                self.footerView?.removeFromSuperview()
                
                self.headerView = nil
                self.footerView = nil
                
                self.currentIndex!--
                
                self.addHeaderView(self.headerHeight)
                self.addFooterView(self.headerHeight)
                
                self.config()
        })
    }
    
    func loadPreviousEntry() {
        let previousView = ArticleView(frame: CGRectMake(0, footerView.frame.origin.y + footerView.frame.height, view.bounds.width, view.bounds.height))
        
        
        previousView.entry = footerView.entry
        scrollMainView.addSubview(previousView)
        
        
        UIView.animateWithDuration(0.2, animations: {
            self.footerView.frame = CGRectMake(0, -self.footerView.frame.height, self.footerView.frame.width, self.footerView.frame.height)

            self.articleView.frame = CGRectMake(0, -(self.footerView.frame.height + self.articleView.frame.height), self.articleView.frame.width, self.articleView.frame.height)
            self.articleView.removeFromSuperview()

            previousView.frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height)
            self.articleView = previousView
        }, completion: {
            (finished) in


            self.headerView?.removeFromSuperview()
            self.footerView?.removeFromSuperview()
            
            self.headerView = nil
            self.footerView = nil
            
            self.currentIndex!++
            
            self.addHeaderView(self.headerHeight)
            self.addFooterView(self.headerHeight)
            
            self.config()
        })
    }
    
    func addStatusBarView() {
        let statusbarFrame = UIApplication.sharedApplication().statusBarFrame
        let statusbarView = UIView(frame: CGRectMake(0, 0, statusbarFrame.width, statusbarFrame.height))
        statusbarView.backgroundColor = UIColor(red: 240.0/255, green: 240.0/255, blue: 240.0/255, alpha: 1.0)
        view.addSubview(statusbarView)
    }
    
    // MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        addStatusBarView()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        config()

        scrollView.setContentOffset(CGPointZero, animated: false)
        
        // these attributes should be reset in neighbour viewcontroller's viewDidLoad()
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
                
        // reset frames which can animate
        navigationController?.navigationBar.frame.origin.y = UIApplication.sharedApplication().statusBarFrame.height
        toolbarView.frame.origin.y = view.bounds.height - toolbarView.frame.height
    }
    

    // MARK: - Navigation
    
    let LoadPageIdentifier = "loadEntryLink"
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == LoadPageIdentifier {
            if let linkVC = segue.destinationViewController as? LinkViewController {
                linkVC.entry = entries[currentIndex]
                return
            }
        }
    }
}

extension ItemDetailViewController: UIScrollViewDelegate
{
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        
        // adjust navigation bar
        if scrollView.contentOffset.y <= 0 {
            navigationController?.navigationBar.frame.origin.y = scrollView.contentOffset.y + statusBarHeight
        } else {
            navigationController?.navigationBar.frame.origin.y = -scrollView.contentOffset.y + statusBarHeight
        }
        
        // adjust toolbar
        if scrollView.contentOffset.y >= scrollMainView.frame.height - scrollView.frame.height {
            toolbarView.frame.origin.y = view.bounds.height - toolbarView.frame.height + scrollView.contentOffset.y - (scrollMainView.frame.height - scrollView.frame.height)
        } else {
            toolbarView.frame.origin.y = view.bounds.height - toolbarView.frame.height
        }
        
        
        // adjust arrowView in headerView and bottomView
        let leverage: CGFloat = 2.5
        headerView?.arrowView.pullCoefficient = (-scrollView.contentOffset.y - 50.0) / headerView.frame.height * leverage
        footerView?.arrowView.pullCoefficient = (scrollView.contentOffset.y - 30.0 - (scrollMainView.frame.height - scrollView.frame.height)) / footerView.frame.height * leverage
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if headerView != nil {
            if headerView.arrowView.pullCoefficient == 1.0 {
                loadNextEntry()
                return
            }
        }
        
        if footerView != nil {
            if footerView.arrowView.pullCoefficient == 1.0 {
                loadPreviousEntry()
                return
            }
        }
    }
}

