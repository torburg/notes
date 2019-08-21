//
//  NoteTableViewCell.swift
//  Notes
//
//  Created by Maksim Torburg on 14/08/2019.
//  Copyright © 2019 Maksim Torburg. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var noteText: UILabel!
    @IBOutlet weak var noteColor: UIView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
