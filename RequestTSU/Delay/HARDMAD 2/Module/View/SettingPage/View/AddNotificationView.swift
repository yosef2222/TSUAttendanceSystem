//
//  AddNotificationView.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 03.03.2025.
//

import UIKit

class AddNotificationView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        
        let AddButton = UIButton(type: .system)
        AddButton.setTitle("Добавить напоминание", for: .normal)
        AddButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        AddButton.tintColor = .black
        AddButton.backgroundColor = .white
        AddButton.layer.cornerRadius = 28
        AddButton.clipsToBounds = true
        AddButton.contentHorizontalAlignment = .center
        AddButton.layer.zPosition = 1
        AddButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(AddButton)

        NSLayoutConstraint.activate([
            AddButton.topAnchor.constraint(equalTo: topAnchor),
            AddButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            AddButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            AddButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            AddButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
}
