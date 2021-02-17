//
//  NoteTableViewCell.swift
//  Fisherman's diary
//
//  Created by Егор Никитин on 06.02.2021.
//

import UIKit

final class NoteTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    private var note: Note?
    
    @IBOutlet private var imageViewNote: UIImageView!
    @IBOutlet private var nameNote: UILabel!
    @IBOutlet private var dateUpdateNote: UILabel!
    @IBOutlet private var locationNote: UILabel!
    
    public func configureCellNote(note: Note) {
        self.note = note
        
        if let imageSmall = note.imageSmall {
            imageViewNote.image = UIImage(data: imageSmall)
        } else {
            imageViewNote.image = UIImage(named: "note")
        }
        imageViewNote.layer.cornerRadius = imageViewNote.frame.height / 2
        imageViewNote.layer.masksToBounds = true
        imageViewNote.layer.borderWidth = 2
        imageViewNote.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        nameNote.text = note.name
        dateUpdateNote.text = note.dateUpdateString
        locationNote.text = note.location == nil ? "" : "Location"
    }
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
