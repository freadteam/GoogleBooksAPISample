//
//  DetailViewController.swift
//  GoogleBooksSample
//
//  Created by Ryo Endo on 2018/07/15.
//  Copyright © 2018年 Ryo Endo. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var passedBook: Book!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var urlTextView: UITextView!
    @IBOutlet weak var detailTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = passedBook.title
        authorLabel.text = passedBook.authors?.first
        categoryLabel.text = passedBook.categories?.first
        urlTextView.text = passedBook.previewLinkURL
        detailTextView.text = passedBook.detailText
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
