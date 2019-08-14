//
//  SecondViewController.swift
//  Notes
//
//  Created by Maksim Torburg on 06/08/2019.
//  Copyright © 2019 Maksim Torburg. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBAction func showRateTab(_ sender: Any) {
        tabBarController?.selectedIndex = 1
    }
    @IBAction func backToPrevious(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Second"

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
