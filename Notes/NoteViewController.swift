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
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var importancePicker: UIPickerView!
    
    var note: Note? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let note = self.note else {
            return
        }
        
//        if let content = note?.content {
            self.noteText.text = note.content
//        }r
        
        datePicker.minimumDate = Date()
//        if let category = note?.category {
            let rowIndexCategory = Category.allCases.firstIndex(of: note.category)!
            categoryPicker.selectRow(rowIndexCategory, inComponent: 0, animated: true)
//        }
//        if let importance = note?.importance {
            let rowIndexImportance = Importance.allCases.firstIndex(of: note.importance)!
            importancePicker.selectRow(rowIndexImportance, inComponent: 0, animated: true)
//        }
    }
}

extension NoteViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoryPicker {
            return Category.allCases.count
        } else if pickerView == importancePicker {
            return Importance.allCases.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == categoryPicker {
            return Category.allCases[row].rawValue
        } else if pickerView == importancePicker {
            return Importance.allCases[row].rawValue
        }
        return "Default"
    }
    
    
}
