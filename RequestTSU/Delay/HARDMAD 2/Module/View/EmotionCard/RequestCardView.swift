//
//  EmotionCard.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 25.02.2025.
//

import UIKit

class RequestCardView: UIView {
    // MARK: - UI Elements
    var reasonLabel: UILabel
    var dateLabel: UILabel
    var timeLabel: UILabel
    var statusLabel: UILabel
    private var contentView: UIView
    private var gradientLayer: CAGradientLayer?

    // MARK: - Initialization
    init(frame: CGRect, startDate: String, endDate: String, startTime: String, endTime: String, reason: String, status: String) {
        self.reasonLabel = UILabel()
        self.dateLabel = UILabel()
        self.timeLabel = UILabel()
        self.statusLabel = UILabel()
        self.contentView = UIView()
        super.init(frame: frame)
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
        setupView(startDate: startDate, endDate: endDate, startTime: startTime, endTime: endTime, reason: reason, status: status)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI
    private func setupView(startDate: String, endDate: String, startTime: String, endTime: String, reason: String, status: String) {
        self.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .lStaticB
        
        // Configure dateLabel and timeLabel
        if startDate == endDate {
            dateLabel.text = startDate
            dateLabel.textAlignment = .left
            timeLabel.text = "\(startTime) - \(endTime)"
        } else {
            dateLabel.text = "\(startDate) - \(startTime)"
            dateLabel.textAlignment = .left
            timeLabel.text = "\(endDate) - \(endTime)"
        }
        
        dateLabel.textColor = .white
        dateLabel.font = UIFont(name: "VelaSansGX-ExtraLight_Regular", size: UIScreen.main.bounds.width / 25)
        
        timeLabel.textColor = .white
        timeLabel.font = UIFont(name: "VelaSansGX-ExtraLight_Regular", size: UIScreen.main.bounds.width / 25)
        
        reasonLabel.text = reason
        reasonLabel.textColor = .white
        reasonLabel.font = UIFont(name: "VelaSansGX-ExtraLight_Regular", size: UIScreen.main.bounds.width / 25)
        
        if status == "Pending" {
            statusLabel.text = "На проверке"
        } else if status == "Rejected" {
            statusLabel.text = "Отказано"
        } else if status == "Approved" {
            statusLabel.text = "Принято"
        }
        
        statusLabel.textColor = .white
        statusLabel.font = UIFont(name: "VelaSansGX-ExtraLight_Regular", size: UIScreen.main.bounds.width / 20)
        
        // Configure contentView
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        
        // Add subviews to contentView
        contentView.addSubview(dateLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(reasonLabel)
        contentView.addSubview(statusLabel)
        
        // Убедимся, что все элементы имеют translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        reasonLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints
        NSLayoutConstraint.activate([
            // contentView занимает всю область карточки
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // dateLabel
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            dateLabel.heightAnchor.constraint(equalToConstant: 20),
            
            // timeLabel
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            timeLabel.heightAnchor.constraint(equalToConstant: 20),
            
            // reasonLabel
            reasonLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            reasonLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            reasonLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 8),
            
            // statusLabel
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            statusLabel.topAnchor.constraint(equalTo: reasonLabel.bottomAnchor, constant: 8),
            statusLabel.heightAnchor.constraint(equalToConstant: 25)
        ])

        if status == "Pending" {
            setupGradientBackground(color: .lorange)
        } else if status == "Rejected" {
            setupGradientBackground(color: .lred)
        } else if status == "Approved" {
            setupGradientBackground(color: .lgreen)
        }
    }

    // MARK: - Gradient Background
    private func setupGradientBackground(color: UIColor) {
        gradientLayer?.removeFromSuperlayer()

        let gradient = CAGradientLayer()
        gradient.colors = [
            color.withAlphaComponent(0.3).cgColor,
            color.withAlphaComponent(0.2).cgColor,
            color.withAlphaComponent(0.1).cgColor,
            color.withAlphaComponent(0.0).cgColor
        ]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.frame = self.bounds
        gradient.cornerRadius = self.layer.cornerRadius
        self.layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = self.bounds
    }
}
