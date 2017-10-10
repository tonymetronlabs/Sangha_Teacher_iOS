//
//  ActionItemTabView.swift
//  Sangha Teacher
//
//  Created by Ashfauck on 10/10/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit

class ActionItemModel: NSObject {
    
    var aiType : AiType = .none
    var isSelected : Bool = false
    
    static let shared = ActionItemModel()
    
    func parse(aiTypeArray:[AiType],selectedType:AiType) -> [ActionItemModel]
    {
        var tempArray:[ActionItemModel] = []
        
        for obj in aiTypeArray
        {
            let actionObj = ActionItemModel()
            
            actionObj.aiType = obj
         
            actionObj.isSelected = (obj == selectedType) ? true : false
            
            tempArray.append(actionObj)
        }
        
        return tempArray
    }
    
}

protocol ActionItemTabViewDelegate {
    func didSelectItem(aiTypeModel:ActionItemModel)
}

class ActionItemTabView: UIView {

    var view: UIView!
    var actionItemArray:[ActionItemModel] = []
    
    @IBOutlet var actionItemsCollectionView: UICollectionView!
    
    var aiTypeArray:[AiType] = []
    
    var delegate : ActionItemTabViewDelegate?
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        xibSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    func updateAiType(aiTyes:[AiType],selectedType:AiType)
    {
        self.aiTypeArray = aiTyes
        
        self.actionItemArray = ActionItemModel.shared.parse(aiTypeArray: aiTyes, selectedType: selectedType)
        
        self.actionItemsCollectionView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now())
        {
            self.setSelectedAiType(selectedAiType: selectedType)
        }
    }
    
    func setSelectedAiType(selectedAiType:AiType)
    {
        let aitypes = self.actionItemArray.map{$0.aiType}
        
        guard let selectedIndex = aitypes.index(of: selectedAiType) else { return }
        
        self.deselectPreviousIndexAndSelectCurrentIndex(IndexPath(item: selectedIndex, section: 0))
    }
    
    func xibSetup()
    {
        view = loadViewFromNib()
        
        self.actionItemsCollectionView.register(ActionItemCollectionViewCell.nib, forCellWithReuseIdentifier: ActionItemCollectionViewCell.identifier)
        
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        let view = ActionItemTabView.nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    

}

extension ActionItemTabView : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if actionItemArray.count > 2 {
            return  1000 * actionItemArray.count
        }
        
        return actionItemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let actionItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: ActionItemCollectionViewCell.identifier, for: indexPath) as! ActionItemCollectionViewCell
        
        actionItemCell.updateUI(aiTypeModel: actionItemArray[indexPath.item % actionItemArray.count])
        
        return actionItemCell
    }
    
    fileprivate func deselectPreviousIndexAndSelectCurrentIndex(_ indexPath: IndexPath)
    {
        for (index,obj) in actionItemArray.enumerated() {
            
            if indexPath.item % actionItemArray.count == index
            {
                obj.isSelected = true
            }
            else
            {
                obj.isSelected = false
            }
        }
        
        self.actionItemsCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.left, animated: false)
        
        self.actionItemsCollectionView.reloadData()

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        deselectPreviousIndexAndSelectCurrentIndex(indexPath)
        
        if self.delegate != nil {
            self.delegate?.didSelectItem(aiTypeModel: actionItemArray[indexPath.item % actionItemArray.count])
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let actionObj = actionItemArray[indexPath.item % actionItemArray.count]
        
        let widthFloat = actionObj.aiType.title.widthOfString(usingFont: UIFont(name:AppFont.appFontRegular , size: 25)!)
        
        return CGSize(width: 30 + widthFloat , height: 68)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        let collectionViewWidth = collectionView.frame.size.width/2
        
        let leftWidth = collectionViewWidth - (collectionViewWidth / 2)/2
        
        return UIEdgeInsetsMake(0, 0, 0, leftWidth)
    }
}

