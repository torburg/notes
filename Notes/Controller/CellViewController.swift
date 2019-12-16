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
    let placeholder = "Type note text here"

    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var importancePicker: UIPickerView!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var expirationDatePicker: UIDatePicker!
    @IBAction func saveNoteButton(_ sender: UIButton) {
        saveNote()
    }

    private func saveNote() {
        guard let content = contentTextView.text,
            !content.isEmpty,
            contentTextView.text != placeholder else {
                let alert = UIAlertController(title: "Text field is empty",
                                              message: nil,
                                              preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
                return
        }
        guard let note = data else {
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
        contentTextView.returnKeyType = .done
        guard let note = data else {
            contentTextView.text = placeholder
            contentTextView.textColor = .lightGray
            return
        }
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

extension CellViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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

extension CellViewController: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            contentTextView.resignFirstResponder()
        }
        return true
    }

    public func textViewDidBeginEditing(_ textView: UITextView) {
        if contentTextView.text == placeholder {
            contentTextView.text = ""
            contentTextView.textColor = .black
        }
    }

    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if contentTextView.text.isEmpty {
            contentTextView.text = placeholder
            contentTextView.textColor = .lightGray
        }
        return true
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        contentTextView.text = textView.text
        if data == nil {
            let content = contentTextView.text!
            let importanceIndex = importancePicker.selectedRow(inComponent: 0)
            let importance = Importance.allCases[importanceIndex]
            let categoryIndex = categoryPicker.selectedRow(inComponent: 0)
            let category = Category.allCases[categoryIndex]
            data = Note(uid: UUID().uuidString,
                        position: 0,
                        content: content,
                        importance: importance,
                        expirationDate: expirationDatePicker.date,
                        category: category,
                        reminder: false
            )
        }
    }
}
