//
//  EmotionCards.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 27.02.2025.
//

import UIKit

class RequestCardsView: UIView {
    var emotionCards: [RequestCardView] = [] {
        didSet {
            updateCards()
        }
    }
    
    private let contentView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func updateCards() {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        
        var previousCard: RequestCardView?
        
        for card in emotionCards {
            card.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(card)
            
            NSLayoutConstraint.activate([
                card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                card.heightAnchor.constraint(equalToConstant: 156),
                card.widthAnchor.constraint(equalToConstant: 340)
            ])
            
            if let previousCard = previousCard {
                card.topAnchor.constraint(equalTo: previousCard.bottomAnchor, constant: 16).isActive = true
            } else {
                card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
            }
            
            previousCard = card
        }
        
        if let lastCard = previousCard {
            contentView.bottomAnchor.constraint(equalTo: lastCard.bottomAnchor, constant: 16).isActive = true
        }
    }
}
