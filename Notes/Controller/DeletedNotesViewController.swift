//
//  DeletedNotesViewController.swift
//  Notes
//
//  Created by Maksim Torburg on 19/11/2019.
//  Copyright © 2019 Maksim Torburg. All rights reserved.
//

import UIKit

class DeletedNotesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var noteList = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Deleted Notes"
        tableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: NoteTableViewCell.reuseIdentifier)
        
        reloadDate()
        // Do any additional setup after loading the view.
    }

    func reloadDate() {
        self.noteList = FileNotebook.shared.loadDeletedNotes()
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

extension DeletedNotesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.reuseIdentifier, for: indexPath) as! NoteTableViewCell
        cell.onBind(noteList[indexPath.row])
        return cell
    }
}
