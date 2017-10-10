//
//  ActionItemsViewController.swift
//  Sangha Teacher
//
//  Created by Ashfauck on 10/9/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit

class ActionItemsViewController: UIViewController {

    var actionItemPageViewController = UIPageViewController()
    var actionItemsArray:[AiType] = []
    var selectedActionItem:AiType = .none

    @IBOutlet var actionItemView: ActionItemTabView!
    
    @IBOutlet var actionItemsView: UIView!
    
    //MARK: Action Item View Controllers
    
    let rsvpViewController:RSVPViewController = {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let rsvpViewController = storyboard.instantiateViewController(withIdentifier: "RSVPViewController") as! RSVPViewController
        
        return rsvpViewController
        
    }()
    
    let formViewController:FormViewController = {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let formViewController = storyboard.instantiateViewController(withIdentifier: "FormViewController") as! FormViewController
        
        return formViewController
        
    }()
    
    let volunteerViewController:VolunteerViewController = {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let volunteerViewController = storyboard.instantiateViewController(withIdentifier: "VolunteerViewController") as! VolunteerViewController
        
        return volunteerViewController
        
    }()
    
    let paymentViewController:PaymentViewController = {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let paymentViewController = storyboard.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
        
        return paymentViewController
        
    }()
    
    let toBringViewController:ToBringViewController = {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let toBringViewController = storyboard.instantiateViewController(withIdentifier: "ToBringViewController") as! ToBringViewController
        
        return toBringViewController
        
    }()
    
    //MARK: View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        actionItemView.updateAiType(aiTyes: actionItemsArray, selectedType: selectedActionItem)
        actionItemView.delegate = self
        setUpPageviewController()
        
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Set Up Page View Controller
    
    fileprivate func setUpPageviewController()
    {
        self.actionItemPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "ActionItemPageViewController") as! UIPageViewController
        
        self.actionItemPageViewController.view.frame = CGRect(origin: CGPoint.zero, size: self.actionItemsView.frame.size)
        
        self.actionItemPageViewController.delegate = self
        self.actionItemPageViewController.dataSource = self
        self.actionItemPageViewController.setViewControllers([self.viewControllerAtIndex(aiType: selectedActionItem)], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        
        self.addChildViewController(self.actionItemPageViewController)
        self.actionItemsView.addSubview(self.actionItemPageViewController.view)
        self.actionItemPageViewController.didMove(toParentViewController: self)
    }
    
    //MARK:Get ViewController At Index
    
    func viewControllerAtIndex(aiType:AiType) -> UIViewController
    {
        let viewcontrollerIndex = actionItemsArray.flatMap { (actionItem) -> Int? in
            
            if actionItem == aiType {
                return actionItemsArray.index(of: actionItem)!
            }
            return nil
        }.first
        
        guard let index = viewcontrollerIndex else { return UIViewController() }
        
        switch actionItemsArray[index]
        {
        case .none:
            return UIViewController()
        case .rsvp:
                    rsvpViewController.pageId = index
            return rsvpViewController
        case .form:
                    formViewController.pageId = index
            return formViewController
        case .volunteer:
                    volunteerViewController.pageId = index
            return volunteerViewController
        case .toBring:
                    toBringViewController.pageId = index
            return toBringViewController
        case .payment:
                    paymentViewController.pageId = index
            return paymentViewController
        case .ptm:
            return UIViewController()
        }
        
    }
    
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem)
    {
        self.dismiss(animated: true, completion: nil)
    }

}

extension ActionItemsViewController : UIPageViewControllerDelegate,UIPageViewControllerDataSource
{

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {

        guard completed else {
            return
        }
        
        guard let selectedIndex = pageViewController.viewControllers?[0].pageId else { return  }
        
        actionItemView.setSelectedAiType(selectedAiType: self.actionItemsArray[selectedIndex])
        
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if self.actionItemsArray.count > 1
        {
            var index = viewController.pageId
            
            if index == 0 {
                
                return self.viewControllerAtIndex(aiType: actionItemsArray[actionItemsArray.count - 1])
            }
            
            index = index - 1
            
            return self.viewControllerAtIndex(aiType: self.actionItemsArray[index])
        }
        else
        {
            return nil
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if self.actionItemsArray.count > 1 {
            
            var index = viewController.pageId
            
            index = index + 1
            
            if index == self.actionItemsArray.count
            {
                return  self.viewControllerAtIndex(aiType: self.actionItemsArray[0])
            }
            
            return self.viewControllerAtIndex(aiType: self.actionItemsArray[index])
        }else
        {
            return nil
        }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return  0 //self.actionItemsArray.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let index = self.actionItemsArray.index(of: selectedActionItem) else { return 0 }
        return index
    }
    
}

extension ActionItemsViewController: ActionItemTabViewDelegate
{
    
    func didSelectItem(aiTypeModel: ActionItemModel)
    {
        self.actionItemPageViewController.setViewControllers([self.viewControllerAtIndex(aiType: aiTypeModel.aiType)], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
    
}


