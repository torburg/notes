//
//  StartViewController.swift
//  Notes
//
//  Created by Maksim Torburg on 06/08/2019.
//  Copyright © 2019 Maksim Torburg. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    let noteList = FileNotebook.basicNotesList
    let reuseIdentifier = "note cell"
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func showSecondView(_ sender: Any) {
        let secondViewController = SecondViewController()
        navigationController?.pushViewController(secondViewController, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notes"
        
        tableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
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

extension StartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NoteTableViewCell
        let note = noteList[indexPath.row]
        cell.title.text = note.title
        cell.noteText.text = note.content
        cell.noteColor.backgroundColor = note.color
//        cell.imageView?.backgroundColor = .black
//        cell.textLabel?.text = note.title
//        cell.detailTextLabel?.text = note.content
//        cell.accessoryType = .disclosureIndicator
        
//        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
//
//        if cell == nil {
//            cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
//            print("new cell")
//        } else {
//            print("reuse cell")
//        }
//
//        let note = noteList[indexPath.row]
//        cell.imageView?.backgroundColor = .black
//        cell.textLabel?.text = note.title
//        cell.detailTextLabel?.text = note.content
//        cell.accessoryType = .disclosureIndicator
        
//        cell.accessoryView
        
        return cell
    }
    
    
}
