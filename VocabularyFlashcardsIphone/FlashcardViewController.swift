//
//  FlashcardViewController.swift
//  VocabularyFlashcardsIphone
//
//  Created by Evan Sitzes on 9/29/16.
//  Copyright © 2016 Evan Sitzes. All rights reserved.
//

import UIKit

class FlashcardViewController: UIViewController {

    var languageCategory:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        print("Passed category: ", languageCategory)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
