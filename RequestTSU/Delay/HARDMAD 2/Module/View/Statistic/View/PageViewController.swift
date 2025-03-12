//
//  PageViewController.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 03.03.2025.
//


import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {

    private var pages: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self

        let circlesVC = CirclesViewController()

        let TableWeakVC = TableViewController()
        
        let emotionDay = EmotionsTodayViewController()

        pages = [circlesVC, TableWeakVC, emotionDay]

        if let firstPage = pages.first {
            setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController), currentIndex > 0 else {
            return nil
        }
        return pages[currentIndex - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController), currentIndex < pages.count - 1 else {
            return nil
        }
        return pages[currentIndex + 1]
    }
}


