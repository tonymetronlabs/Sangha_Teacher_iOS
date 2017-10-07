//
//  EventStatusTableViewCell.swift
//  Sangha Teacher
//
//  Created by Balaji on 07/10/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit

class EventStatusTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryCollectionView: UICollectionView!
    var eventObj : Event?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.categoryCollectionView.dataSource = self
        self.categoryCollectionView.delegate = self
        categoryCollectionView.register(UINib(nibName: "StatusCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "statusCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func loadContentView(event : Event) {
        self.eventObj = event
        self.categoryCollectionView.reloadData()
    }
}

extension EventStatusTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.eventObj?.ais != nil ? (self.eventObj?.ais?.count)! : 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell : StatusCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "statusCollectionViewCell", for: indexPath) as! StatusCollectionViewCell

        guard let aisObj = self.eventObj?.ais![indexPath.row], let maxValue = aisObj.total, let currentValue = aisObj.acceptCount else {
            return cell
        }

        cell.circularSlider.valueMaximum = Float(maxValue)
        cell.circularSlider.valueMinimum = 0
        cell.circularSlider.value = Float(maxValue - 20)
        cell.categoryNameLabel.text = aisObj.aiType?.capitalized
        cell.categoryStatusCountLabel.text = "\(currentValue)/\(maxValue)"

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.frame.size.width - 40)/3
        return CGSize(width: width, height: width < 115 ? 115 : width)
    }
}
