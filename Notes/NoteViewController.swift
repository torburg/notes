//
//  NoteViewController.swift
//  Notes
//
//  Created by Maksim Torburg on 15/08/2019.
//  Copyright © 2019 Maksim Torburg. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {

    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var noteText: UITextView!
    
//    override var title: String?
//    var content: String?
    var note: Note?
    
//    @IBOutlet weak var whiteImage: UIImageView!
//    @IBOutlet weak var redImage: UIImageView!
//    @IBOutlet weak var greenImage: UIImageView!
    
//    private var content: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTitle.text = note?.title
        noteText.text = note?.content
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
