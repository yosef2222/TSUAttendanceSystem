//
//  PlusButtonView.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 24.02.2025.
//


import UIKit

class LeftButtonView: UIView {
    let leftButton: UIButton
    
    override init(frame: CGRect) {
        self.leftButton = UIButton(type: .system)
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        self.leftButton = UIButton(type: .system)
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let icon = UIImage(named: "Arrow Left")?.withRenderingMode(.alwaysOriginal) {
            leftButton.setImage(icon.withTintColor(.white), for: .normal)
        }
        leftButton.backgroundColor = .lStaticB
        leftButton.accessibilityIdentifier = "leftButton"
        leftButton.layer.cornerRadius = 20
        leftButton.clipsToBounds = true
        leftButton.contentHorizontalAlignment = .center
        leftButton.layer.zPosition = 1
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(leftButton)
        
        NSLayoutConstraint.activate([
            leftButton.topAnchor.constraint(equalTo: topAnchor),
            leftButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            leftButton.widthAnchor.constraint(equalTo: widthAnchor),
            leftButton.heightAnchor.constraint(equalTo: heightAnchor) 
        ])
    }
}
