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
    @IBAction func saveNoteButton(_ sender: UIButton) {
        guard let note = data else {
            return
        }
        guard let content = contentTextView.text, !content.isEmpty else {
            let alert = UIAlertController(title: "Text field is empty",
                                          message: nil,
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return
        }
        let importanceIndex = importancePicker.selectedRow(inComponent: 0)
        let importance = Importance.allCases[importanceIndex]
        let expirationDate = expirationDatePicker.date
        let categoryIndex = categoryPicker.selectedRow(inComponent: 0)
        let category = Category.allCases[categoryIndex]
        let noteToSave = Note(uid: note.uid,
                              position: note.position,
                              content: content,
                              importance: importance,
                              expirationDate: expirationDate,
                              category: category,
                              reminder: false)
        let save = SaveOperation(noteToSave, to: FileNotebook.shared)
        save.main()
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    func configureView() {
        guard let note = data else { return }
        contentTextView.text = note.content
        let importance = note.importance
        let importanceIndex = Importance.allCases.firstIndex(of: importance)!
        importancePicker.selectRow(importanceIndex, inComponent: 0, animated: false)
        let category = note.category
        let categoryIndex = Category.allCases.firstIndex(of: category)!
        categoryPicker.selectRow(categoryIndex, inComponent: 0, animated: false)
        expirationDatePicker.setDate(note.expirationDate, animated: false)
    }
}

extension CellViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case importancePicker:
            return Importance.allCases.count
        case categoryPicker:
            return Category.allCases.count
        default:
            return 1
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case importancePicker:
            return Importance.allCases[row].rawValue
        case categoryPicker:
            return Category.allCases[row].rawValue
        default:
            return ""
        }
    }
}
