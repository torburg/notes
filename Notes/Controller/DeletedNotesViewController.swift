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
        
        reloadData()
        // Do any additional setup after loading the view.
    }

    func reloadData() {
        let notebook = FileNotebook()
        let loadDeletedOp = LoadOperation(notebook: notebook)
        loadDeletedOp.deletedLoad()
        guard let notes = loadDeletedOp.result else {
            return
        }
        self.noteList = notes
    }
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
