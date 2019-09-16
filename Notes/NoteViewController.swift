//
//  NoteViewController.swift
//  Notes
//
//  Created by Maksim Torburg on 15/08/2019.
//  Copyright © 2019 Maksim Torburg. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {

    @IBOutlet weak var noteText: UITextView!
    
    var note: Note?

    override func viewDidLoad() {
        super.viewDidLoad()
        noteText.text = note?.content
        // Do any additional setup after loading the view.
    }
}
