//
//  ViewController.swift
//  GoogleBooksSample
//
//  Created by Ryo Endo on 2018/07/14.
//  Copyright © 2018年 Ryo Endo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var books = [Book]()
    var selectedBook: Book?
    var searchBar: UISearchBar!
    let stringText = "あいうえおかきくけこさしすせそたちつてとなにぬねのはほふえほまみむめもやゆよらりるれろわをん"
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        setSearchBar()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //searchBarを設置
    func setSearchBar() {
        // NavigationBarにSearchBarをセット
        if let navigationBarFrame = self.navigationController?.navigationBar.bounds {
            let searchBar: UISearchBar = UISearchBar(frame: navigationBarFrame)
            searchBar.delegate = self
            searchBar.placeholder = "書籍を検索"
            searchBar.autocapitalizationType = UITextAutocapitalizationType.none
            navigationItem.titleView = searchBar
            navigationItem.titleView?.frame = searchBar.frame
            self.searchBar = searchBar
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadBooks(bookTitle: nil)
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //入力した文字を使う
       loadBooks(bookTitle: searchBar.text)
        
        //ランダムに発生させた文字（今回は２文字）を使う
//        let searchText = makeSearchWord(length: 2)
//        print(searchText)
//        loadBooks(bookTitle: searchText)
    }
    
    //ランダムな検索ワードを生成
    func makeSearchWord(length: Int) -> String {
        let textLength = (stringText as NSString).length
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(UInt32(textLength))
            var nextChar = (stringText as NSString).character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = books[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedBook = books[indexPath.row]
        performSegue(withIdentifier: "toDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailViewCOntroller = segue.destination as! DetailViewController
        detailViewCOntroller.passedBook = selectedBook
    }
    
    func loadBooks(bookTitle: String?) {
        
        guard let bookTitle = bookTitle else {return}
        
        //googlebooksapiに接続するURL
        let path = "https://www.googleapis.com/books/v1/volumes?q=\(bookTitle)" //+ "intitle"
        /*
         intitle:    書籍のタイトル
         inauthor:    書籍の著者
         inpublisher:    書籍の出版社
         subject:    Volumeの中のCategoryがどうのこうの。よく調べてない。上記ReferenceのURLのVolumeについて学ぶところからと思われる。
         isbn:    International Standard Book Number
         日本で主に使われるISBN (Wikipedia)
         
         lccn:    Library of Congress Control Number
         アメリカ議会図書館管理番号 (Wikipedia)
         
         oclc:    Online Computer Library Center number
         世界で最も大規模な書誌ユーティリティだそうで (Wikipedia)
         
         */
        
        // include Japanese日本語でも検索できるようにする。
        let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let searchPath = encodedPath else {
            print("無効な検索ワードが入力されました。")
            return
        }
        Alamofire.request(searchPath, method: .get).responseJSON { response in
            guard let object = response.result.value else {return}
            let json = JSON(object)
            self.books.removeAll()
            json["items"].forEach({ (_, json) in
                //self.articles.append(article as! [String])
                
                let title = json["volumeInfo"]["title"].string
                let book = Book(title: title!)
                
                let authors = json["volumeInfo"]["authors"].arrayObject
                if authors != nil {
                    book.authors = authors as? [String]
                }
                let summary = json["volumeInfo"]["description"].string
                if summary != nil {
                    book.summary = summary
                }
                let categories = json["volumeInfo"]["categories"].arrayObject
                if categories != nil {
                    book.categories = categories as? [String]
                }
                let previewLinkURL = json["volumeInfo"]["previewLink"].string
                if previewLinkURL != nil {
                    book.previewLinkURL = previewLinkURL
                }
                let detailText = json["volumeInfo"]["description"].string
                if detailText != nil {
                    book.detailText = detailText
                }
                
                self.books.append(book)
            })
            self.tableView.reloadData()
        }
        
    }
    
    
}
