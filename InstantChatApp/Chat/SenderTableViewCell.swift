//
//  SenderTableViewCell.swift
//  InstantChatApp
//
//  Created by Admin Macappstudio on 25/05/21.
//

import UIKit

class SenderTableViewCell: UITableViewCell {

    @IBOutlet weak var ChatView: UIView!
    @IBOutlet weak var ChatTextLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
