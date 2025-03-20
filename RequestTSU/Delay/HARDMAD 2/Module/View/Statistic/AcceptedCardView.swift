//
//  AcceptedCardView.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 20.03.2025.
//

import UIKit

class AcceptedCardView: UIView {
    // MARK: - UI Elements
    var reasonLabel: UILabel
    var dateLabel: UILabel
    var timeLabel: UILabel
    var statusLabel: UILabel
    var nameLabel: UILabel
    private var contentView: UIView
    private var gradientLayer: CAGradientLayer?

    // MARK: - Initialization
    init(frame: CGRect, startDate: String, endDate: String, startTime: String, endTime: String, reason: String, status: String, name: String) {
        self.reasonLabel = UILabel()
        self.dateLabel = UILabel()
        self.timeLabel = UILabel()
        self.statusLabel = UILabel()
        self.contentView = UIView()
        self.nameLabel = UILabel()
        super.init(frame: frame)
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
        setupView(startDate: startDate, endDate: endDate, startTime: startTime, endTime: endTime, reason: reason, status: status, name: name)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView(startDate: String, endDate: String, startTime: String, endTime: String, reason: String, status: String, name: String) {
        self.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .lStaticB
        
        if startDate == endDate {
            dateLabel.text = startDate
            dateLabel.textAlignment = .left
            timeLabel.text = "\(startTime) - \(endTime)"
        } else {
            dateLabel.text = "\(startDate) - \(startTime)"
            dateLabel.textAlignment = .left
            timeLabel.text = "\(endDate) - \(endTime)"
        }
        nameLabel.text = name
        nameLabel.textAlignment = .right
        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont(name: "VelaSansGX-ExtraLight_Regular", size: UIScreen.main.bounds.width / 25)
        
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
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(reasonLabel)
        contentView.addSubview(statusLabel)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        reasonLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            dateLabel.heightAnchor.constraint(equalToConstant: 20),
            
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            timeLabel.heightAnchor.constraint(equalToConstant: 20),
            
            reasonLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            reasonLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            reasonLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 8),
            
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

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = self.bounds
    }
}
