//
//  SettingsViewController.swift
//  Notes
//
//  Created by Maksim Torburg on 19/11/2019.
//  Copyright © 2019 Maksim Torburg. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBAction func showDeletedNotes(_ sender: UIButton) {
        let deletedNotesViewController = DeletedNotesViewController()
        navigationController?.pushViewController(deletedNotesViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
