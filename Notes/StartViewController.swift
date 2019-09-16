//
//  StartViewController.swift
//  Notes
//
//  Created by Maksim Torburg on 06/08/2019.
//  Copyright © 2019 Maksim Torburg. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    let noteList = FileNotebook.generateNotebook()
    let reuseIdentifier = "noteCell"
    
    @IBOutlet weak var tableView: UITableView!
//
//    @IBAction func showSecondView(_ sender: Any) {
//        let secondViewController = SecondViewController()
//        navigationController?.pushViewController(secondViewController, animated: true)
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: nil)
        
        tableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        // Do any additional setup after loading the view.
    }
}

extension StartViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Today \(Date())"
        case 1:
            return "Tomorrow"
        case 2:
            return "Future"
        default:
            return "All"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NoteTableViewCell
        let note = noteList[indexPath.row]
//
        cell.onBind(note)
//        cell.noteText.text = note.content

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let note = noteList[indexPath.row]
//        let text = note.content
        
        let noteViewController = NoteViewController()
        noteViewController.note = note
//        noteViewController.content = text

        navigationController?.pushViewController(noteViewController, animated: true)
    }
}
