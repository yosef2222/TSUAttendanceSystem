//
//  MainViewController.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 03.03.2025.
//


import UIKit

class StatisticsViewController: UIViewController {
    
    private var model: StatisticsModel!
    
    private let pageViewControllerContainer = UIView()
    private let gradientLayer = CAGradientLayer()
    
    private var selectedIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        model = StatisticsModel()
        setupLayout()
        setupPageViewController()
        setupGradient()
    }
    
    private func setupLayout() {
        view.addSubview(pageViewControllerContainer)
        
        pageViewControllerContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageViewControllerContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -16),
            pageViewControllerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewControllerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewControllerContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8)
        ])
    }
    
    private func setupPageViewController() {
        let pageVC = PageViewController(transitionStyle: .scroll, navigationOrientation: .vertical, options: nil)
        
        addChild(pageVC)
        pageViewControllerContainer.addSubview(pageVC.view)
        pageVC.view.frame = pageViewControllerContainer.bounds
        pageVC.didMove(toParent: self)
    }
    
    private func setupGradient() {
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.8).cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 100)
        gradientLayer.position = CGPoint(x: view.bounds.midX, y: pageViewControllerContainer.frame.maxY - 50)
        view.layer.addSublayer(gradientLayer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 100)
        gradientLayer.position = CGPoint(x: view.bounds.midX, y: pageViewControllerContainer.frame.maxY - 50)
    }
}
