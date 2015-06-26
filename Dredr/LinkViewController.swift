//
//  LinkViewController.swift
//  Dredr
//
//  Created by Zhu Shengqi on 6/12/15.
//  Copyright (c) 2015 DSoftware. All rights reserved.
//

import UIKit

class LinkViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var faviconView: UIImageView!
    @IBOutlet weak var feedTitleLabel: UILabel!
    
    
    var entry: Item!
    
    var webViewLoads = 0
    var progressFinished = false
    var timer: NSTimer!
    
    func config() {
        navigationController?.navigationBar.shadowImage = nil // shadow for navigationbar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default) // make navigationbar totally translucent
        
        webView.delegate = self
                
        if entry != nil {
            feedTitleLabel.text = entry.channel.feedTitle
            if entry.channel.favicon != nil {
                faviconView.image = entry.channel.favicon
                faviconView.alpha = 1.0
            }
        }
    }
    
    func refreshPage() {
        if entry != nil {
            let url = NSURL(string: entry.link!)
            
            webViewLoads = 0
            progressView.progress = 0.0
            progressView.hidden = false
            progressFinished = false
            
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01667, target: self, selector: "timerCallBack", userInfo: nil, repeats: true)
            
            webView.loadRequest(NSURLRequest(URL: url!))
        }
    }
    
    func webviewFinishLoading() {
        progressFinished = true
    }
    
    func timerCallBack() {
        if progressFinished {
            if progressView.progress >= 1 {
                progressView.hidden = true
                timer.invalidate()
            } else {
                progressView.progress += 0.1
            }
        } else {
            progressView.progress += 0.003
            if progressView.progress >= 0.95 {
                progressView.progress = 0.95
            }
        }
    }
    
    // MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        refreshPage()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(animated: Bool) {
        webView.stopLoading()
    }
}

extension LinkViewController: UIWebViewDelegate
{
    func webViewDidStartLoad(webView: UIWebView) {
        webViewLoads++
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        println(webViewLoads)
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        webViewLoads--
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        println(webViewLoads)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        webViewLoads--
        let delayInSeconds = 0.5
        let delayToPerformFinish = dispatch_time(DISPATCH_TIME_NOW, Int64(round(delayInSeconds * Double(NSEC_PER_SEC))))
        dispatch_after(delayToPerformFinish, dispatch_get_main_queue()) {
            () -> Void in
            self.webViewFinishLoadingFrame()
        }
        println(webViewLoads)
    }
    
    func webViewFinishLoadingFrame() {
        if webViewLoads == 0 {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            webviewFinishLoading()
        }
    }
}
