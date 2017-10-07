//
//  EventImageViewTableViewCell.swift
//  Sangha Teacher
//
//  Created by Ezhil on 04/10/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit
import PINRemoteImage

class EventImageViewTableViewCell: UITableViewCell {

    @IBOutlet weak var imgVw: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func loadContentView(event : Event) {
        guard let attachmentObj = event.attachments?.first, let imageURL = attachmentObj.url else {
            self.imgVw.image = nil
            return
        }
        self.imgVw.pin_setImage(from: URL(string: imageURL))
    }
}
