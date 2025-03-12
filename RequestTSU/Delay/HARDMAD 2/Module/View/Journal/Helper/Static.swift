//
//  Static.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 21.02.2025.
//

import UIKit

class StaticButtonView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let statButton = UIButton(type: .system)
        statButton.setTitle("4 записи", for: .normal)
        statButton.tintColor = .white
        statButton.backgroundColor = .lStaticB
        statButton.layer.cornerRadius = 16
        statButton.clipsToBounds = true
        statButton.contentHorizontalAlignment = .center
        statButton.layer.zPosition = 1
        statButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(statButton)
        
        let entryButton = UIButton(type: .system)
        entryButton.setTitle("в день: 2 записи", for: .normal)
        entryButton.tintColor = .white
        entryButton.backgroundColor = .lStaticB
        entryButton.layer.cornerRadius = 16
        entryButton.clipsToBounds = true
        entryButton.contentHorizontalAlignment = .center
        entryButton.layer.zPosition = 1
        entryButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(statButton)
        
        let dayButton = UIButton(type: .system)
        dayButton.setTitle("в день: 2 записи", for: .normal)
        dayButton.tintColor = .white
        dayButton.backgroundColor = .lStaticB
        dayButton.layer.cornerRadius = 16
        dayButton.clipsToBounds = true
        dayButton.contentHorizontalAlignment = .center
        dayButton.layer.zPosition = 1
        dayButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dayButton)
        
        let seriesButton = UIButton(type: .system)
        seriesButton.setTitle("серия: 0 дней", for: .normal)
        seriesButton.tintColor = .white
        seriesButton.backgroundColor = .lStaticB
        seriesButton.layer.cornerRadius = 16
        seriesButton.clipsToBounds = true
        seriesButton.contentHorizontalAlignment = .center
        seriesButton.layer.zPosition = 1
        seriesButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(seriesButton)
        
        NSLayoutConstraint.activate([
            statButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            statButton.topAnchor.constraint(equalTo: topAnchor),
            statButton.widthAnchor.constraint(equalToConstant: 85),
            statButton.heightAnchor.constraint(equalToConstant: 32),
                    
            dayButton.leadingAnchor.constraint(equalTo: statButton.trailingAnchor, constant: 8),
            dayButton.topAnchor.constraint(equalTo: topAnchor),
            dayButton.widthAnchor.constraint(equalToConstant: 127),
            dayButton.heightAnchor.constraint(equalToConstant: 32),
                    
            seriesButton.leadingAnchor.constraint(equalTo: dayButton.trailingAnchor, constant: 8),
            seriesButton.topAnchor.constraint(equalTo: topAnchor),
            seriesButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            seriesButton.widthAnchor.constraint(equalToConstant: 113),
            seriesButton.heightAnchor.constraint(equalToConstant: 32)
                ])
    }
}
