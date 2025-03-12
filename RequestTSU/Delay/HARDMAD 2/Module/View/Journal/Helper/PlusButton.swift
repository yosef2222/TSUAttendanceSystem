//
//  PlusButton.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 21.02.2025.
//

import UIKit

class PlusButtonView: UIView {
    let plusButton: UIButton
    
    override init(frame: CGRect) {
        self.plusButton = UIButton(type: .system)
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        self.plusButton = UIButton(type: .system)
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let icon = UIImage(named: "Add_icon")?.withRenderingMode(.alwaysOriginal) {
            plusButton.setImage(icon.withTintColor(.black), for: .normal)
        }
        plusButton.tintColor = .black
        plusButton.accessibilityIdentifier = "plusButton"
        plusButton.backgroundColor = .white
        plusButton.layer.cornerRadius = 32
        plusButton.clipsToBounds = true
        plusButton.contentHorizontalAlignment = .center
        plusButton.layer.zPosition = 1
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        let plusText = UILabel()
        plusText.text = "Добавить запись"
        plusText.textAlignment = .center
        plusText.font = UIFont.systemFont(ofSize: 14)
        plusText.textColor = .white
        plusText.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(plusButton)
        addSubview(plusText)
        
        NSLayoutConstraint.activate([
            plusButton.topAnchor.constraint(equalTo: topAnchor),
            plusButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            plusButton.widthAnchor.constraint(equalToConstant: 64),
            plusButton.heightAnchor.constraint(equalToConstant: 64)
        ])
        
        NSLayoutConstraint.activate([
            plusText.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: -8),
            plusText.leadingAnchor.constraint(equalTo: leadingAnchor),
            plusText.trailingAnchor.constraint(equalTo: trailingAnchor),
            plusText.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
