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
    var delegate : SelectAisTypeDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.categoryCollectionView.dataSource = self
        self.categoryCollectionView.delegate = self
        categoryCollectionView.register(UINib(nibName: "StatusCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "statusCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    static var identifier: String {
        return String(describing: self)
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

        let categoryValue = Float(aisObj.total! / 3)

        if Float(currentValue) < categoryValue {
            cell.circularSlider.tintColor = UIColor.init(hex: 0xFA3DAB, alpha: 1.0)
        }
        else if Float(currentValue) >= categoryValue, Float(currentValue) < 2*categoryValue {
            cell.circularSlider.tintColor = UIColor.init(hex: 0xFAE16F, alpha: 1.0)
        }
        else {
            cell.circularSlider.tintColor = UIColor.init(hex: 0x3BE8BF, alpha: 1.0)
        }

        let ais = AiType(rawValue: aisObj.aiType!)
        cell.categoryImageView.image = ais?.placeholderImageView
        cell.circularSlider.valueMaximum = Float(maxValue)
        cell.circularSlider.valueMinimum = 0
        cell.circularSlider.value = Float(currentValue)
        cell.categoryNameLabel.text = ais?.title
        cell.categoryStatusCountLabel.text = "\(currentValue)/\(maxValue)"

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard self.eventObj?.ais != nil, let ais = self.eventObj?.ais?[indexPath.row], let aisType = AiType(rawValue: ais.aiType!) else{
            return
        }
        self.delegate?.didSelect(aisType: aisType, eventObj: self.eventObj!)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.frame.size.width - 40)/3
        return CGSize(width: width, height: width < 115 ? 115 : width)
    }
}
