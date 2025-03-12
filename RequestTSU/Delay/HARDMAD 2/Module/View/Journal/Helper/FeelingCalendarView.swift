//
//  FeelingCalendarView.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 22.02.2025.
//

import UIKit

class FeelingCalendarView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        let plusButton = UIButton()
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let icon = UIImage(named: "Add_icon")?.withRenderingMode(.alwaysOriginal) {
            plusButton.setImage(icon.withTintColor(.black), for: .normal)
        }
        
        plusButton.tintColor = .black
        plusButton.backgroundColor = .white
        plusButton.layer.cornerRadius = 32
        plusButton.clipsToBounds = true
        plusButton.contentHorizontalAlignment = .center
        plusButton.layer.zPosition = 1
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(plusButton)
        
        NSLayoutConstraint.activate([
            plusButton.topAnchor.constraint(equalTo: topAnchor),
            plusButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            plusButton.widthAnchor.constraint(equalToConstant: 64),
            plusButton.heightAnchor.constraint(equalToConstant: 64)
        ])
    }
}
