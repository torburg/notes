//
//  NoteViewController.swift
//  Notes
//
//  Created by Maksim Torburg on 04/11/2019.
//  Copyright © 2019 Maksim Torburg. All rights reserved.
//

import UIKit

class CellViewController: UIViewController {
    
    var data: Note?

    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var importancePicker: UIPickerView!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var expirationDatePicker: UIDatePicker!
    @IBAction func saveNoteButton(_ sender: Any) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        guard let note = data else { return }
        contentTextView.text = note.content
    }
}

extension CellViewController {

}
