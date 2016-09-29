//
//  LevelSelectionViewController.swift
//  VocabularyFlashcardsIphone
//
//  Created by Evan Sitzes on 9/29/16.
//  Copyright © 2016 Evan Sitzes. All rights reserved.
//

import UIKit

class LevelSelectionViewController: UIViewController {

    var categories: NSMutableArray = []
    var globalY = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataRequest()
        print("----------------SECOND SCREEN----------------")
    }
    
    func createButton(category: String) {
        print("Button time!!")
        let btn: UIButton = UIButton(frame: CGRect(x: 100, y: globalY, width: 100, height: 60))
        btn.backgroundColor = UIColor.orange
        btn.setTitle(category, for: UIControlState.normal)
        btn.addTarget(self, action: #selector(LevelSelectionViewController.buttonAction(_:)), for: UIControlEvents.touchUpInside)
//        btn.tag = 1               // change tag property
        self.view.addSubview(btn) // add to view as subview
        globalY += 70
    }

    func buttonAction(_ button: UIButton) {
        print("Button tapped")
//        self.performSegue(withIdentifier: "FlashcardViewController", sender:self)
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: FlashcardViewController = storyboard.instantiateViewController(withIdentifier: "flashcardView") as! FlashcardViewController
        
        vc.languageCategory = button.titleLabel!.text!
        self.present(vc, animated: true, completion: nil)
    }
    
    func createButtons() {
        for i in 0..<categories.count {
            print("Cat:", categories[i])
            createButton(category: categories[i] as! String)
        }
    }
    
    func dataRequest() {
        let session = URLSession.shared
        let categoriesRequestUrl = URL(string: "http://vocabularyterms.herokuapp.com/korean/categories")
        var request = URLRequest(url:categoriesRequestUrl!)
        request.httpMethod = "GET"
        
        // The data task retrieves the data.
        let client = session.dataTask(with: request as URLRequest) {
            data, response, error in
            if let networkError = error {
                // Case 1: Error
                // An error occurred while trying to get data from the server.
                print("ERROR OCCURED WITH API REQUEST")
                print(networkError)
            
            }
            else {
                // Case 2: Success
                // We got a response from the server!
                do {
                    // Try to convert that data into a Swift dictionary
                    let weatherData = try JSONSerialization.jsonObject(
                        with: data!,
                        options: .mutableContainers) as! NSMutableArray
                    
                    print("Data: ")
                    self.categories = weatherData
                    self.createButtons()
                }
                catch let jsonError as NSError {
                    // An error occurred while trying to convert the data into a Swift dictionary.
                    print("CRAPPY RANDOM JSON ERROR")
                    print(jsonError)
                }
            }
        }
        
        // The data task is set up...launch it!
        client.resume()
        
    }
}
